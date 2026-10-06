# Punto+

App Flutter multiplataforma (iOS + Android) del sistema de lealtad **Punto+**:
tarjetas digitales de sellos, códigos QR para acumular, premios, promociones,
mapa de negocios cercanos y un modo negocio para administrar tarjetas, escanear
compras y consultar métricas.

Consume la API REST de Laravel + Passport en `https://api.punto-plus.com.mx`.

## Contenido

- [Funciones](#funciones)
- [Stack](#stack)
- [Requisitos](#requisitos)
- [Puesta en marcha](#puesta-en-marcha)
- [Compilar y publicar](#compilar-y-publicar)
- [Firma de release](#firma-de-release)
- [Estructura](#estructura)
- [Internacionalización y tema](#internacionalización-y-tema)
- [Calidad y verificación](#calidad-y-verificación)
- [CI/CD](#cicd)
- [Documentación](#documentación)
- [Pendientes de integración](#pendientes-de-integración)

## Funciones

### Cliente

| Pantalla | Descripción |
| --- | --- |
| Splash, onboarding, bienvenida | Arranque con restauración de sesión y presentación del producto. |
| Acceso y registro | Login por correo o celular, registro, verificación con OTP de 6 dígitos, recuperación y restablecimiento de contraseña. |
| Inicio (5 pestañas) | Tarjetas, mapa, premios, promociones y perfil con navegación inferior persistente. |
| Tarjetas | Lista con progreso animado de sellos, insignias de completado, unirse con código de negocio y detalle con historial. |
| Código QR | Pantalla a brillo máximo con temporizador de expiración y regeneración del código. |
| Mapa | Marcadores agrupados por cercanía, filtros por categoría/distancia/favoritos y ubicación manual sin GPS. |
| Negocios | Buscador, favoritos y ficha con tarjetas y promociones del negocio. |
| Premios y promociones | Estados disponible/canjeado/expirado y canje de premios. |
| Perfil | Edición de datos, ajustes (tema, idioma, avisos), notificaciones y referidos. |
| Legal y ayuda | Términos, privacidad, acerca de y centro de ayuda. |

### Negocio

Panel con métricas y gráficas, CRUD de tarjetas (logo, fondo, icono de sello),
escáner de QR para registrar compras, CRUD de promociones y clientes leales con
detalle de progreso.

## Stack

- **Flutter** `>=3.47.5` / **Dart** `>=3.13.0`, Material 3.
- **flutter_riverpod** `^3.3.1`: estado e inyección de dependencias.
- **go_router** `^17.2.3`: navegación declarativa con guardas de sesión y rol.
- **dio** `^5.11.1`: HTTP con interceptores de autenticación, errores, registro
  y renovación de token (`401 → refresh → reintento`).
- **flutter_secure_storage** `^10.3.1`: tokens cifrados.
- **flutter_localizations** + catálogo propio es/en.
- **flutter_lints** `^6.0.0` con reglas adicionales.
- Arquitectura **Clean Architecture feature-first** (`data`, `domain`,
  `presentation`) y utilidades transversales en `lib/core`.

## Requisitos

- Flutter `3.47.5` estable o superior (canal estable) y Dart incluido.
- Xcode 16+ y CocoaPods para iOS; Android SDK 34+ y JDK 17 para Android.
- Acceso a la API (entorno de staging o producción) o un proxy local.

## Puesta en marcha

```bash
git clone https://github.com/gangelappsline/punto-plus-app.git
cd punto-plus-app
flutter pub get

cp .env.example .env          # ajusta API_BASE_URL y ENV
flutter run --dart-define-from-file=.env
```

Sin archivo `.env` también funciona con los valores por defecto:

```bash
flutter run \
  --dart-define=API_BASE_URL=https://api.punto-plus.com.mx/api \
  --dart-define=ENV=dev
```

| Variable | Predeterminado | Uso |
| --- | --- | --- |
| `API_BASE_URL` | `https://api.punto-plus.com.mx/api` | URL base; debe incluir `/api`. |
| `API_CONNECT_TIMEOUT_SECONDS` | `20` | Tiempo máximo para conectar/enviar. |
| `API_RECEIVE_TIMEOUT_SECONDS` | `20` | Tiempo máximo para recibir. |
| `ENV` | `dev` | `dev`, `staging` o `prod`. |
| `GOOGLE_MAPS_API_KEY` | vacío | Clave del SDK de Google Maps. |

Las variables de `--dart-define` **no son secretas**: quedan dentro del binario.
Las credenciales OAuth y las de Google/Apple viven en el backend o en la
configuración nativa del proyecto.

### Cuentas de prueba

La app no incluye credenciales: crea una cuenta desde el registro o pide al
equipo de backend un usuario de cada rol (`customer` y `business`).

## Compilar y publicar

```bash
# Android
flutter build appbundle --release \
  --dart-define-from-file=env/prod.json

# iOS (requiere macOS y perfil de firma)
flutter build ipa --release \
  --dart-define-from-file=env/prod.json
```

Para generar el APK de pruebas internas:

```bash
flutter build apk --release --dart-define-from-file=env/dev.json
```

## Firma de release

El repositorio **no versiona keystores**. Crea el keystore una sola vez y
guárdalo fuera del control de versiones:

```bash
keytool -genkeypair \
  -keystore ~/punto-plus-release.jks \
  -alias puntoplus \
  -keyalg RSA -keysize 2048 -validity 10950 \
  -dname "CN=Punto+, O=Punto+, C=MX"
```

`android/app/build.gradle.kts` lee la firma desde `key.properties` o desde
variables de entorno, en este orden:

```properties
# android/key.properties (ignorado por git; ver android/key.properties.example)
storeFile=/home/usuario/punto-plus-release.jks
storePassword=...
keyAlias=puntoplus
keyPassword=...
```

```bash
export KEYSTORE_PATH=~/punto-plus-release.jks
export KEYSTORE_PASSWORD=...
export KEY_ALIAS=puntoplus
export KEY_PASSWORD=...
```

Sin firma configurada, la compilación de release usa la firma de depuración y
queda marcada como tal.

En iOS, abre `ios/Runner.xcworkspace`, activa *Automatically manage signing* y
selecciona el equipo de desarrollo antes de archivar.

## Estructura

```text
lib/
├── app/                  # PuntoPlusApp, router y rutas
├── core/
│   ├── config/           # AppConfig (--dart-define) y ApiPaths
│   ├── constants/        # Constantes de dominio
│   ├── errors/           # AppException (traducción y errores de Dio)
│   ├── models/           # Modelos compartidos
│   ├── network/          # Dio, interceptores y monitor de conexión
│   ├── platform/         # Puertos de servicios del dispositivo
│   ├── providers/        # Grafo de proveedores (DI)
│   ├── qr/               # Codificador y vista de QR sin dependencias
│   ├── storage/          # Tokens cifrados, preferencias y caché
│   ├── theme/            # Paleta, espaciado y ThemeData claro/oscuro
│   ├── utils/            # Formatters, validadores, JSON y Result
│   └── widgets/          # Widgets compartidos
├── features/
│   ├── auth/             # Login, registro, OTP, recuperación
│   ├── cards/            # Tarjetas y QR del cliente
│   ├── rewards/          # Premios
│   ├── promotions/       # Promociones
│   ├── businesses/       # Descubrimiento, mapa, favoritos, buscador
│   ├── profile/          # Perfil, ajustes, notificaciones, referidos
│   ├── legal/            # Términos, privacidad, acerca de
│   └── business/         # Modo negocio (panel, escáner, CRUD)
├── l10n/                 # Catálogo compilado (generado)
└── shared/               # Pantallas de error compartidas
```

Cada feature se divide en `data` (DTO, datasource, repositorio), `domain`
(contrato del repositorio) y `presentation` (pantallas, widgets, controladores).
Los servicios del dispositivo (brillo, escáner, compartir, ubicación,
notificaciones) se exponen como puertos en `lib/core/platform` para poder
sustituirlos en pruebas.

## Internacionalización y tema

- Los textos viven en `l10n/strings.json` (es/en). Se compilan con
  `python3 tool/generate_l10n.py` a `lib/l10n/app_localizations.dart`; nunca se
  edita ese archivo a mano.
- Terminal de errores: `AppException.messageKey` permite mostrar mensajes de red
  traducidos y `context.localizeError(error)` resuelve el idioma activo.
- Tema claro y oscuro en `lib/core/theme`, con `AppPalette` expuesta como
  extensión de `ThemeData` y respeto por el modo del sistema.
- El idioma y el tema elegidos en Ajustes se guardan en el dispositivo.

## Calidad y verificación

```bash
flutter analyze --fatal-infos --fatal-warnings   # cero avisos
flutter test                                     # pruebas unitarias y de widgets
```

Estos dos comandos y la compilación del APK de depuración se ejecutan en CI
(`.github/workflows/ci.yml`), así que cualquier regresión de compilación se
detecta antes de fusionar.

Pruebas incluidas:

- `test/core/qr/qr_reference_test.dart`: matrices QR verificadas contra vectores
  de referencia (versión, máscara y módulos).
- `test/core/qr/qr_encoder_test.dart`: selección de versión, capacidad y errores.
- `test/core/utils/validators_test.dart`: reglas de formularios.
- `test/features/auth/...`: contrato de la API de autenticación y la pantalla de
  acceso.
- `test/features/cards/...`: progreso, QR vigente y normalización de respuestas.
- `test/core/widgets/core_widgets_test.dart`: botones, estados y rejilla de sellos.

### Verificación sin SDK de Flutter

Este repositorio se desarrolló en un entorno sin Flutter instalado, así que
incluye verificadores en Python que atrapan errores reales sin compilador:

```bash
python3 tool/check_codebase.py    # sintaxis, imports, claves l10n y rutas
python3 tool/check_symbols.py     # miembros y argumentos con nombre inexistentes
python3 tool/verify_qr_encoder.py # encoder QR vs. qrcodegen y segno
python3 tool/generate_qr_tables.py# regenera los vectores de QR de las pruebas
```

`verify_qr_encoder.py` requiere `pip install segno qrcodegen`. Los tres primeros
devuelven salida vacía cuando todo está correcto y código 1 con el detalle de los
problemas encontrados.

## CI/CD

`.github/workflows/ci.yml` ejecuta, en cada push y pull request:

1. `flutter analyze --fatal-infos --fatal-warnings`
2. `flutter test`
3. Los verificadores `tool/check_codebase.py` y `tool/check_symbols.py`

Para publicar, agrega un workflow de release que compile con
`--dart-define-from-file=env/prod.json`, firme el AAB con los secretos del
repositorio (`KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`)
y suba el artefacto a Play Console / App Store Connect.

## Documentación

- [`docs/api_contract.md`](docs/api_contract.md): endpoints, cuerpos y alias
  aceptados.
- [`docs/adr/`](docs/adr): decisiones de arquitectura.
- [`CHANGELOG.md`](CHANGELOG.md): historial de cambios.
- [`.env.example`](.env.example): variables de compilación.

## Pendientes de integración

El entorno de desarrollo usado para esta entrega no tenía acceso a pub.dev, por
lo que los siguientes paquetes no pudieron descargarse y sus funciones se
resolvieron con implementaciones propias sin dependencias nativas:

| Paquete del brief | Estado actual | Cómo integrarlo |
| --- | --- | --- |
| `google_maps_flutter` | Mapa esquemático propio (`MapCanvas`) con clustering, filtros y escala. | Agregar el paquete, leer `AppConfig.googleMapsApiKey` y sustituir `MapCanvas` conservando `NearbyBusinesses`. |
| `mobile_scanner` | `ScannerService` con entrada manual de códigos de respaldo. | Implementar `ScannerService` con el paquete y registrar el proveedor. |
| `qr_flutter` | Codificador propio verificado contra `qrcodegen` y `segno`. | Sustituir `QrView` por `QrImageView` o mantener el actual (no tiene dependencias). |
| `fl_chart` | Gráficas con `CustomPainter` en `metric_charts.dart`. | Reemplazar los widgets de gráfica manteniendo las series del panel. |
| `lottie` / `shimmer` | Animaciones con `AnimationController` y esqueletos propios. | Sustituir por las animaciones Lottie acordadas con diseño. |
| `freezed` / `riverpod_generator` / `build_runner` | Modelos inmutables y proveedores escritos a mano. | Ejecutar `dart run build_runner build` tras agregar las dependencias. |

Además:

- La **paleta** mantiene la identidad ya entregada (`#007D8D` → `#1AA5B7` con
  acento `#FFA15E`) en lugar del `#6C5CE7` del brief inicial. Ver
  [`docs/adr/0005-paleta-de-marca.md`](docs/adr/0005-paleta-de-marca.md).
- Estado de verificación de esta entrega: `flutter analyze --fatal-infos
  --fatal-warnings` sin hallazgos, `flutter test` en verde, APK de depuración
  compilado en CI y los tres verificadores de Python sin problemas. Al integrar
  los SDK nativos hay que volver a ejecutar la matriz completa.
