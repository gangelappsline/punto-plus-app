# 0003. Mapa esquemático propio y puertos de plataforma

- **Fecha**: 2026-01
- **Estado**: Aceptada

## Contexto

`google_maps_flutter` no pudo descargarse en el entorno de desarrollo. La
pantalla de mapa es requisito del brief: marcadores agrupados, filtros y
ubicación del usuario.

## Decisión

- `MapCanvas` dibuja el mapa con `CustomPainter`: proyección equirectangular,
  rejilla de referencia, marcadores agrupados por cercanía, hit-test, arrastre y
  zoom con gestos, y barra de escala.
- Los datos vienen de `NearbyBusinesses` (repositorio + filtros del proveedor),
  de modo que la fuente de datos no depende del widget de mapa.
- La ubicación se resuelve con `LocationService`; sin permisos hay selección
  manual de área (`ManualLocationService.areas`).
- Las claves nativas (`GOOGLE_MAPS_API_KEY`) ya están cableadas en
  `AndroidManifest.xml` y `Info.plist` para cuando se integre el SDK.

## Consecuencias

- La app funciona en cualquier plataforma sin claves de mapas y sin coste de API.
- Al integrar Google Maps se sustituye solo el widget: filtros, clustering
  lógico y favoritos se reutilizan.
