import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class NewMemberPage extends StatefulWidget {
  const NewMemberPage({super.key});

  @override
  State<NewMemberPage> createState() => _NewMemberPageState();
}

class _NewMemberPageState extends State<NewMemberPage> {
  final namaController = TextEditingController();
  String selectedStatus = 'Player';
  XFile? image;
  bool isLoading = false;

  Widget previewImage() {
    if (image == null) {
      return Container(
        height: 150,
        color: Colors.grey[300],
        child: const Center(child: Text('Tap to select image')),
      );
    }

    if (kIsWeb) {
      return Image.network(
        image!.path,
        height: 150,
        fit: BoxFit.cover,
      );
    }

    return Image.file(
      File(image!.path),
      height: 150,
      fit: BoxFit.cover,
    );
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<void> saveMember() async {
  if (image == null || namaController.text.isEmpty){
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Complete the data!')),
    );
    return;

  } 
  setState(() => isLoading = true);

  final uri =
      Uri.parse('http://localhost:8080/project_uas_api/member/create.php',);
  final request = http.MultipartRequest('POST', uri);

  // form fields
  request.fields['nama_anggota'] = namaController.text;
  request.fields['status_anggota'] = selectedStatus;

  // upload image (WEB vs MOBILE)
  if (kIsWeb) {
    final bytes = await image!.readAsBytes();
    request.files.add(
      http.MultipartFile.fromBytes(
        'foto_anggota',
        bytes,
        filename: image!.name,
      ),
    );
  } else {
    request.files.add(
      await http.MultipartFile.fromPath(
        'foto_anggota',
        image!.path,
      ),
    );
  }

  final response = await request.send();

  setState(() => isLoading = false);

  if (response.statusCode == 200) {
    Navigator.pop(context, true);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to save data!')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Member')),
      body: Padding(
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

            DropdownButtonFormField(
              value: selectedStatus,
              items: const [
                DropdownMenuItem(value: 'Player', child: Text('Player')),
              ],
              onChanged: (v) => setState(() => selectedStatus = v!),
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            GestureDetector(
              onTap: pickImage,
              child: previewImage(),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed:
                  isLoading || image == null ? null : saveMember,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
