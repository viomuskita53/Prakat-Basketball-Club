import 'package:flutter/material.dart';
import '../widgets/app_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ================= HEADER =================
              const AppHeader(),
              const SizedBox(height: 20),

              // ================= GRID PRESTASI =================
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _imageCard('assets/images/putra.jpeg'),
                  _imageCard('assets/images/putri.jpeg'),
                ],
              ),

              const SizedBox(height: 16),

              // ================= DESKRIPSI CLUB =================
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Prakat Basketball Club merupakan klub bola basket '
                  'yang terbentuk di kota Ambon, didirikan dan dibina '
                  'oleh Hendrick Tiemailattu, dan memiliki Head Coach '
                  'yaitu Coach Sonny Sinaya.\n\n'
                  'Prakat juga telah menjuarai beberapa kompetisi diantaranya:\n'
                  '• Perbasi Cup 2023 (Juara 1)\n'
                  '• KU-18 Perbasi Cup 2025 Putra (Juara 1)\n'
                  '• KU-16 Perbasi Cup 2025 Putri (Juara 3)',
                  style: TextStyle(fontSize: 14),
                ),
              ),

              const SizedBox(height: 20),

              // ================= GRID KEGIATAN =================
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _imageCard('assets/images/sparing.jpeg'),
                  _imageCard('assets/images/latihan.jpeg'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= WIDGET IMAGE CARD =================
  Widget _imageCard(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}
