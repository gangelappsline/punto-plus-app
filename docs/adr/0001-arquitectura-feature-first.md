# 0001. Clean Architecture feature-first con Riverpod

- **Fecha**: 2026-01
- **Estado**: Aceptada

## Contexto

La app tiene dos roles (cliente y negocio) y unas 40 pantallas. Necesitamos una
organización que permita trabajar en paralelo sin conflictos, sustituir la capa
de red en pruebas y escalar a nuevos módulos.

## Decisión

- Cada feature vive en `lib/features/<feature>/` con `data`, `domain` y
  `presentation`.
- El `domain` declara interfaces (`AuthRepository`, `BusinessRepository`, …); la
  implementación vive en `data` y habla con un datasource que usa Dio.
- Riverpod expone el grafo completo en `lib/core/providers`, y los controladores
  de presentación usan `Notifier`/`AsyncNotifier`.
- go_router centraliza la navegación con guardas de sesión y de rol en
  `app_router.dart`; las pantallas nunca navegan con `Navigator` directo.

## Consecuencias

- Las pantallas dependen de abstracciones: las pruebas inyectan repositorios
  falsos con `overrideWithValue`.
- Hay más archivos por feature, pero cada cambio queda contenido.
- Los servicios del dispositivo se aíslan en `lib/core/platform` porque los
  paquetes nativos no están disponibles en este entorno.
