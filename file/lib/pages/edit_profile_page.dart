import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class EditProfilePage extends StatefulWidget {
  final String nama;
  final String status;
  final String foto; // bisa URL atau path lokal

  const EditProfilePage({
    super.key,
    required this.nama,
    required this.status,
    required this.foto,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController namaController;
  late String selectedStatus;
  XFile? selectedImage;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.nama);
    selectedStatus = widget.status;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  void saveProfile() {
    if (namaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong')),
      );
      return;
    }

    Navigator.pop(context, {
      'nama': namaController.text,
      'status': selectedStatus,
      'foto': selectedImage != null
          ? selectedImage!.path
          : widget.foto,
    });
  }

  Widget buildImagePreview() {
    // Jika user pilih gambar baru
    if (selectedImage != null) {
      return kIsWeb
          ? Image.network(
              selectedImage!.path,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          : Image.file(
              File(selectedImage!.path),
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            );
    }

    // Gambar lama (URL)
    return Image.network(
      widget.foto,
      height: 160,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.person, size: 120),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedStatus,
              items: const [
                DropdownMenuItem(value: 'Player', child: Text('Player')),
              ],
              onChanged: (value) {
                setState(() => selectedStatus = value!);
              },
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            GestureDetector(
              onTap: pickImage,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: buildImagePreview(),
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveProfile,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
