#!/usr/bin/env python3
"""Genera `lib/l10n/app_localizations.dart` a partir de `l10n/strings.json`.

El catálogo de textos vive en `l10n/strings.json` para mantener una única
fuente de verdad en español e inglés. Este script produce una clase tipada:

    l10n.appName                  -> String
    l10n.stampsProgress(3, 10)    -> String con marcadores reemplazados

Uso:  python3 tool/generate_l10n.py
"""

from __future__ import annotations

import json
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
SOURCE = ROOT / "l10n" / "strings.json"
OUTPUT = ROOT / "lib" / "l10n" / "app_localizations.dart"

LOCALES = ("es", "en")
LOCALE_CLASSES = {"es": "AppLocalizationsEs", "en": "AppLocalizationsEn"}

HEADER = """// GENERATED CODE - DO NOT MODIFY BY HAND.
//
// Fuente: l10n/strings.json
// Regenerar con: python3 tool/generate_l10n.py

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Textos de la aplicación en español (predeterminado) e inglés.
abstract class AppLocalizations {
  const AppLocalizations();

  static const List<Locale> supportedLocales = <Locale>[
    Locale('es'),
    Locale('en'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final AppLocalizations? localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    if (localizations != null) return localizations;
    return const $ES_CLASS();
  }

  static AppLocalizations forLocale(Locale locale) =>
      locale.languageCode == 'en' ? const $EN_CLASS() : const $ES_CLASS();

  /// Locale que representa esta instancia.
  Locale get locale;

  /// Busca `key` en el catálogo y reemplaza los marcadores de `args`.
  String translate(String key, [Map<String, String>? args]);
"""

DELEGATE = """
final class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
        (Locale supported) => supported.languageCode == locale.languageCode,
      );

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture<AppLocalizations>(AppLocalizations.forLocale(locale));

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
"""


def camel(parts: list[str]) -> str:
    words = [word for part in parts for word in part.split("_") if word]
    head, *tail = words
    return head + "".join(word[:1].upper() + word[1:] for word in tail)


def placeholders(text: str) -> list[str]:
    return list(dict.fromkeys(re.findall(r"\{(\w+)\}", text)))


def escape(value: str) -> str:
    return value.replace("\\", "\\\\").replace("'", r"\'").replace("$", r"\$")


def collect(node: dict, prefix: list[str], entries: list[tuple]) -> None:
    for key, value in node.items():
        path = prefix + [key]
        if isinstance(value, dict) and all(locale in value for locale in LOCALES):
            entries.append((path, value))
        elif isinstance(value, dict):
            collect(value, path, entries)
        else:
            raise SystemExit(f"Entrada inválida en {'.'.join(path)}: {value!r}")


def render_member(path: list[str], values: dict) -> str:
    dart_name = camel(path)
    key = "_".join(path)
    params = placeholders(values["es"])
    for locale in LOCALES:
        if placeholders(values[locale]) != params:
            raise SystemExit(f"Marcadores distintos entre idiomas en {key}")

    if not params:
        return f"  String get {dart_name};"

    signature = ", ".join(f"Object {param}" for param in params)
    return f"  String {dart_name}({signature});"


def render_impl(path: list[str], values: dict) -> str:
    dart_name = camel(path)
    key = "_".join(path)
    params = placeholders(values["es"])
    if not params:
        return f"  @override\n  String get {dart_name} => translate('{key}');"

    signature = ", ".join(f"Object {param}" for param in params)
    pairs = ", ".join(f"'{param}': '${param}'" for param in params)
    return (
        f"  @override\n"
        f"  String {dart_name}({signature}) => translate('{key}', "
        f"<String, String>{{{pairs}}});"
    )


def render_locale(locale: str, entries: list[tuple]) -> str:
    class_name = LOCALE_CLASSES[locale]
    members = "\n".join(render_member(path, values) for path, values in entries)
    catalog = "\n".join(
        f"    '{'_'.join(path)}': '{escape(values[locale])}',"
        for path, values in entries
    )
    implementations = "\n\n".join(
        render_impl(path, values) for path, values in entries
    )
    return f"""
final class {class_name} extends AppLocalizations {{
  const {class_name}();

  static const Map<String, String> _strings = <String, String>{{
{catalog}
  }};

  @override
  Locale get locale => const Locale('{locale}');

  @override
  String translate(String key, [Map<String, String>? args]) {{
    var value = _strings[key] ?? key;
    if (args != null) {{
      args.forEach((String name, String replacement) {{
        value = value.replaceAll('{{$name}}', replacement);
      }});
    }}
    return value;
  }}

{members}

{implementations}
}}
"""


def main() -> int:
    data = json.loads(SOURCE.read_text(encoding="utf-8"))
    entries: list[tuple] = []
    collect(data, [], entries)
    entries.sort(key=lambda item: "_".join(item[0]))

    names = [camel(path) for path, _ in entries]
    duplicates = {name for name in names if names.count(name) > 1}
    if duplicates:
        raise SystemExit(f"Claves duplicadas: {sorted(duplicates)}")

    header = (
        HEADER.replace("$ES_CLASS", LOCALE_CLASSES["es"]).replace(
            "$EN_CLASS", LOCALE_CLASSES["en"]
        )
    )
    body = "\n".join(
        render_member(path, values) for path, values in entries
    )
    sections = "\n".join(
        render_locale(locale, entries) for locale in LOCALES
    )
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(
        header + "\n" + body + "\n}\n" + sections + DELEGATE,
        encoding="utf-8",
    )
    print(f"{OUTPUT.relative_to(ROOT)}: {len(entries)} textos ({'/'.join(LOCALES)})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
