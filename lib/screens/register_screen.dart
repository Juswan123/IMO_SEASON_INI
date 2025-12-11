import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import 'main_nav_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLoading = false;

  void _register() async {
    if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Semua kolom harus diisi")));
      return;
    }

    setState(() => _isLoading = true);

    // 1. Proses Sign Up
    String? res = await context.read<AuthService>().signUp(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text.trim(),
      name: _nameCtrl.text.trim(),
    );

    // 2. Cek apakah user sudah login (Session terbentuk)
    final user = Supabase.instance.client.auth.currentUser;

    setState(() => _isLoading = false);

    if (res == null) {
      // Tidak ada error
      if (user != null) {
        // SUKSES: User terbentuk & Login otomatis (Email confirm mati)
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainNavScreen()),
                (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil daftar!")));
        }
      } else {
        // SUKSES DAFTAR TAPI BELUM LOGIN (Kasus jika Email confirm masih Hidup)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cek email Anda untuk verifikasi, lalu Login.")));
          Navigator.pop(context); // Kembali ke login screen
        }
      }
    } else {
      // ERROR DARI SUPABASE
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Akun")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: "Nama Lengkap")),
            const SizedBox(height: 10),
            TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: "Email")),
            const SizedBox(height: 10),
            TextField(controller: _passCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                  onPressed: _register,
                  child: const Text("Daftar Sekarang")
              ),
            ),
          ],
        ),
      ),
    );
  }
}