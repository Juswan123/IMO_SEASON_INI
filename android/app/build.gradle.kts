plugins {
    id("com.android.application")
    id("kotlin-android")
    // Plugin Firebase (Wajib ada disini)
    id("com.google.gms.google-services")
}

android {
    // Sesuaikan dengan package name Anda
    namespace = "com.example.makanan_info"
    compileSdk = 34 // Sesuaikan jika perlu, standar saat ini 33/34

    defaultConfig {
        applicationId = "com.example.makanan_info"
        minSdk = 21 // Minimal 21 agar Firebase jalan
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }

    // Opsi Kotlin
    kotlinOptions {
        jvmTarget = "1.8"
    }
}

dependencies {
    // Dependency standar Kotlin
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.8.0")
    // Dependency lain otomatis diatur oleh Flutter
}