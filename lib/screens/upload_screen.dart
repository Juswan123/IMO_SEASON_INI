import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // WAJIB IMPORT INI
import '../models/restaurant_model.dart';
import '../providers/restaurant_provider.dart';
import '../services/supabase_service.dart';

class UploadScreen extends StatefulWidget {
  final Restaurant? restaurant;
  const UploadScreen({super.key, this.restaurant});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();
  final List<Map<String, TextEditingController>> _menuCtrls = [];

  List<XFile> _images = [];
  bool _loading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.restaurant != null) {
      _isEditing = true;
      _nameCtrl.text = widget.restaurant!.name;
      _descCtrl.text = widget.restaurant!.description;
      _addrCtrl.text = widget.restaurant!.address;
    }
  }

  void _addMenu() {
    setState(() => _menuCtrls.add({
      'name': TextEditingController(),
      'price': TextEditingController()
    }));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isEditing && _images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pilih minimal 1 foto resto")));
      return;
    }

    setState(() => _loading = true);

    try {
      // FIX UTAMA: Ambil user langsung dari Supabase saat tombol ditekan
      final user = Supabase.instance.client.auth.currentUser;

      // Jika user null, berarti sesi habis/logout
      if (user == null) {
        throw "User tidak ditemukan. Silakan Logout dan Login kembali.";
      }

      String imageUrl = widget.restaurant?.imageUrl ?? '';

      if (_images.isNotEmpty) {
        final urls = await SupabaseService.uploadImages(_images);
        imageUrl = urls.first;
      }

      if (_isEditing) {
        final updatedResto = Restaurant(
          id: widget.restaurant!.id,
          name: _nameCtrl.text,
          description: _descCtrl.text,
          address: _addrCtrl.text,
          imageUrl: imageUrl,
          userId: user.id, // Gunakan ID dari user yang terdeteksi
          createdAt: widget.restaurant!.createdAt,
        );
        await context.read<RestaurantProvider>().updateRestaurant(updatedResto);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil diperbarui!")));

      } else {
        final resto = Restaurant(
          id: '',
          name: _nameCtrl.text,
          description: _descCtrl.text,
          address: _addrCtrl.text,
          imageUrl: imageUrl,
          userId: user.id, // Gunakan ID dari user yang terdeteksi
          createdAt: DateTime.now(),
        );

        final menus = _menuCtrls.map((c) => Menu(
          name: c['name']!.text,
          price: double.tryParse(c['price']!.text) ?? 0,
        )).toList();

        await context.read<RestaurantProvider>().addRestaurant(resto, menus);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil upload MaIn!")));
      }

      if (mounted) Navigator.pop(context);

    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? "Edit MaIn" : "Upload MaIn Baru")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Preview Gambar Lama
            if (_isEditing && _images.isEmpty && widget.restaurant!.imageUrl != null)
              Container(
                height: 200,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(image: NetworkImage(widget.restaurant!.imageUrl!), fit: BoxFit.cover),
                ),
              ),

            // Tombol Pilih Foto
            ElevatedButton.icon(
              onPressed: () async {
                final f = await ImagePicker().pickMultiImage();
                if (f.isNotEmpty) setState(() => _images = f);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.camera_alt),
              label: Text(_images.isEmpty
                  ? (_isEditing ? "Ganti Foto (Opsional)" : "Pilih Foto Restoran")
                  : "${_images.length} Foto Terpilih"),
            ),
            const SizedBox(height: 10),

            TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: "Nama Restoran / Makanan", border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: "Deskripsi", border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            TextFormField(
                controller: _addrCtrl,
                decoration: const InputDecoration(labelText: "Alamat / Lokasi", border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null
            ),

            if (!_isEditing) ...[
              const Divider(height: 30, thickness: 2),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Daftar Menu", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    TextButton.icon(
                        onPressed: _addMenu,
                        icon: const Icon(Icons.add_circle, color: Colors.orange),
                        label: const Text("Tambah Menu")
                    )
                  ]
              ),
              ..._menuCtrls.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: TextField(
                            controller: e.value['name'],
                            decoration: const InputDecoration(labelText: "Nama Menu", border: OutlineInputBorder())
                        )
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        flex: 1,
                        child: TextField(
                            controller: e.value['price'],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: "Harga", border: OutlineInputBorder())
                        )
                    ),
                    IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => setState(() => _menuCtrls.removeAt(e.key))
                    ),
                  ],
                ),
              )),
            ],

            const SizedBox(height: 20),

            ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50)
                ),
                child: Text(_isEditing ? "SIMPAN PERUBAHAN" : "UPLOAD SEKARANG", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
            )
          ],
        ),
      ),
    );
  }
}