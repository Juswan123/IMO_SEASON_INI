import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String userName;
  final String restoName;
  final String imageUrl;
  final String caption;
  final double rating;

  const PostCard({
    super.key,
    required this.userName,
    required this.restoName,
    required this.imageUrl,
    required this.caption,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0), // Full width style
      color: Colors.white,
      elevation: 0.5, // Shadow tipis biar minimalis
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Foto User & Nama Warung
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.person, color: Colors.grey),
            ),
            title: Text(restoName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("@$userName"),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade100)
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.orange),
                  Text(" $rating", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                ],
              ),
            ),
          ),

          // Caption Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(caption, style: const TextStyle(fontSize: 15)),
          ),
          const SizedBox(height: 8),

          // Foto Makanan (Besar)
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Action Buttons (Like, Reply)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
                const Text("12"), // Dummy Count
                const SizedBox(width: 20),
                IconButton(icon: const Icon(Icons.chat_bubble_outline), onPressed: () {}),
                const Text("4"), // Dummy Count
                const Spacer(),
                IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}