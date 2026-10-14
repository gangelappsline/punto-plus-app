# Validación y alcance de entrega

## Ejecutado en el entorno de desarrollo de esta entrega

- Formateo con dart_style vía WASM, configurado para Dart 3.6.0.
- Parser Tree-sitter de sintaxis Dart para los fuentes y pruebas escritos.
- Existencia de imports locales (excepto partes generadas por build_runner).
- Parseo de YAML, XML Android, plist/esquema Xcode, SVG y JSON Lottie.
- `git diff --check` para errores de whitespace.

**No hay Flutter/Dart, SDK Android ni Xcode disponibles aquí.** Tampoco hay acceso
a pub.dev ni al host de la API desde este entorno. Por tanto, **no se ejecutaron**
resolución pub, codegen, `flutter analyze`, `flutter test`, builds ni pruebas en
emulador. Los checks sintácticos no prueban tipos, compatibilidad de plugins,
resolución de dependencias o comportamiento móvil. CI está configurado, no se
presenta como una ejecución ya aprobada.

## Suites incluidas para Flutter

- QR: round-trip, formato ajeno, parámetros duplicados, vacíos y longitud.
- Tarjeta: progreso, saldo extra, inmutabilidad y serialización JSON.
- Repositorio: compras concurrentes idempotentes, persistencia tras reinicio,
  canjes, meta insuficiente, recuperación tras error, pertenencia y promociones.
- Diseño: una edición visual no puede sobrescribir saldos.
- Caché: aislamiento por usuario, guardado offline y recuperación de corrupción.
- Aplicación: guardas de rutas y rechazo de mutaciones offline/rol incorrecto.
- Dio: bearer solo al origen permitido, 401, limpieza y ausencia de reintentos.
- Widgets: entrada de cliente → tarjeta/QR; negocio → escáner sin cámara automática.

## Matriz manual antes de aprobar una versión

| Escenario | Resultado esperado |
|---|---|
| Instalación limpia sin claves Maps | Cartera y listado de negocios funcionan |
| Cliente → canjear Miga & Miel | Confirmación; 5 sellos a 0; un canje |
| Negocio → dos visitas Café Origen | 6 a 8 sellos; recompensa lista al cambiar de perfil |
| Escáner del mismo QR en frames sucesivos | Una sola confirmación; nueva compra solo tras acción explícita |
| QR de otro negocio o formato real | Error legible; no cambia el saldo |
| Cancelar confirmación de canje/compra | No cambia estado; cámara puede reanudarse |
| Denegar/revocar cámara | Entrada manual disponible y mensaje legible |
| App en background mientras escanea | Cámara detenida; recuperación al volver |
| Desconectar red/simular offline/reiniciar | Tarjetas visibles; QR y mutaciones bloqueadas |
| Reconectar | Se retoma el estado local de demo |
| Ubicación denegada/desactivada/timeout | Lista disponible; mensaje sin bloqueo |
| Ubicación permitida | Distancias calculadas y lista ordenada |
| Maps con claves restringidas válidas | Marcadores y detalle; permisos opcionales |
| Cargar logo/fondo/sello | Vista previa, guardado tras reiniciar; límite 5 MB |
| Promoción publicada/vencida/eliminada | Visible solo mientras esté vigente para cliente |
| Activar notificaciones y canjear | Notificación local; denegación no afecta canje |
| Cambiar perfil | Guardas de rutas; datos ficticios compartidos conservados |
| Reiniciar demo | Fixtures originales, sin promociones ni imágenes antiguas |
| Pantalla 320 px, tablet, texto ampliado | Scroll funcional, controles accesibles, sin overflow |
| VoiceOver/TalkBack y movimiento reducido | Etiquetas legibles y Lottie no animado al reducir movimiento |
| DEMO_MODE=false | Pantalla de contrato pendiente; ninguna llamada inventada |

## Pendientes para producción (intencionales)

Contrato API y auth real, QR emitido por servidor, refresh si existe, sincronización
remota, referidos reales, cargas multipart, push remotas si se requieren, TTL de
caché real, políticas/consentimiento definitivos, revisión de backups y privacidad,
firmas y IDs propios, iconos de publicación y validación de accesibilidad completa.

La demo no implementa contabilidad real, multiusuario real ni pagos. El ledger
local no es una protección antifraude. Las políticas de idempotencia y canje reales
son responsabilidad del backend y deben probarse como parte de la integración.
