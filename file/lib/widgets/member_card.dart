import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class MemberCard extends StatelessWidget {
  final Map<String, dynamic> member;
  final VoidCallback onDelete;

  const MemberCard({
    super.key,
    required this.member,
    required this.onDelete,
  });

  ImageProvider _getImageProvider(String image) {
    if (image.startsWith('http')) {
      return NetworkImage(image);
    } else if (!kIsWeb && image.startsWith('/')) {
      return FileImage(File(image));
    } else {
      return AssetImage(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: _getImageProvider(member['image']),
        ),
        title: Text(member['nama']),
        subtitle: Text(member['status']),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
