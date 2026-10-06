#!/usr/bin/env python3
"""Revisiones estructurales del proyecto Flutter.

Este entorno no cuenta con el SDK de Flutter, así que este script actúa como
red de seguridad para detectar los errores más comunes al escribir código a
mano:

1. Delimitadores desbalanceados ({}, (), []) ignorando strings y comentarios.
2. Imports relativos o `package:punto_plus/...` que apuntan a archivos que no
   existen.
3. Imports propios que no se usan (el proyecto no debe generar warnings).
4. Uso de claves de `AppLocalizations` que no existen en el catálogo.
5. Uso de rutas `AppRoutes.<x>` que no están declaradas.
6. Clases públicas declaradas dos veces.

Uso: python3 tool/check_codebase.py
"""

from __future__ import annotations

import dataclasses
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
PACKAGE = "punto_plus"
SKIP_DIRS = {"build", ".dart_tool", ".git", "ios", "android", "web", "tool"}


@dataclasses.dataclass
class Issue:
    path: pathlib.Path
    line: int
    message: str

    def render(self) -> str:
        return f"{self.path.relative_to(ROOT)}:{self.line}: {self.message}"


def dart_files() -> list[pathlib.Path]:
    files: list[pathlib.Path] = []
    for base in (ROOT / "lib", ROOT / "test"):
        if not base.exists():
            continue
        for path in sorted(base.rglob("*.dart")):
            if any(part in SKIP_DIRS for part in path.parts):
                continue
            if path.name.endswith(".g.dart") or path.name.endswith(".freezed.dart"):
                continue
            files.append(path)
    return files


def strip_code(source: str) -> str:
    """Devuelve el código sin strings ni comentarios, conservando saltos."""
    out = ["\n" if ch == "\n" else " " for ch in source]
    index = 0
    length = len(source)
    while index < length:
        char = source[index]
        if char == "/" and index + 1 < length and source[index + 1] == "/":
            while index < length and source[index] != "\n":
                index += 1
            continue
        if char == "/" and index + 1 < length and source[index + 1] == "*":
            index += 2
            while index + 1 < length and not (
                source[index] == "*" and source[index + 1] == "/"
            ):
                index += 1
            index += 2
            continue
        if char in {"'", '"'}:
            has_raw_prefix = (
                index > 0 and source[index - 1] == "r"
            ) and (index < 2 or not source[index - 2].isalnum())
            triple = source[index : index + 3] == char * 3
            quote = char * 3 if triple else char
            index += len(quote)
            while index < length:
                if not has_raw_prefix and source[index] == "\\":
                    index += 2
                    continue
                if source[index : index + len(quote)] == quote:
                    index += len(quote)
                    break
                if "\n" in quote and source[index] == "\n":
                    out[index] = "\n"
                index += 1
            continue
        index += 1
    # Reencode: walk again but blank out strings/comments using the mask.
    result = list(source)
    index = 0
    while index < length:
        char = source[index]
        if char == "/" and index + 1 < length and source[index + 1] == "/":
            while index < length and source[index] != "\n":
                result[index] = " "
                index += 1
            continue
        if char == "/" and index + 1 < length and source[index + 1] == "*":
            result[index] = result[index + 1] = " "
            index += 2
            while index + 1 < length and not (
                source[index] == "*" and source[index + 1] == "/"
            ):
                if source[index] != "\n":
                    result[index] = " "
                index += 1
            if index + 1 < length:
                result[index] = result[index + 1] = " "
            index += 2
            continue
        if char in {"'", '"'}:
            has_raw_prefix = (
                index > 0 and source[index - 1] == "r"
            ) and (index < 2 or not source[index - 2].isalnum())
            triple = source[index : index + 3] == char * 3
            quote = char * 3 if triple else char
            for offset in range(len(quote)):
                result[index + offset] = " "
            index += len(quote)
            while index < length:
                if not has_raw_prefix and source[index] == "\\":
                    result[index] = result[index + 1] = " "
                    index += 2
                    continue
                if source[index : index + len(quote)] == quote:
                    for offset in range(len(quote)):
                        result[index + offset] = " "
                    index += len(quote)
                    break
                if source[index] != "\n":
                    result[index] = " "
                index += 1
            continue
        index += 1
    return "".join(result)


def check_delimiters(path: pathlib.Path, source: str, issues: list[Issue]) -> None:
    clean = strip_code(source)
    stack: list[tuple[str, int]] = []
    pairs = {")": "(", "]": "[", "}": "{"}
    line = 1
    for char in clean:
        if char == "\n":
            line += 1
            continue
        if char in "([{":
            stack.append((char, line))
        elif char in ")]}":
            if not stack or stack[-1][0] != pairs[char]:
                issues.append(Issue(path, line, f"'{char}' sin apertura"))
                return
            stack.pop()
    for char, open_line in stack:
        issues.append(Issue(path, open_line, f"'{char}' sin cierre"))


IMPORT_RE = re.compile(r"^\s*import\s+'([^']+)'(?:\s+as\s+(\w+))?\s*;", re.MULTILINE)


