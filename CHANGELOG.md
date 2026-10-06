# Changelog

Todos los cambios relevantes de Punto+. El formato sigue
[Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y el proyecto usa
[Conventional Commits](https://www.conventionalcommits.org/es/v1.0.0/).

## [No publicado]

### Añadido

- **Cliente (app completa de fidelidad)**
  - Portada de tarjetas con progreso de sellos animado, insignias de tarjeta
    completada y estado de verificación de cuenta.
  - Detalle de tarjeta con historial de sellos, premio y acceso al código QR.
  - Pantalla de QR con brillo al máximo, temporizador de expiración y
    regeneración manual del código.
  - Mapa de negocios con marcadores agrupados (clustering propio), filtros por
    categoría/distancia/favoritos y ubicación manual cuando la app no tiene
    permisos de GPS.
  - Buscador, favoritos y ficha de negocio con tarjetas y promociones.
  - Premios (disponibles, canjeados, expirados) y promociones activas.
  - Perfil: edición de datos, ajustes (tema, idioma, avisos, ubicación),
    notificaciones con contador de no leídas y programa de referidos.
  - Pantallas legales (términos, privacidad, acerca de) y de ayuda.
- **Modo negocio**
  - Panel con métricas y gráficas de sellos por día y clientes frecuentes.
  - CRUD de tarjetas de fidelidad con logo, fondo e icono de sello.
  - Escáner de QR del cliente para registrar compras (entrada manual de códigos
    como respaldo cuando no hay cámara disponible).
  - CRUD de promociones y listado de clientes leales con detalle por tarjeta.
- **Arquitectura**
  - Clean Architecture feature-first (`data`, `domain`, `presentation`) con
    Riverpod para estado e inyección de dependencias y go_router con guardas de
    sesión y de rol.
  - Capa de red con Dio: interceptores de autenticación, errores, registro y
    monitor de conexión; `401 → refresh → reintento` con cola de solicitudes.
  - Sesión persistida en `flutter_secure_storage` con restauración en el
    arranque mediante refresh token.
  - Internacionalización es/en con catálogo propio (`l10n/strings.json`),
    tema claro/oscuro y paleta Material 3 derivada de la marca.
  - Generador de código QR propio (ISO/IEC 18004) con vista en `CustomPainter`,
    verificado contra implementaciones independientes.
- **Herramientas y documentación**
  - `tool/generate_l10n.py`, `tool/check_codebase.py`,
    `tool/check_symbols.py`, `tool/verify_qr_encoder.py` y
    `tool/generate_qr_tables.py` para verificar el proyecto sin SDK de Flutter.
  - `docs/api_contract.md` con el contrato completo de la API, `.env.example`
    con las variables de compilación y este CHANGELOG.

### Cambios

- `RegisterRequest` envía `name` + `email` **o** `phone` según el identificador
  elegido, junto con `password_confirmation`, `role` y `accept_terms`.
- Los mensajes de error de red se resuelven con el catálogo de traducciones
  (`AppException.messageKey`) y se muestran en el idioma activo.

### Notas de integración

- `google_maps_flutter`, `mobile_scanner`, `qr_flutter`, `fl_chart`, `lottie` y
  `shimmer` no se pudieron descargar en el entorno de desarrollo (sin acceso a
  pub.dev). Sus funciones están cubiertas con implementaciones propias sin
  dependencias nativas: mapa esquemático con clustering, encoder QR propio,
  gráficas con `CustomPainter` y animaciones con `AnimationController`. Al
  integrar los paquetes, las interfaces de `lib/core/platform` permiten
  sustituirlos sin tocar la capa de presentación.
