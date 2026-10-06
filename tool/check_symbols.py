#!/usr/bin/env python3
"""Verifica referencias a símbolos del proyecto sin compilador Dart.

`check_codebase.py` comprueba sintaxis, imports y claves de `l10n`/rutas, pero
no puede detectar referencias a miembros inexistentes (`AppColors.foo`) ni
argumentos con nombre inválidos en widgets propios. Este script lo hace con un
análisis textual:

1. Registra cada tipo declarado en `lib/` y `test/` y sus miembros (métodos, getters,
   campos estáticos, valores de `enum`).
2. Registra los parámetros con nombre de cada constructor declarado.
3. Busca usos `Tipo.miembro` donde `Tipo` es del proyecto y el miembro no existe.
4. Busca invocaciones con nombre `Tipo(argumento: ...)` donde el argumento no
   está declarado en el constructor.

Limitaciones conocidas (documentadas para no generar falsos positivos): no
resuelve genéricos ni sobrecargas, y solo revisa tipos declarados en `lib/`.

Uso:  python3 tool/check_symbols.py
"""

from __future__ import annotations

import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
LIB = ROOT / "lib"
TEST = ROOT / "test"

TYPE_DECL = re.compile(
    r"\b(?:abstract\s+)?(?:final\s+|sealed\s+|base\s+)?"
    r"(?P<kind>class|enum|mixin|extension)\s+(?P<name>[A-Za-z_]\w*)"
)
MEMBER_FIELD = re.compile(
    r"^\s*(?:static\s+)?(?:final|const|late|var)\s+"
    r"(?:[A-Za-z_][\w<>,\.\? ]*\s+)?(?P<name>[a-z_]\w*)\s*(?:=|;)",
    re.MULTILINE,
)
MEMBER_GETTER = re.compile(r"^\s*(?:static\s+)?[\w<>,\.\?\[\] ]+\s+get\s+(?P<name>[a-z_]\w*)", re.MULTILINE)
MEMBER_METHOD = re.compile(r"^[ \t]*(?:static\s+)?(?:[\w<>,\.\?\[\] ]+\s+)?(?P<name>[a-z_]\w*)\s*\(", re.MULTILINE)
ENUM_VALUE = re.compile(r"(?P<name>[A-Za-z_]\w*)\s*(?:\(|,|;|$)")

CTOR = re.compile(
    r"(?<![.\w])(?:const\s+|factory\s+)?(?P<name>[A-Z]\w*)"
    r"(?:\.(?P<ctor>[a-zA-Z_]\w*))?\s*\(",
)
NAMED_CTOR = re.compile(r"\bfactory\s+(?P<name>[A-Z]\w*)(?:\.(?P<ctor>[a-zA-Z_]\w*))?\s*\(")
CTOR_WITHOUT_BODY = re.compile(
    r"^[ \t]*(?:const\s+|static\s+)?(?P<name>[A-Z]\w*)\.(?P<ctor>[a-z]\w*)\s*\(",
    re.MULTILINE,
)
DEFERRED = re.compile(r"\b(?:typedef|const|final|var)\s+(?P<name>[A-Za-z_]\w*)")
REFERENCE = re.compile(r"\b(?P<type>[A-Z]\w*)\.(?P<member>[a-zA-Z_]\w*)")
CALL = re.compile(r"\b(?P<type>[A-Z]\w*)\s*\(")


def strip_code(source: str) -> str:
    """Quita comentarios y literales de cadena."""
    out = []
    i = 0
    length = len(source)
    while i < length:
        char = source[i]
        if char == "/" and i + 1 < length and source[i + 1] == "/":
            i = source.find("\n", i)
            if i == -1:
                break
            continue
        if char == "/" and i + 1 < length and source[i + 1] == "*":
            end = source.find("*/", i)
            i = length if end == -1 else end + 2
            continue
        if char in "'\"":
            quote = char
            triple = source.startswith(quote * 3, i)
            terminator = quote * 3 if triple else quote
            i += len(terminator)
            while i < length:
                if source[i] == "\\":
                    i += 2
                    continue
                if source.startswith(terminator, i):
                    i += len(terminator)
                    break
                i += 1
            out.append('""')
            continue
        out.append(char)
        i += 1
    return "".join(out)


def call_arguments(source: str, open_paren: int) -> str:
    """Devuelve el texto de los argumentos de una llamada, sin anidar paréntesis."""
    depth = 0
    i = open_paren
    while i < len(source):
        char = source[i]
        if char in "([{":
            depth += 1
        elif char in ")]}":
            depth -= 1
            if depth == 0:
                return source[open_paren + 1 : i]
        i += 1
    return source[open_paren + 1 :]


def top_level_keys(arguments: str) -> list[str]:
    """Extrae las claves `nombre:` de los argumentos de primer nivel."""
    keys: list[str] = []
    depth = 0
    current = ""
    parts: list[str] = []
    for char in arguments:
        if char in "([{":
            depth += 1
        elif char in ")]}":
            depth -= 1
        if char == "," and depth == 0:
            parts.append(current)
            current = ""
            continue
        current += char
    parts.append(current)
    for part in parts:
        match = re.match(r"\s*(?:const\s+)?(?P<name>[a-z]\w*)\s*:", part)
        if match:
            keys.append(match.group("name"))
    return keys


