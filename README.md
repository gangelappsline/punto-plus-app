# Punto Plus · Flutter

Aplicación móvil de fidelidad para **cliente** y **negocio**, en español de México.
Arquitectura feature-first, Material 3, Riverpod y modelos Freezed.

> **Estado: implementación demo local.** No está conectada a la API de producción.
> Se acordó avanzar con datos de prueba mientras se proporciona el contrato del
> backend. No se inventaron endpoints, autenticación ni formatos QR oficiales.
> Los saldos, negocios, promociones y canjes demo no tienen valor comercial.

## Arranque

Requisitos: Flutter **3.27.4** / Dart **3.6.2** (versión fijada en CI), JDK 17,
Android SDK 35; para iOS, macOS + Xcode + CocoaPods. Android mínimo API 23,
iOS mínimo 15. Se usan dependencias directas fijadas para esa base.

```bash
# Descarga dependencias, genera modelos, formatea, analiza y ejecuta pruebas.
./tool/bootstrap.sh

# Emulador o dispositivo conectado; demo es el valor predeterminado.
flutter run --dart-define-from-file=.env.example
```

Equivalente manual:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --dart-define=DEMO_MODE=true
```

Los archivos `*.freezed.dart` y `*.g.dart` son generados: **ejecuta codegen antes
de abrir el proyecto en el analizador o compilar**. No se escriben a mano. El
`pubspec.lock` anterior correspondía a la plantilla del contador y fue retirado;
después del primer `flutter pub get` exitoso, versiona el nuevo lockfile para
fijar también las dependencias transitivas. No hay SDK Flutter en el entorno
que generó este código; resolución de dependencias y compilación quedan por validar.

## Recorrido demo

1. Entra como **cliente**: verás tres tarjetas; Miga & Miel ya tiene recompensa.
2. Abre una tarjeta: consulta sellos, muestra el QR y comparte una descripción.
3. Canjea una recompensa tras confirmar. El saldo se actualiza y persiste.
4. En **Mi perfil**, sal y entra como **negocio**. Los dos perfiles comparten un
   único cliente ficticio, intencionalmente, para probar el recorrido completo.
5. **Registrar una visita → Probar con el cliente demo** suma un sello a Café
   Origen. También puedes usar la cámara o pegar el contenido de un QR demo.
6. **Personalizar tarjeta** permite cambiar recompensa, meta, color, logo, fondo
   e icono. Las imágenes seleccionadas se copian al directorio local de la app.
7. Publica una promoción con vigencia e imagen opcional. Cambia a cliente y
   búscala en **Descubrir**. Puedes eliminarla desde el perfil de negocio.
8. Activa **Simular modo offline**: consulta las tarjetas, pero no muestres QR,
   canjees ni registres visitas. Reconectar vuelve a cargar el estado local.
9. **Reiniciar datos de prueba** restaura tarjetas y borra promociones e imágenes.

No se pide contraseña: la selección de perfil **no es autenticación**. No hay
registro real, pagos, subida al servidor, notificaciones remotas ni sincronización
multidispositivo. Compartir abre el menú nativo con texto demo, no crea un referido.
Los negocios y sus coordenadas son ejemplos, no un directorio comercial verificado.

## Funcionalidades y límites

| Área | Implementado |
|---|---|
| Cliente | Cartera, filtro por canje, detalle, sellos, QR demo, canje local confirmado |
| Negocio | Escáner QR con confirmación, entrada manual, editor de tarjeta, publicar/eliminar promociones |
| Descubrir | Búsqueda/categorías, Google Maps opcional, lista sin clave, distancias con ubicación opcional, rutas externas |
| Offline | Instantáneas versionadas por usuario, fecha de guardado, recuperación de caché corrupta, lectura sin conexión |
| UX | Material 3, diseño adaptable, estados vacíos/error/carga, animación de sellos, SVG local, Lottie de celebración |
| Dispositivo | Selección de imágenes/archivos, compartir, permisos bajo demanda, notificaciones locales opcionales |
| Red | Dio, timeouts, restricción de origen, bearer seguro, manejo 401 y errores legibles; sin endpoints no documentados |
| Calidad | Pruebas de dominio/repositorios/HTTP/rutas/widgets y workflows Android/iOS |

No se encolan escrituras offline: una cola de compras sin protocolo de servidor
podría duplicar sellos. `connectivity_plus` solo indica conectividad del dispositivo;
no demuestra que el servidor sea accesible. La futura capa remota debe tratar
los fallos de Dio y servir caché **solo para lecturas** en errores de transporte,
no ocultar 401/403 como si fueran falta de conexión.

## Arquitectura

```text
lib/
  main.dart                       # Bootstrap, preferencias e intl
  app/
    app.dart                      # MaterialApp.router, tema y locale
    providers.dart                # Composición, sesión, conectividad y casos de uso
    router.dart                   # Rutas y guardas por perfil
  core/
    config/                       # --dart-define (datos públicos)
    network/                      # Dio, fallos y contrato pendiente
    storage/                      # TokenStore sobre Keychain/Keystore
    services/                     # Imágenes locales y notificaciones
    presentation/                 # Tema, widgets compartidos, imágenes
  features/
    auth/{domain,presentation}/
    wallet/{domain,data,presentation}/
    discover/{domain,presentation}/
    business/{domain,presentation}/
    demo/data/                    # Fixtures y repositorio local transaccional
    settings/presentation/
