import 'package:flutter/material.dart';
import 'main_nav_screen.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller untuk input email/password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Akun Baru"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Bergabung dengan Main!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // OPSI 1: DAFTAR DENGAN GOOGLE
            // Tombol ini akan memiliki icon Google yang jelas
            _buildGoogleButton(context),
            const SizedBox(height: 30),

            // Divider "ATAU"
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text("ATAU", style: TextStyle(color: Colors.grey[600])),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 30),

            // OPSI 2: DAFTAR DENGAN EMAIL & PASSWORD

            // Input Username
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // Input Email
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // Input Password
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Daftar dengan Email
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // Navigasi ke OTP Screen
                // Kita kirim data dummy email untuk ditampilkan
                String emailInput = _emailController.text.isNotEmpty 
                    ? _emailController.text 
                    : "email@contoh.com";

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtpScreen(emailOrPhone: emailInput),
                  ),
                );
              },
              child: const Text("Daftar dengan Email", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            
            // Link Kembali ke Login
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Kembali ke halaman Login
              },
              child: const Text("Sudah punya akun? Masuk di sini.", style: TextStyle(color: Colors.orange)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleButton(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      onPressed: () {
        // LOGIC DUMMY: Tampilkan notifikasi dan navigasi
        _showSuccess(context, "Google");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OtpScreen(emailOrPhone: "user.google@gmail.com"),
          ),
        );
      },
      icon: const Image(
        image: AssetImage('assets/google_logo.png'), 
        height: 24.0, // Nanti perlu ditambahkan logo Google di folder assets
      ),
      label: const Text(
        "Daftar dengan Google",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showSuccess(BuildContext context, String method) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Simulasi Daftar Berhasil via $method!"))
      );
      // Navigasi ke Home Screen setelah pendaftaran
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const MainNavScreen())
      );
  }
}