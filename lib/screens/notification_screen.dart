import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import 'package:intl/intl.dart'; // Opsional: Untuk format tanggal kalau mau rapi

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // Ambil notifikasi saat halaman dibuka
    Future.microtask(() => context.read<RestaurantProvider>().fetchNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifikasi")),
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, _) {
          if (provider.notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("Belum ada notifikasi", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.notifications.length,
            itemBuilder: (ctx, i) {
              final notif = provider.notifications[i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange.shade100,
                  child: const Icon(Icons.star, color: Colors.orange),
                ),
                title: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(text: notif.senderName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(text: " "),
                      TextSpan(text: notif.message),
                    ],
                  ),
                ),
                subtitle: Text(
                  // Format tanggal sederhana
                  "${notif.createdAt.day}/${notif.createdAt.month}/${notif.createdAt.year}",
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}