import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Firma de release: se lee de `key.properties` o de variables de entorno.
// El keystore nunca se versiona (ver README y .gitignore).
val keyPropertiesFile = rootProject.file("key.properties")
val keyProperties = Properties().apply {
    if (keyPropertiesFile.exists()) keyPropertiesFile.inputStream().use { load(it) }
}

fun signingValue(property: String, environment: String): String? =
    (keyProperties.getProperty(property) ?: System.getenv(environment))
        ?.takeIf { it.isNotBlank() }

val releaseStorePath: String? = signingValue("storeFile", "KEYSTORE_PATH")
val releaseStorePassword: String? = signingValue("storePassword", "KEYSTORE_PASSWORD")
val releaseKeyAlias: String? = signingValue("keyAlias", "KEY_ALIAS")
val releaseKeyPassword: String? = signingValue("keyPassword", "KEY_PASSWORD")

val hasReleaseSigning: Boolean =
    releaseStorePath != null &&
        releaseStorePassword != null &&
        releaseKeyAlias != null &&
        releaseKeyPassword != null

android {
    namespace = "com.puntoplus.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.puntoplus.app"
        // Clave de Google Maps tomada de local.properties (GOOGLE_MAPS_API_KEY=...)
        // o de la variable de entorno del mismo nombre en CI.
        val mapsApiKey: String = (project.findProperty("GOOGLE_MAPS_API_KEY")
            ?: System.getenv("GOOGLE_MAPS_API_KEY")
            ?: "") as String
        manifestPlaceholders["GOOGLE_MAPS_API_KEY"] = mapsApiKey
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                storeFile = file(releaseStorePath!!)
                storePassword = releaseStorePassword
                keyAlias = releaseKeyAlias
                keyPassword = releaseKeyPassword
            }
        }
    }

    buildTypes {
        release {
            // Con `key.properties` o las variables KEYSTORE_* se firma con la
            // clave de release; sin ellas se usa la de depuración para no
            // romper `flutter run --release` en desarrollo.
            signingConfig = if (hasReleaseSigning) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            // R8/ProGuard queda desactivado por defecto: actívalo junto con
            // `proguard-rules.pro` cuando se integren los SDK nativos.
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
