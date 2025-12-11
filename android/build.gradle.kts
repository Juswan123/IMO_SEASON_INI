buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Perhatikan tanda kurung & petik dua (Syntax Kotlin)
        classpath("com.android.tools.build:gradle:7.3.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.7.10")

        // --- INI YANG BENAR UNTUK KOTLIN (.kts) ---
        classpath("com.google.gms:google-services:4.4.1")
        // ------------------------------------------
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
