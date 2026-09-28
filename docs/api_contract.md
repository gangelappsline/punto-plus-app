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
