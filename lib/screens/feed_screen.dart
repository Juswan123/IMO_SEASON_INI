import 'package:flutter/material.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Beranda"),
        centerTitle: false, // Mirip X, title di kiri
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: const [
          // Postingan 1
          PostCard(
            userName: "budi_kuliner",
            restoName: "Nasi Goreng Gila Gondrong",
            rating: 4.8,
            caption: "Sumpah ini nasgor porsinya brutal banget! Pedesnya nampol 🔥 #KulinerMalam",
            imageUrl: "https://upload.wikimedia.org/wikipedia/commons/3/3e/Nasi_goreng_indonesia.jpg", 
          ),
          
          // Postingan 2
          PostCard(
            userName: "sari_makan",
            restoName: "Sate Taichan Senayan",
            rating: 4.5,
            caption: "Satenya juicy, sambelnya seger asem pedes. Cocok buat nongkrong.",
            imageUrl: "https://assets.pikiran-rakyat.com/crop/0x0:0x0/x/photo/2021/11/24/2330925562.jpg",
          ),

           // Postingan 3
          PostCard(
            userName: "jagoan_makan",
            restoName: "Bakso Beranak",
            rating: 3.9,
            caption: "Unik sih bentuknya, tapi kuahnya kurang nendang menurutku.",
            imageUrl: "https://asset.kompas.com/crops/W2Ua--O3oB0J0O5u8rWb5y4y5y4=/0x0:1000x667/750x500/data/photo/2020/03/03/5e5e01b440445.jpg",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Nanti ke halaman Upload
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}