assets/{illustrations,animations}/
test/{domain,data,network}/
docs/                             # Contrato pendiente y matriz de validación
```

- Las interfaces de dominio no dependen de Dio, preferencias ni widgets.
- `DemoRepository` implementa las interfaces de cartera, negocio y descubrimiento.
- `LoyaltyActions` es el límite de aplicación: valida rol/conexión e invalida estado.
- La UI observa `AsyncValue` y no conoce la persistencia ni construye peticiones.
- Riverpod 2.6 usa declaraciones manuales: `riverpod_annotation` está disponible,
  pero no hace falta generar providers; build_runner genera Freezed/JSON.
- La demo serializa mutaciones, persiste un documento antes de actualizar memoria
  y recuerda identificadores de operación. Es una simulación, **no seguridad financiera**.

## Google Maps

Sin claves y con `MAPS_ENABLED=false`, Descubrir usa la **lista**, no un mapa falso.
Para un mapa real, habilita Maps SDK for Android/iOS en Google Cloud y configura
claves restringidas por plataforma; no introduzcas secretos de servidor.

### Android

```bash
cp android/maps.properties.example android/maps.properties
# Completa GOOGLE_MAPS_API_KEY en ese archivo local.
flutter run --dart-define=MAPS_ENABLED=true
```

La clave entra mediante `manifestPlaceholders`. Restringe por `applicationId` y
huella SHA-1 de la firma correspondiente. El identificador actual es de desarrollo:
`com.example.punto_plus_app`; cámbialo antes de distribución.

### iOS

```bash
cp ios/Flutter/Maps.xcconfig.example ios/Flutter/Maps.xcconfig
# Completa GOOGLE_MAPS_API_KEY.
flutter run --dart-define=MAPS_ENABLED=true
```

`Info.plist` recibe el valor y `AppDelegate` inicializa Google Maps. Restringe la
clave al bundle ID real (actualmente `com.example.puntoPlusApp`). No actives el
flag sin configurar la clave nativa: el SDK necesita una clave válida.

## Permisos y almacenamiento

- **Cámara**: solo al pulsar Activar cámara; no se guardan fotos ni video.
- **Ubicación**: solo al pulsar Ordenar por cercanía; sin permisos en background.
- **Fotos/archivos**: selección explícita, PNG/JPEG hasta 5 MB. No hay subida HTTP.
- **Notificaciones**: solo tras activarlas en Mi perfil; confirmaciones locales,
  sin Firebase, tokens FCM ni envío remoto.
- **Tokens reales**: infraestructura `SecureTokenStore`; la demo no fabrica tokens.
- **Preferencias**: notificaciones, base ficticia e instantáneas no sensibles.
  Al salir se limpia la caché del perfil y el token. La base demo compartida se
  conserva para probar ambos roles; Reiniciar demo borra su contenido.
- **Imágenes descartadas del editor**: permanecen en el directorio demo hasta
  reiniciarlo. Antes de producción, añadir recolección de archivos huérfanos.
- **iOS**: elige tu equipo de firma en Xcode; revisa Keychain/entitlements y la
  configuración de privacidad al introducir autenticación real.
- **Android**: backups desactivados para no restaurar datos cifrados sin su llave.

## Integración con la API real

URL de configuración: `https://api.punto-plus.com.mx/api`, heredada del ejemplo
del repositorio. **El prefijo `/api` no está verificado contra un contrato.**

`DEMO_MODE=false` muestra una pantalla de integración pendiente. No intenta
iniciar sesión ni acceder a endpoints supuestos. Para conectarla, sigue
[docs/API_INTEGRATION.md](docs/API_INTEGRATION.md).

```bash
flutter run --dart-define=DEMO_MODE=false \
  --dart-define=API_BASE_URL=https://api.punto-plus.com.mx/api
```

## Pruebas y compilación

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze --fatal-infos
flutter test --coverage
flutter build apk --debug --dart-define=DEMO_MODE=true
# Solo macOS:
flutter build ios --simulator --debug --no-codesign --dart-define=DEMO_MODE=true
```

Para revisión adicional con Very Good Analysis, usa el contenido de
`analysis_options.strict.yaml` como configuración de `analysis_options.yaml`
y ejecuta `flutter analyze` (conserva una copia de tu configuración normal).

El perfil normal usa flutter_lints más reglas de seguridad/asíncronas; el perfil
estricto es opcional y puede reportar recomendaciones adicionales.

CI ejecuta generación → análisis → pruebas → compilaciones Android/iOS. El APK
debug se publica como artefacto, **no como release**. Para release Android, usa
`android/key.properties` con `storeFile`, `storePassword`, `keyAlias`, `keyPassword`;
no hay firma debug de respaldo en release. Configura identificadores propios,
iconos finales, firma, mapas, privacidad y contrato antes de publicar.

Consulta [docs/VALIDATION.md](docs/VALIDATION.md) para conocer qué se comprobó
realmente y qué falta probar en dispositivos. Esta implementación está orientada
a iOS/Android; no incluye una adaptación web ni una previsualización HTML.