def split_top_level(text: str) -> list[str]:
    """Separa `text` por comas de primer nivel."""
    parts: list[str] = []
    depth = 0
    current = ""
    for char in text:
        if char in "([{<":
            depth += 1
        elif char in ")]}>":
            depth -= 1
        if char == "," and depth == 0:
            parts.append(current)
            current = ""
            continue
        current += char
    parts.append(current)
    return parts


def parameter_names(text: str) -> list[str]:
    """Extrae los nombres declarados en una lista de parámetros."""
    names: list[str] = []
    for part in split_top_level(text):
        chunk = re.sub(r"\b(required|covariant)\b", "", part)
        chunk = chunk.split("=", 1)[0].strip().rstrip(",").strip()
        if not chunk:
            continue
        match = re.search(r"\b([a-zA-Z_]\w*)\s*\??$", chunk)
        if match:
            names.append(match.group(1))
    return names


def body_of(source: str, start: int) -> tuple[str, int]:
    """Devuelve el cuerpo entre llaves que empieza en `start` (índice de `{`)."""
    depth = 0
    i = start
    while i < len(source):
        if source[i] == "{":
            depth += 1
        elif source[i] == "}":
            depth -= 1
            if depth == 0:
                return source[start + 1 : i], i
        i += 1
    return source[start + 1 :], len(source)


def main() -> int:
    files = sorted(
        list(LIB.rglob("*.dart"))
        + [path for path in TEST.rglob("*.dart") if "qr_reference_test" not in path.name]
    )
    sources: dict[pathlib.Path, str] = {}
    for path in files:
        sources[path] = strip_code(path.read_text(encoding="utf-8"))

    members: dict[str, set[str]] = {}
    enums: set[str] = set()
    ctors: dict[str, set[str]] = {}
    declared_types: set[str] = set()

    for code in sources.values():
        declared_types.update(m.group("name") for m in TYPE_DECL.finditer(code))

    for path, code in sources.items():
        for match in TYPE_DECL.finditer(code):
            name = match.group("name")
            kind = match.group("kind")
            brace = code.find("{", match.end())
            if brace == -1:
                continue
            if kind == "extension":
                continue
            body, _ = body_of(code, brace)
            declared = members.setdefault(name, set())
            if kind == "enum":
                enums.add(name)
                values = code[match.end() : brace] + "," + body.split(";")[0]
                for value in ENUM_VALUE.finditer(values):
                    declared.add(value.group("name"))
            declared.update(m.group("name") for m in MEMBER_FIELD.finditer(body))
            declared.update(m.group("name") for m in MEMBER_GETTER.finditer(body))
            declared.update(
                m.group("name")
                for m in MEMBER_METHOD.finditer(body)
                if m.group("name") not in {"if", "for", "while", "switch", "return", "assert", "catch"}
            )
            for ctor in CTOR_WITHOUT_BODY.finditer(code[match.start() : brace] + body):
                if ctor.group("name") == name:
                    declared.add(ctor.group("ctor"))
        for match in CTOR.finditer(code):
            if match.group("name") not in declared_types:
                continue
            arguments = call_arguments(code, match.end() - 1)
            if not arguments.lstrip().startswith("{"):
                continue  # no es un constructor con parámetros con nombre
            if "(" in arguments.split("{", 1)[0]:
                continue
            inner = arguments.strip().strip("{}") if arguments.strip().endswith("}") \
                else arguments.strip().lstrip("{")
            params = set(parameter_names(inner))
            target = ctors.setdefault(match.group("name"), set())
            target.update(params)
            target.update(re.findall(r"\bthis\.([a-zA-Z_]\w*)", arguments))
            if match.group("ctor"):
                members.setdefault(match.group("name"), set()).add(match.group("ctor"))
        for match in NAMED_CTOR.finditer(code):
            if match.group("ctor"):
                members.setdefault(match.group("name"), set()).add(match.group("ctor"))
            else:
                members.setdefault(match.group("name"), set())
        for match in DEFERRED.finditer(code):
            members.setdefault(match.group("name"), set())

    project_types = set(members) | set(ctors)
    problems: list[str] = []

    for path, code in sources.items():
        for match in REFERENCE.finditer(code):
            type_name = match.group("type")
            member = match.group("member")
            if type_name not in project_types:
                continue
            known = members.get(type_name)
            if known is None:
                continue
            if not known and type_name not in enums:
                continue
            if member in known or member == "new":
                continue
            problems.append(
                f"{path}: {type_name}.{member} no está declarado en {type_name}"
            )

        for match in CALL.finditer(code):
            type_name = match.group("type")
            if type_name not in ctors:
                continue
            before = code[max(0, match.start() - 12) : match.start()]
            if before.rstrip().endswith("."):
                continue  # constructor con nombre: Tipo.nombre(…)
            for key in top_level_keys(call_arguments(code, match.end() - 1)):
                if key in ctors[type_name] or key == "key":
                    continue
                problems.append(
                    f"{path}: argumento con nombre inválido '{key}:' en {type_name}(…)"
                )

    for problem in dict.fromkeys(problems):
        print(problem)
    if problems:
        print(f"\n{len(dict.fromkeys(problems))} problema(s) encontrado(s).")
        return 1
    print(f"Sin problemas de símbolos en {len(files)} archivos Dart.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
