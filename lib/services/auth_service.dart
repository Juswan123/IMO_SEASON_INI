import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;

  // Login
  Future<String?> signIn({required String email, required String password}) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Register (Perhatikan parameter 'name')
  Future<String?> signUp({required String email, required String password, required String name}) async {
    try {
      await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name}, // Metadata user
      );
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }
  Future<void> updateFullName(String newName) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(data: {'full_name': newName}),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}