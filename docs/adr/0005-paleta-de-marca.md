# 0005. Paleta de marca entregada en lugar del `#6C5CE7` del brief

- **Fecha**: 2026-01
- **Estado**: Aceptada

## Contexto

El brief mencionaba Material 3 con semilla `#6C5CE7` (violeta). El módulo de
acceso ya entregado y aprobado usa la identidad de marca de Punto+:
`#007D8D` (teal) → `#1AA5B7` (cyan) con `#003F60` (azul profundo) y `#FFA15E`
(naranja) como acento.

## Decisión

- Mantener la identidad ya entregada y construir el tema claro/oscuro con
  `AppPalette` (brand, brandStrong, brandSoft, accent, semánticos y superficies).
- Exponer la paleta como extensión de `ThemeData` para que el modo oscuro no
  duplique constantes.

## Consecuencias

- Coherencia visual con la app ya publicada y con los materiales de marca.
- Si se decide adoptar el violeta del brief, se cambia `AppColors` y la paleta:
  ninguna pantalla usa colores literales fuera de esos archivos.
