import 'package:flutter/material.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        PostCard(
          userName: "budi_kuliner",
          restoName: "Nasi Goreng Gila Gondrong",
          rating: 4.8,
          caption: "Sumpah ini nasgor porsinya brutal banget! Pedesnya nampol 🔥 #KulinerMalam",
          imageUrl: "/assets/nasi_goreng.jpeg", 
        ),
        PostCard(
          userName: "sari_makan",
          restoName: "Sate Taichan Senayan",
          rating: 4.5,
          caption: "Satenya juicy, sambelnya seger asem pedes. Cocok buat nongkrong.",
          imageUrl: "/assets/sate.jpeg",
        ),
         PostCard(
          userName: "jagoan_makan",
          restoName: "Bakso Beranak",
          rating: 3.9,
          caption: "Unik sih bentuknya, tapi kuahnya kurang nendang menurutku.",
          imageUrl: "/assets/bakso_beranak.jpeg",
        ),
      ],
    );
  }
}