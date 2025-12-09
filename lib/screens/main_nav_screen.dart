import 'package:flutter/material.dart';
import 'feed_screen.dart';
// import 'profile_screen.dart'; Belum digunakan

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedIndex = 0; // 0 = Beranda, 1 = Profil

  // Daftar halaman yang akan ditampilkan
  final List<Widget> _screens = [
    const FeedScreen(),
    // const ProfileScreen(), // Belum digunakan
  ];

  // Judul di AppBar yang berubah sesuai halaman
  final List<String> _titles = [
    "Main",
    "Profil Saya",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dinamis
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          // Style logic untuk judul beranda
          style: _selectedIndex == 0 
              ? const TextStyle(
                  color: Colors.orange, 
                  fontWeight: FontWeight.w900,
                  fontSize: 26,
                  fontStyle: FontStyle.italic
                )
              : null, // Gaya default untuk Profil
        ),
        centerTitle: false,
        actions: [
          // Icon notifikasi hanya muncul di Beranda (Index 0)
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {},
            ),
        ],
      ),
      
      // Body menampilkan layar sesuai index yang dipilih
      body: _screens[_selectedIndex],

      // Floating Action Button (Tombol Tambah) hanya di Beranda
      floatingActionButton: _selectedIndex == 0 
          ? FloatingActionButton(
              onPressed: () {
                // Ke halaman Upload (Nanti)
              },
              backgroundColor: Colors.orange,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null, // Jika di profil, tombol tambah hilang

      // Bagian Bawah (Navbar)
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange, // Warna saat aktif
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false, // Gaya modern (label sembunyi jika tidak aktif)
        onTap: _onItemTapped,
      ),
    );
  }
}