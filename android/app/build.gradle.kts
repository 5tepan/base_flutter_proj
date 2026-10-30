plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.base.base_flutter_proj"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.base.baseflutterproj"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // Yandex MapKit Lite requires API 26+.
        minSdk = maxOf(26, flutter.minSdkVersion)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    
    flavorDimensions += listOf("app")

    productFlavors {
        create("dev") {
            dimension = "app"
            manifestPlaceholders += mapOf(
                "app_name" to "Dev Base App",
            )
        }
        create("devbackend") {
            dimension = "app"
            applicationIdSuffix = ".devbackend"
            manifestPlaceholders += mapOf(
                "app_name" to "Dev Backend Base App",
            )
        }
        create("prod") {
            dimension = "app"
            applicationIdSuffix = ".prod"
            manifestPlaceholders += mapOf(
                "app_name" to "Base App",
            )
        }
    }

    lint {
        disable.add("InvalidPackage")
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.android.gms:play-services-location:21.3.0")
}
