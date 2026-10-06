# 0004. Catálogo de traducciones propio con generador

- **Fecha**: 2026-01
- **Estado**: Aceptada

## Contexto

El brief pide es + en. `intl`/`flutter_gen` requieren resolución de paquetes y
`build_runner`, que no estaban disponibles. Además los textos debían escribirse
sin ambigüedad (claves estables, revisión sencilla).

## Decisión

- Una única fuente de verdad: `l10n/strings.json` (es/en, 550+ claves).
- `tool/generate_l10n.py` genera `lib/l10n/app_localizations.dart` con un getter
  por clave y métodos con parámetros con nombre (`l10n.stampsProgress(3, 10)`).
- `AppLocalizations.of(context)` cae a español si no hay delegado (útil en
  pruebas) y `context.l10n` es el acceso corto.
- `tool/check_codebase.py` falla si una pantalla usa una clave inexistente.

## Consecuencias

- Cambiar un texto es editar JSON y regenerar: sin conflictos en archivos
  generados a mano.
- Si se migra a `flutter gen-l10n`/ARB, el JSON se puede convertir y las claves
  se mantienen.
