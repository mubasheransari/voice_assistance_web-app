plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.voice_assistant_project"
    compileSdk = flutter.compileSdkVersion

    // 🔧 NDK version needed by flutter_tts & speech_to_text
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.voice_assistant_project"

        minSdk = flutter.minSdkVersion
        targetSdk = 34

        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        debug {
            // No shrinking in debug
            isMinifyEnabled = false
            isShrinkResources = false
        }
        release {
            // For now, keep it simple: NO shrinking, NO minify
            // (you can enable these later for Play Store)
            isMinifyEnabled = false
            isShrinkResources = false

            // Using debug signing so `flutter run --release` works
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }
}

flutter {
    source = "../.."
}
