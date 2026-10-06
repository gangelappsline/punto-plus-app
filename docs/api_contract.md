# Contrato esperado de autenticación

La capa de datos está preparada para el siguiente contrato. La propiedad `data` es opcional: también se acepta el objeto de sesión directamente en la raíz.

## Inicio de sesión

`POST /auth/login`

```json
{
  "identifier": "tu.email@ejemplo.com",
  "identifier_type": "email",
  "password": "contraseña-segura"
}
```

`identifier_type` admite `email` o `phone`.

## Registro

`POST /auth/register`

```json
{
  "name": "Ana Pérez",
  "identifier": "+525500000000",
  "identifier_type": "phone",
  "password": "contraseña-segura"
}
```

## Respuesta de sesión

```json
{
  "data": {
    "access_token": "ey...",
    "refresh_token": "ey...",
    "expires_in": 3600,
    "user": {
      "id": "usr_123",
      "display_name": "Ana Pérez",
      "email": "ana@ejemplo.com",
      "phone": "+525500000000",
      "avatar_url": "https://cdn.ejemplo.com/avatar.png",
      "points": 1250
    }
  }
}
```

También puede enviarse `expires_at` como fecha ISO 8601. Los alias camelCase (`accessToken`, `refreshToken`, `expiresIn`, `displayName`, `avatarUrl`) son aceptados.

## Renovación de token

`POST /auth/refresh`

```json
{
  "refresh_token": "ey..."
}
```

Respuesta mínima:

```json
{
  "access_token": "ey...",
  "refresh_token": "ey...",
  "expires_in": 3600
}
```

Ante un `401`, las solicitudes se serializan, se renueva la sesión una vez y se reintenta la petición original. Si la renovación falla, los tokens locales se eliminan.

## Recuperar contraseña

`POST /auth/forgot-password`

```json
{
  "identifier": "tu.email@ejemplo.com",
  "identifier_type": "email"
}
```

Una respuesta `200` o `204` indica que las instrucciones fueron enviadas. Por seguridad, el backend debería responder igual aunque la cuenta no exista.

## Acceso social

- `POST /auth/google`
- `POST /auth/apple`

```json
{
  "identity_token": "token-del-proveedor",
  "authorization_code": "código-opcional"
}
```

Ambos endpoints deben responder con una sesión estándar.

## Cerrar sesión

`POST /auth/logout`

Header:

```text
Authorization: Bearer <access_token>
```

Los datos locales se eliminan incluso si el backend no está disponible.

## Errores

Formato recomendado:

```json
{
  "code": "invalid_credentials",
  "message": "Correo o contraseña incorrectos",
  "errors": {
    "identifier": ["El correo no existe"]
  }
}
```

La app interpreta `message`, `error`, `code` y `errors`. Timeouts, desconexión, `401` y `429` reciben mensajes locales en español.

## Seguridad recomendada para backend

- Exigir HTTPS y validar audiencia/emisor de tokens sociales.
- Usar access tokens de corta duración y refresh token rotation.
- Invalidar el refresh token al cerrar sesión.
- Aplicar rate limiting a login, registro y recuperación.
- Nunca devolver hashes de contraseñas ni secretos OAuth.

## Tarjetas del cliente

| Método | Ruta | Uso |
| --- | --- | --- |
| `GET` | `/customer/cards` | Tarjetas del cliente con su progreso de sellos. |
| `POST` | `/customer/cards/join` | Unirse a una tarjeta con el código del negocio (`{"qr_code": "..."}`). |
| `GET` | `/customer/cards/{id}` | Detalle de una tarjeta. |
| `GET` | `/customer/cards/{id}/stamps` | Historial de sellos. |
| `GET` | `/customer/cards/{id}/qr` | Código QR vigente con su expiración. |
| `POST` | `/customer/cards/{id}/redeem` | Canjear el premio de una tarjeta completa. |

Respuesta de tarjeta (se aceptan alias `snake_case` y `camelCase`):

```json
{
  "id": "cc_123",
  "stamps_count": 4,
  "required_stamps": 10,
  "is_completed": false,
  "loyalty_card": {
    "id": "card_9",
    "name": "Café gratis",
    "required_stamps": 10,
    "business": { "id": "biz_1", "name": "Cafetería Sol" }
  }
}
```

Respuesta del QR:

```json
{
  "code": "PP-5F3A9C",
  "expires_at": "2026-10-06T18:30:00Z",
  "business_name": "Cafetería Sol",
  "card_name": "Café gratis"
}
```

## Premios, promociones, referidos y favoritos

| Método | Ruta | Uso |
| --- | --- | --- |
| `GET` | `/customer/rewards` | Premios del cliente (`status`: `available`, `redeemed`, `expired`). |
| `POST` | `/customer/rewards/{id}/redeem` | Canjear un premio. |
| `GET` | `/customer/promotions` | Promociones activas. |
| `GET` | `/customer/referral` | Código de referidos, enlace e invitados. |
| `GET` | `/customer/favorites` | Negocios favoritos. |

