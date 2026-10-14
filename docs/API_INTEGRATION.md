# Conectar Punto Plus sin adivinar el contrato

## Información que debe proporcionar el backend

Se necesita OpenAPI/Swagger, una colección Postman o documentación equivalente,
con ejemplos **anonimizados**, nunca claves privadas o tokens de usuarios reales.

1. **URL y versión**: prefijo exacto, paginación, envoltorio `data`, tipos de IDs,
   formato de errores, campos nulos, fechas y zona horaria.
2. **Autenticación**: login/registro, mecanismo (Passport no implica un grant
   concreto), access/refresh tokens, expiración, revocación, perfil y roles.
   Ningún `client_secret` de OAuth debe incluirse en el binario móvil.
3. **Cartera**: listado/detalle, saldo, meta, tarjetas activas, expiraciones,
   pertenencia del cliente, reglas y autoridad de canje.
4. **QR**: quién lo emite, payload opaco/firmado, duración, invalidación, prevención
   de replay, relación cliente-negocio y validación en servidor.
5. **Compras y canjes**: identificador idempotente, clave/nombre del header, alcance,
   periodo de retención, recibo, conflictos, reversos y control de concurrencia.
6. **Negocios**: coordenadas, búsqueda, radio, categorías, horarios, logos y URLs.
7. **Diseños y promociones**: endpoints, multipart, nombres de campo, MIME,
   límites de tamaño, autorización por negocio, vigencia y zona horaria.
8. **Notificaciones** (si se añaden): registro/revocación de token push, permisos,
   eventos, deep links y política de privacidad.

## Cambios a realizar cuando exista el contrato

- Añadir DTOs remotos y mappers a `features/*/data/`; mantener las entidades de
  dominio libres de sobres HTTP. Revisar si los modelos necesitan nuevos campos.
- Implementar `ApiWalletRepository`, `ApiBusinessRepository` y
  `ApiDiscoverRepository` con el Dio de `apiClientProvider`.
- Sustituir las ramas `ContractUnavailable` de los providers por esos adapters.
- Incorporar `AuthRepository`, sesión persistida validada en servidor y pantallas
  de login/registro reales. El selector de roles demo no puede autorizar nada.
- Al salir, revocar si el contrato lo define, limpiar tokens y todos los snapshots
  de la cuenta. No reutilizar la base demo para datos reales.
- No asumir refresh token: implementar renovación coordinada únicamente si está
  documentada; evitar bucles ante 401 y rechazar respuestas tardías de otra sesión.
- Emisión de QR solo por backend. El esquema `puntoplus-demo://stamp` debe seguir
  limitado a demo y no aceptarse nunca como prueba de una compra real.
- Confirmar saldos exclusivamente con respuestas del servidor. Tras timeout de
  escritura, consultar/reintentar la MISMA operación idempotente, no una nueva.
- Persistir imágenes en almacenamiento remoto validado, no rutas locales como URLs.
- Añadir `CachedWalletRepository` para lecturas reales con fallback de transporte.
  No usar caché para esconder errores de autenticación/autorización, ni para
  autorizar canjes. Definir TTL y mostrar siempre cuándo se guardó la copia.
- Añadir pruebas de contrato y pruebas end-to-end contra staging con cuentas de prueba.

## Infraestructura ya preparada

`createApiClient` exige HTTPS, restringe origen, impide redirecciones automáticas,
aplica timeouts, lee bearer desde Keychain/Keystore y mapea errores sin exponer
cuerpos internos. No hay logging de tokens. Un 401 del token actual limpia la sesión.
No se reintentan automáticamente escrituras. Esto es infraestructura, no una
integración validada con `api.punto-plus.com.mx`.

El servidor debe aplicar la autorización por cliente y negocio incluso si el
cliente móvil tiene guardas de navegación. Todos los controles locales se pueden
modificar; no deben ser la autoridad de una recompensa real.
