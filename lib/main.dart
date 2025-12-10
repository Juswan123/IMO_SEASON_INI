import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Wajib 1
import 'package:flutter/foundation.dart'; // Import Wajib 2 (untuk kIsWeb)
import 'screens/login_screen.dart';

void main() async {
  // 1. Pastikan binding flutter siap
  WidgetsFlutterBinding.ensureInitialized();

  // 2. INI BAGIAN PENTING: Menyalakan Firebase
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        // --- TUGAS ANDA: ISI DATA INI DARI FIREBASE CONSOLE ---
        // Caranya: Buka Firebase Console -> Project Settings -> General -> Scroll ke bawah (Your Apps) -> Klik Config
        apiKey: "AIzaSyClKfD6o96q_46vIl42MjkCsr2M9T8aV5w", 
        authDomain: "main-makanan-info.firebaseapp.com",
        projectId: "main-makanan-info",
        storageBucket: "main-makanan-info.firebasestorage.app",
        messagingSenderId: "257919411566",
        appId: "1:257919411566:web:2b33a65a9609db05194d7f",
        measurementId: "G-TQ94Z2G2K1",
      ),
    );
  } else {
    // Untuk Android/iOS (Nanti)
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main (Makanan Info)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}