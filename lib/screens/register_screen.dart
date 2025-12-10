import 'package:flutter/material.dart';
// import 'main_nav_screen.dart';
import 'otp_screen.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller untuk input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  // Service and state
  final AuthService _authService = AuthService();
  bool _isLoading = false;

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
            _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.orange))
                : _buildGoogleButton(context),
                
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
            _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.orange))
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      // 1. Validasi Input Kosong
                      if (_emailController.text.isEmpty ||
                          _passwordController.text.isEmpty ||
                          _usernameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Semua kolom harus diisi!")));
                        return;
                      }

                      // 2. Mulai Loading
                      setState(() => _isLoading = true);

                      // 3. Panggil Firebase Register dari Service
                      // Pastikan class AuthService memiliki method registerWithEmail
                      String? result = await _authService.registerWithEmail(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                        username: _usernameController.text.trim(),
                      );

                      if (!mounted) return;

                      // 4. Stop Loading
                      setState(() => _isLoading = false);

                      // 5. Cek Hasil
                      if (result == null) {
                        // SUKSES -> Ke OTP Screen
                        if (!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpScreen(emailOrPhone: _emailController.text),
                          ),
                        );
                      } else {
                        // GAGAL -> Tampilkan Error
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: $result")));
                      }
                    },
                  child: const Text("Daftar dengan Email",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
      onPressed: () async {
        // LOGIC Google Sign in.
        setState(() => _isLoading = true);

        String? result = await _authService.signInWithGoogleWeb();
        
        if (!mounted) return;

        setState(() => _isLoading = false);

        if(result == null){
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => const OtpScreen(emailOrPhone: "Akun Google")
            ),
          );
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
        }
      },
      icon: const Image(
        image: AssetImage('assets/google_logo.png'), 
        height: 24.0,
      ),
      label: const Text(
        "Daftar dengan Google",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}