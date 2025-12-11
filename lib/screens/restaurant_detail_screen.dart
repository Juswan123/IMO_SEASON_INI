import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/restaurant_model.dart';
import '../providers/restaurant_provider.dart';
import '../services/auth_service.dart';
import 'upload_screen.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  final _commentCtrl = TextEditingController();
  int _rating = 5;

  bool get _isOwner {
    final currentUser = context.read<AuthService>().currentUser;
    return currentUser?.id == widget.restaurant.userId;
  }

  void _deleteRestaurant() async {
    final confirm = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Hapus Postingan?"),
          content: const Text("Tindakan ini tidak dapat dibatalkan."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal")),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Hapus", style: TextStyle(color: Colors.red))),
          ],
        )
    );

    if (confirm == true && mounted) {
      await context.read<RestaurantProvider>().deleteRestaurant(widget.restaurant.id);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Postingan dihapus.")));
      }
    }
  }

  void _showRatingModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Beri Penilaian", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(index < _rating ? Icons.star : Icons.star_border, color: Colors.orange, size: 32),
                  onPressed: () => setState(() => _rating = index + 1),
                );
              }),
            ),
            TextField(
              controller: _commentCtrl,
              decoration: const InputDecoration(labelText: "Tulis pengalamanmu...", border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 45)),
              onPressed: () async {
                if (_commentCtrl.text.isEmpty) return;
                try {
                  await context.read<RestaurantProvider>().addReview(
                      widget.restaurant.id,
                      widget.restaurant.userId,
                      _rating,
                      _commentCtrl.text
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Review terkirim!")));
                  setState(() { _commentCtrl.clear(); });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              },
              child: const Text("KIRIM"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // WIDGET HELPER UNTUK ICON STROKE/BACKGROUND
  Widget _buildActionIcon(IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: const BoxDecoration(
        color: Colors.black54, // Background hitam transparan agar kontras
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onTap,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            // LOGIKA BUTTON UPDATE & DELETE DENGAN VISUAL BARU
            actions: _isOwner ? [
              _buildActionIcon(Icons.edit, () => Navigator.push(context, MaterialPageRoute(builder: (_) => UploadScreen(restaurant: widget.restaurant)))),
              _buildActionIcon(Icons.delete, _deleteRestaurant),
              const SizedBox(width: 8),
            ] : null,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(widget.restaurant.name, style: const TextStyle(color: Colors.white, fontSize: 16, shadows: [Shadow(blurRadius: 10, color: Colors.black)])),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(12)),
                    child: FutureBuilder<double>(
                      future: context.read<RestaurantProvider>().getAverageRating(widget.restaurant.id),
                      builder: (c, s) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(s.hasData ? s.data!.toStringAsFixed(1) : "-", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              background: widget.restaurant.imageUrl != null
                  ? Image.network(widget.restaurant.imageUrl!, fit: BoxFit.cover)
                  : Container(color: Colors.orange),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.location_on, color: Colors.orange, size: 20),
                    const SizedBox(width: 5),
                    Expanded(child: Text(widget.restaurant.address, style: const TextStyle(fontSize: 14, color: Colors.grey))),
                  ]),
                  const SizedBox(height: 16),
                  Text(widget.restaurant.description, style: const TextStyle(fontSize: 16, height: 1.5)),
                  const SizedBox(height: 24),
                  const Text("MENU", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.2)),
                  const Divider(),
                ],
              ),
            ),
          ),
          FutureBuilder<List<Menu>>(
            future: context.read<RestaurantProvider>().fetchMenus(widget.restaurant.id),
            builder: (ctx, snap) {
              if (!snap.hasData) return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
              return SliverList(
                delegate: SliverChildBuilderDelegate((c, i) {
                  final m = snap.data![i];
                  return ListTile(
                    title: Text(m.name),
                    trailing: Text("Rp ${m.price.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                  );
                }, childCount: snap.data!.length),
              );
            },
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("ULASAN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.2)),
                  TextButton.icon(onPressed: _showRatingModal, icon: const Icon(Icons.edit), label: const Text("Tulis Ulasan"))
                ],
              ),
            ),
          ),
          FutureBuilder<List<Review>>(
            future: context.watch<RestaurantProvider>().fetchReviews(widget.restaurant.id),
            builder: (ctx, snap) {
              if (!snap.hasData) return const SliverToBoxAdapter(child: SizedBox(height: 50));
              if (snap.data!.isEmpty) return const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.all(16), child: Text("Belum ada ulasan.")));

              return SliverList(
                delegate: SliverChildBuilderDelegate((c, i) {
                  final r = snap.data![i];
                  return ListTile(
                    leading: CircleAvatar(child: Text(r.userName[0])),
                    title: Text(r.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: List.generate(5, (index) => Icon(index < r.rating ? Icons.star : Icons.star_border, size: 14, color: Colors.orange))),
                        Text(r.comment),
                      ],
                    ),
                  );
                }, childCount: snap.data!.length),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }
}