def declarations(source: str) -> set[str]:
    clean = strip_code(source)
    names: set[str] = set()
    patterns = (
        r"\bclass\s+([A-Za-z_]\w*)",
        r"\benum\s+([A-Za-z_]\w*)",
        r"\bmixin\s+([A-Za-z_]\w*)",
        r"\bextension\s+([A-Za-z_]\w*)",
        r"\btypedef\s+([A-Za-z_]\w*)",
        r"^\s*(?:final|const|var|late\s+final)\s+[\w<>,? .]*?\b([a-zA-Z_]\w*)\s*=",
        r"^\s*([A-Za-z_]\w*)\s+([a-zA-Z_]\w*)\s*\(",  # funciones top-level
    )
    for pattern in patterns:
        for match in re.finditer(pattern, clean, re.MULTILINE):
            groups = [group for group in match.groups() if group]
            names.add(groups[-1])
    return names


def resolve_import(
    path: pathlib.Path, target: str
) -> pathlib.Path | None:
    if target.startswith("dart:"):
        return None
    if target.startswith("package:"):
        if not target.startswith(f"package:{PACKAGE}/"):
            return None
        return ROOT / "lib" / target[len(f"package:{PACKAGE}/") :]
    return (path.parent / target).resolve()


def check_imports(path: pathlib.Path, source: str, issues: list[Issue]) -> None:
    clean = strip_code(source)
    for match in IMPORT_RE.finditer(source):
        target = match.group(1)
        resolved = resolve_import(path, target)
        if target.startswith("dart:"):
            continue
        if resolved is None:
            continue
        if not resolved.exists():
            line = source[: match.start()].count("\n") + 1
            issues.append(Issue(path, line, f"import inexistente: {target}"))
            continue
        try:
            imported_source = resolved.read_text(encoding="utf-8")
            imported = declarations(imported_source)
        except OSError:
            continue
        # Las extensiones se usan de forma implícita (context.l10n, etc.).
        if re.search(r"^\s*extension\s+", strip_code(imported_source), re.MULTILINE):
            continue
        if not imported:
            continue
        body = clean[match.end() :]
        if not any(re.search(rf"\b{re.escape(name)}\b", body) for name in imported):
            line = source[: match.start()].count("\n") + 1
            issues.append(Issue(path, line, f"import sin usar: {target}"))


L10N_RE = re.compile(r"\bl10n\.([a-zA-Z_]\w*)")


def check_l10n(source: str, available: set[str], path: pathlib.Path,
               issues: list[Issue]) -> None:
    for match in L10N_RE.finditer(source):
        name = match.group(1)
        if name not in available:
            line = source[: match.start()].count("\n") + 1
            issues.append(Issue(path, line, f"texto inexistente en l10n: {name}"))


def check_routes(source: str, available: set[str], path: pathlib.Path,
                 issues: list[Issue]) -> None:
    for match in re.finditer(r"\bAppRoutes\.([a-zA-Z_]\w*)", source):
        name = match.group(1)
        if name not in available:
            line = source[: match.start()].count("\n") + 1
            issues.append(Issue(path, line, f"ruta inexistente: AppRoutes.{name}"))


def main() -> int:
    issues: list[Issue] = []
    l10n_file = ROOT / "lib" / "l10n" / "app_localizations.dart"
    l10n_names: set[str] = set()
    if l10n_file.exists():
        l10n_names = set(
            re.findall(
                r"^\s*(?:String|Locale)\s+(?:get\s+)?([a-zA-Z_]\w*)",
                strip_code(l10n_file.read_text(encoding="utf-8")),
                re.MULTILINE,
            )
        ) | {"of", "forLocale", "delegate", "supportedLocales", "translate"}
    router_file = ROOT / "lib" / "app" / "app_routes.dart"
    route_names: set[str] = set()
    if router_file.exists():
        route_source = router_file.read_text(encoding="utf-8")
        route_names = set(
            re.findall(
                r"^\s*static\s+(?:const\s+)?[A-Za-z_][\w<>,? .]*\s+(\w+)\s*[(=;]",
                route_source,
                re.MULTILINE,
            )
        )

    class_locations: dict[str, pathlib.Path] = {}
    for path in dart_files():
        source = path.read_text(encoding="utf-8")
        check_delimiters(path, source, issues)
        check_imports(path, source, issues)
        if l10n_names:
            check_l10n(source, l10n_names, path, issues)
        if route_names:
            check_routes(source, route_names, path, issues)
        if path.parts[-2:-1] != ("test",) and "test" not in path.parts:
            for name in re.findall(r"^(?:final |abstract |sealed )?class (\w+)", source,
                                   re.MULTILINE):
                if name.startswith("_"):
                    continue
                if name in class_locations and class_locations[name] != path:
                    issues.append(
                        Issue(path, 1,
                              f"clase duplicada {name} (ya en "
                              f"{class_locations[name].relative_to(ROOT)})")
                    )
                class_locations.setdefault(name, path)

    if issues:
        for issue in issues:
            print(issue.render())
        print(f"\n{len(issues)} problema(s) encontrado(s).")
        return 1
    print(f"Sin problemas en {len(dart_files())} archivos Dart.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
