import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. REGISTER dengan Email & Password
  // Kita kembalikan String null jika sukses, atau pesan error jika gagal
  Future<String?> registerWithEmail({
    required String email, 
    required String password, 
    required String username
  }) async {
    try {
      // a. Buat Akun di Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      User? user = result.user;

      // b. Simpan Data Tambahan (Username) ke Firestore Database
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'username': username,
          'profile_pic': '', // Kosong dulu
          'created_at': FieldValue.serverTimestamp(),
        });
        return null; // Sukses
      }
      return "Gagal membuat user ID";
    } on FirebaseAuthException catch (e) {
      return e.message; // Kembalikan pesan error dari Firebase
    } catch (e) {
      return e.toString();
    }
  }

  // 2. LOGIN dengan Email & Password
  Future<String?> signInWithEmail({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Sukses
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // 3. LOGIN dengan GOOGLE (Khusus WEB)
  Future<String?> signInWithGoogleWeb() async {
    try {
      // Membuat Provider Google
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      
      // Membuka Popup Login Google
      UserCredential result = await _auth.signInWithPopup(authProvider);
      User? user = result.user;

      if (user != null) {
        // Cek apakah data user sudah ada di Firestore? Jika belum, buat baru.
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        if (!doc.exists) {
           await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'email': user.email,
            'username': user.displayName ?? "User Google",
            'profile_pic': user.photoURL ?? "",
            'created_at': FieldValue.serverTimestamp(),
          });
        }
        return null; // Sukses
      }
      return "Batal Login Google";
    } catch (e) {
      return e.toString();
    }
  }

  // 4. LOGOUT
  Future<void> signOut() async {
    await _auth.signOut();
  }
}