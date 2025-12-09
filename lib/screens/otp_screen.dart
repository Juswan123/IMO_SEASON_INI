import 'package:flutter/material.dart';
import 'main_nav_screen.dart';

class OtpScreen extends StatefulWidget {
  final String emailOrPhone; // Untuk menampilkan dikirim kemana

  const OtpScreen({super.key, required this.emailOrPhone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // Controller tidak terlalu wajib jika hanya validasi sederhana, 
  // tapi berguna jika ingin menggabungkan string nanti.
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verifikasi OTP"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ilustrasi Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_outline, size: 60, color: Colors.orange),
            ),
            const SizedBox(height: 24),
            
            // Teks Instruksi
            const Text(
              "Verifikasi Akun",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Masukkan 4 digit kode yang telah kami kirim ke ${widget.emailOrPhone}",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 40),

            // Input OTP (4 Kotak)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOtpInput(context, _fieldOne, true), // True = auto focus pertama
                _buildOtpInput(context, _fieldTwo, false),
                _buildOtpInput(context, _fieldThree, false),
                _buildOtpInput(context, _fieldFour, false),
              ],
            ),
            const SizedBox(height: 40),

            // Tombol Verifikasi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // LOGIC: Gabungkan inputan
                  String otpCode = _fieldOne.text + _fieldTwo.text + _fieldThree.text + _fieldFour.text;
                  
                  if (otpCode.length == 4) {
                    // Jika lengkap, masuk ke Main App
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainNavScreen()),
                      (route) => false, // Hapus semua history page sebelumnya (Login/Register)
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Mohon isi 4 digit kode OTP")),
                    );
                  }
                },
                child: const Text("Verifikasi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 20),
            // Kirim Ulang Timer (Dummy)
            TextButton(
              onPressed: () {},
              child: const Text("Kirim Ulang Kode (30s)", style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Pembantu untuk Membuat Kotak Input
  Widget _buildOtpInput(BuildContext context, TextEditingController controller, bool autoFocus) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextField(
        controller: controller,
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1, // Hanya 1 digit per kotak
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "", // Hilangkan penghitung karakter di bawah
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.orange, width: 2),
          ),
        ),
        onChanged: (value) {
          // Logic pindah otomatis
          if (value.length == 1) {
            FocusScope.of(context).nextFocus(); // Pindah ke kotak selanjutnya
          }
        },
      ),
    );
  }
}