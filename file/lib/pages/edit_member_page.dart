import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class EditMemberPage extends StatefulWidget {
  final Map<String, dynamic> member;

  const EditMemberPage({super.key, required this.member});

  @override
  State<EditMemberPage> createState() => _EditMemberPageState();
}

class _EditMemberPageState extends State<EditMemberPage> {
  late TextEditingController namaController;
  String selectedStatus = 'Player';
  XFile? image;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    namaController =
        TextEditingController(text: widget.member['nama_anggota']);
    selectedStatus = widget.member['status_anggota'];
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Widget previewImage() {
    if (image != null) {
      // gambar baru
      if (kIsWeb) {
        return Image.network(
          image!.path,
          height: 150,
          fit: BoxFit.cover,
        );
      } else {
        return Image.file(
          File(image!.path),
          height: 150,
          fit: BoxFit.cover,
        );
      }
    }

    // gambar lama dari server
    return Image.network(
      widget.member['foto_url'],
      height: 150,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        height: 150,
        color: Colors.grey[300],
        child: const Center(child: Text('Image not available')),
      ),
    );
  }

  Future<void> updateMember() async {
    if (namaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong')),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    final uri = Uri.parse(
      'http://localhost:8080/project_uas_api/member/update.php',
    );

    final request = http.MultipartRequest('POST', uri);

    request.fields['id'] = widget.member['id'].toString();
    request.fields['nama_anggota'] = namaController.text;
    request.fields['status_anggota'] = selectedStatus;

    if (image != null) {
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
    }

    final response = await request.send();
    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Member')),
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
                DropdownMenuItem(value: 'Coach', child: Text('Coach')),
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
              onPressed: isLoading ? null : updateMember,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
