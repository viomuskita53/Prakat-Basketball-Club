import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  // ===== DATA PROFIL (ISI SENDIRI) =====
  String nama = 'Vio Muskita';
  String status = 'Player';
  String foto = 'assets/images/sample1.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const AppHeader(),
              const SizedBox(height: 24),

              // FOTO
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey.shade300,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/lbj.jpg',
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // NAMA
              Text(
                nama,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // STATUS
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: const TextStyle(fontSize: 14),
                ),
              ),

              const SizedBox(height: 32),

              // ===== BUTTON EDIT =====
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfilePage(
                        nama: nama,
                        status: status,
                        foto: foto,
                      ),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      nama = result['nama'];
                      status = result['status'];
                      foto = result['foto'];
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
