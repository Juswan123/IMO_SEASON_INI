import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import 'restaurant_detail_screen.dart';
import 'notification_screen.dart'; // Import Halaman Notifikasi

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<RestaurantProvider>().fetchRestaurants());
  }

  void _onSearchChanged(String query) {
    context.read<RestaurantProvider>().fetchRestaurants(query: query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // SEARCH BAR
        title: SizedBox(
          height: 40,
          child: TextField(
            controller: _searchCtrl,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Cari MaIn...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        // ICON NOTIFIKASI DI POJOK KANAN ATAS
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return const Center(child: CircularProgressIndicator());
          if (provider.restaurants.isEmpty) {
            return const Center(child: Text("Tidak ada restoran ditemukan", style: TextStyle(color: Colors.grey)));
          }

          return ListView.builder(
            itemCount: provider.restaurants.length,
            itemBuilder: (ctx, i) {
              final r = provider.restaurants[i];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER CARD (Sudah tidak ada titik tiga)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.orange.shade100,
                          child: Text(r.name[0], style: const TextStyle(color: Colors.orange)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(r.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        // TITIK TIGA HILANG DARI SINI
                      ],
                    ),
                  ),

                  // GAMBAR + RATING
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantDetailScreen(restaurant: r))),
                    child: Stack(
                      children: [
                        r.imageUrl != null
                            ? AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(r.imageUrl!, fit: BoxFit.cover),
                        )
                            : Container(
                          height: 300,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                        ),

                        // RATING BADGE
                        Positioned(
                          top: 10,
                          right: 10,
                          child: FutureBuilder<double>(
                            future: context.read<RestaurantProvider>().getAverageRating(r.id),
                            builder: (c, s) {
                              if (!s.hasData || s.data == 0) return const SizedBox();
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 14),
                                    const SizedBox(width: 4),
                                    Text(s.data!.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),

                  // ACTIONS & DESCRIPTION
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.favorite_border),
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: const Icon(Icons.mode_comment_outlined),
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantDetailScreen(restaurant: r))),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const Spacer(),
                            const Icon(Icons.bookmark_border),
                          ],
                        ),
                        const SizedBox(height: 8),

                        RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(text: "${r.name} ", style: const TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: r.description),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(r.address, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                ],
              );
            },
          );
        },
      ),
    );
  }
}