import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'edit_member_page.dart';
import 'new_member_page.dart';

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({super.key});

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  List members = [];
  bool isLoading = true;

  final String baseUrl =
      'http://localhost:8080/project_uas_api/member';

  Future<void> fetchMembers() async {
    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/read.php'),
      );

      if (response.statusCode == 200) {
        members = jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() => isLoading = false);
  }

  Future<void> deleteMember(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Member'),
        content: const Text('Are you sure you want to delete this member?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await http.post(
      Uri.parse('$baseUrl/delete.php'),
      body: {'id': id.toString()},
    );

    fetchMembers();
  }

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Members')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewMemberPage()),
          );
          if (result == true) {fetchMembers();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : members.isEmpty
              ? const Center(child: Text('No members found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final m = members[index];

                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(m['foto_url']),
                          onBackgroundImageError: (_, __) {},
                          child: m['foto_url'] == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(m['nama_anggota']),
                        subtitle: Text(m['status_anggota']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EditMemberPage(member: m),
                                  ),
                                );
                                if (result == true) fetchMembers();
                              },
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  deleteMember(int.parse(m['id'])),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
