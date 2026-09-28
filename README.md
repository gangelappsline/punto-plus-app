# Punto+

Aplicación Flutter de la billetera de recompensas **Punto+**. Incluye la pantalla de acceso entregada, registro, validación de formularios, persistencia segura de sesión y una capa de API desacoplada.

## Stack

- Flutter **3.47.5 estable** / Dart 3.13.4.
- Material 3 con diseño responsive.
- Riverpod para estado e inyección de dependencias.
- GoRouter para navegación.
- Dio para HTTP, interceptores y renovación automática de tokens.
- Flutter Secure Storage para guardar la sesión cifrada.
- Arquitectura por feature con capas `data`, `domain` y `presentation`.

## Ejecutar

1. Instala Flutter 3.47.5 o una versión estable compatible.
2. Obtén dependencias:

   ```bash
   flutter pub get
   ```

3. Inicia la app indicando la API real:

   ```bash
   flutter run \
     --dart-define=API_BASE_URL=https://api.tudominio.com/v1
   ```

Para web:

```bash
flutter run -d chrome \
  --dart-define=API_BASE_URL=https://api.tudominio.com/v1
```

El backend debe permitir por CORS el origen web de la app. En producción sirve la web por HTTPS con HSTS para que el almacenamiento seguro web pueda usar WebCrypto correctamente.

> `https://api.example.com/v1` es solamente el valor seguro por defecto. El inicio de sesión necesita una URL real.

## Variables de compilación

| Variable | Predeterminado | Uso |
| --- | --- | --- |
| `API_BASE_URL` | `https://api.example.com/v1` | URL base de la API. |
| `API_CONNECT_TIMEOUT_SECONDS` | `20` | Tiempo máximo para conectar/enviar. |
| `API_RECEIVE_TIMEOUT_SECONDS` | `20` | Tiempo máximo para recibir respuesta. |

Nunca incluyas secretos en `--dart-define`: sus valores pueden extraerse de la aplicación. Los secretos OAuth deben mantenerse en el backend o en la configuración nativa indicada por cada proveedor.

## Contrato de API

La implementación parte de un contrato REST convencional y acepta campos `snake_case` y `camelCase`. Consulta [`docs/api_contract.md`](docs/api_contract.md) para ver endpoints y ejemplos completos.

Rutas configuradas:

- `POST /auth/login`
- `POST /auth/register`
- `POST /auth/refresh`
- `POST /auth/forgot-password`
- `POST /auth/logout`
- `POST /auth/google`
- `POST /auth/apple`
- `GET /users/me` (reservado para perfil)

Si tu backend usa otras rutas, modifica `lib/core/config/api_paths.dart`.

## Organización

```text
lib/
├── app/                         # App y rutas
├── core/
│   ├── config/                  # URL y rutas API
│   ├── errors/                  # Errores de red amigables
│   ├── network/                 # Dio + refresh automático
│   ├── providers/               # Inyección de dependencias
│   ├── storage/                 # Tokens en almacenamiento seguro
│   ├── theme/                   # Colores y tema
│   └── utils/                   # Result y validadores
└── features/
    ├── auth/
    │   ├── data/                # DTO, datasource y repositorio
    │   ├── domain/              # Contrato del repositorio
    │   └── presentation/        # Pantallas, estado y widgets
    └── home/                    # Destino temporal post-login
```

## Calidad

```bash
flutter analyze
flutter test
```

## Acceso con Google y Apple

La API y los modelos para intercambiar un `identity_token` ya están implementados. Para habilitar los botones hay que agregar los identificadores reales de Google/Apple y sus archivos nativos (`google-services.json`, `GoogleService-Info.plist`, capabilities y redirect URIs). Esos datos no se inventan ni se versionan; se obtienen de las consolas del proyecto.
