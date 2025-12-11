import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../providers/restaurant_provider.dart';
import 'restaurant_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<RestaurantProvider>().fetchMyRestaurants());
  }

  // Logic untuk menampilkan Popup Edit Nama
  void _showEditNameDialog(String currentName) {
    final nameCtrl = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Ganti Nama"),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: "Nama Lengkap", border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              try {
                // Panggil fungsi update di AuthService
                await context.read<AuthService>().updateFullName(nameCtrl.text.trim());

                if (mounted) {
                  Navigator.pop(ctx); // Tutup Dialog
                  setState(() {}); // Refresh UI agar nama baru muncul
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nama berhasil diubah!")));
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e")));
                }
              }
            },
            child: const Text("Simpan"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data user terbaru langsung dari AuthService
    final user = context.read<AuthService>().currentUser;
    // Pastikan mengambil key 'full_name' dari metadata
    final name = user?.userMetadata?['full_name'] ?? "User";
    final email = user?.email ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Saya", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              context.read<AuthService>().signOut();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Avatar Inisial
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.orange,
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : "A",
                    style: const TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // BAGIAN NAMA DENGAN TOMBOL EDIT
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              name,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
                            onPressed: () => _showEditNameDialog(name),
                            tooltip: "Ganti Nama",
                          )
                        ],
                      ),

                      Text(email, style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 8),
                      Consumer<RestaurantProvider>(
                        builder: (c, p, _) => Text(
                          "${p.myRestaurants.length} Postingan",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Icon(Icons.grid_on, color: Colors.black),
          ),
          const Divider(height: 0),

          // GRID POSTINGAN
          Expanded(
            child: Consumer<RestaurantProvider>(
              builder: (ctx, prov, _) {
                if (prov.isLoading) return const Center(child: CircularProgressIndicator());

                if (prov.myRestaurants.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined, size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("Belum ada upload", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(2),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: prov.myRestaurants.length,
                  itemBuilder: (c, i) {
                    final r = prov.myRestaurants[i];
                    return GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantDetailScreen(restaurant: r))),
                      child: r.imageUrl != null
                          ? Image.network(r.imageUrl!, fit: BoxFit.cover)
                          : Container(color: Colors.grey[300], child: const Icon(Icons.restaurant)),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}