## Negocios (descubrimiento)

| Método | Ruta | Uso |
| --- | --- | --- |
| `GET` | `/businesses/nearby` | Negocios cercanos; acepta `latitude`, `longitude`, `radius_km`, `category`, `query`. |
| `GET` | `/businesses/{id}` | Ficha del negocio. |
| `GET` | `/businesses/{id}/cards` | Tarjetas publicadas por el negocio. |
| `GET` | `/businesses/{id}/promotions` | Promociones publicadas por el negocio. |

## Perfil y notificaciones

| Método | Ruta | Uso |
| --- | --- | --- |
| `GET` | `/profile` | Perfil autenticado. |
| `PUT/PATCH` | `/profile` | Actualizar nombre, correo o celular. |
| `POST` | `/profile/avatar` | Subir avatar (`multipart/form-data`, campo `avatar`). |
| `PUT` | `/profile/password` | Cambiar contraseña (`current_password`, `password`, `password_confirmation`). |
| `GET` | `/notifications` | Listado de notificaciones. |
| `POST` | `/notifications/{id}/read` | Marcar una notificación como leída. |

## Legal

| Método | Ruta | Uso |
| --- | --- | --- |
| `GET` | `/legal/terms` | Términos y condiciones (`title`, `updated_at`, `sections`). |
| `GET` | `/legal/privacy` | Aviso de privacidad. |

Si la API no responde, la app muestra el texto local de respaldo y mantiene la
pantalla utilizable.

## Modo negocio

Todas las rutas requieren rol `business` (o `admin`) y token válido.

| Método | Ruta | Uso |
| --- | --- | --- |
| `GET` | `/business/dashboard` | Métricas: sellos de hoy, clientes, tarjetas activas, serie por día. |
| `GET` | `/business/cards` | Tarjetas propias. |
| `POST` | `/business/cards` | Crear tarjeta. |
| `PATCH` | `/business/cards/{id}` | Actualizar tarjeta. |
| `DELETE` | `/business/cards/{id}` | Eliminar tarjeta. |
| `POST` | `/business/cards/{id}/upload-assets` | Subir logo, fondo o icono (`multipart/form-data`). |
| `GET` | `/business/promotions` | Promociones propias. |
| `POST` | `/business/promotions` | Crear promoción. |
| `PATCH` | `/business/promotions/{id}` | Actualizar promoción. |
| `DELETE` | `/business/promotions/{id}` | Eliminar promoción. |
| `GET` | `/business/customers` | Clientes leales; acepta `query`. |
| `GET` | `/business/customers/{id}` | Detalle del cliente con progreso por tarjeta. |
| `POST` | `/business/stamps/scan` | Registrar un sello leyendo el QR (`{"qr_code": "PP-..."}`). |
| `GET` | `/business/stamps/recent` | Últimos sellos registrados. |

Cuerpo de una tarjeta:

```json
{
  "name": "Café gratis",
  "required_stamps": 10,
  "description": "Junta 10 sellos",
  "reward_description": "Un café de grano",
  "background_color": "#1AA5B7",
  "is_active": true,
  "logo_url": "https://cdn.ejemplo.com/logo.png",
  "background_url": "https://cdn.ejemplo.com/fondo.png",
  "stamp_icon_url": "https://cdn.ejemplo.com/sello.png"
}
```

Cuerpo de una promoción:

```json
{
  "title": "2x1 los martes",
  "description": "Válido en mostrador",
  "starts_at": "2026-10-01T00:00:00Z",
  "ends_at": "2026-10-31T23:59:59Z",
  "is_active": true,
  "image_url": "https://cdn.ejemplo.com/promo.png"
}
```

Respuesta del escaneo:

```json
{
  "customer": { "id": "usr_9", "name": "Ana Pérez" },
  "card": { "id": "cc_123", "stamps_count": 5, "required_stamps": 10 },
  "stamps_count": 5,
  "is_completed": false
}
```

## Alias aceptados

Los modelos normalizan las respuestas con alias para tolerar variaciones del
backend:

- Fechas: `expires_at`, `expiresAt`, `valid_until`, `unlocked_at`.
- Contadores: `stamps_count`, `stampsCount`, `stamps`, `current_stamps`.
- Metas: `required_stamps`, `requiredStamps`, `stamps_required`, `stamps_to_reward`.
- Identificadores: `id`, `uuid`.
- Relaciones: `loyalty_card`, `loyaltyCard`, `business`, `business_info`.

Cualquier variación nueva se agrega en `lib/core/utils/json.dart` (helpers
`Json.pick`) y en el `fromJson` del modelo correspondiente.
