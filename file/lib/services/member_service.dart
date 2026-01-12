import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/member_model.dart';

class MemberService {

  static const String baseUrl =
      'http://localhost:8080/project_uas_api/member';


  static Future<List<Member>> fetchMembers() async {
    final response = await http.get(Uri.parse('$baseUrl/read.php'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Member.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data member');
    }
  }


  static Future<bool> addMember({
    required String nama,
    required String status,
    required dynamic foto, // File (mobile) / XFile (web)
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/create.php'),
    );

    request.fields['nama_anggota'] = nama;
    request.fields['status_anggota'] = status;


    if (kIsWeb) {
      final bytes = await foto.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'foto_anggota',
          bytes,
          filename: foto.name,
        ),
      );
    } else {
      request.files.add(
        await http.MultipartFile.fromPath(
          'foto_anggota',
          (foto as File).path,
        ),
      );
    }

    final response = await request.send();
    return response.statusCode == 200;
  }


  static Future<bool> updateMember({
    required int id,
    required String nama,
    required String status,
    dynamic foto, // optional
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/update.php'),
    );

    request.fields['id'] = id.toString();
    request.fields['nama_anggota'] = nama;
    request.fields['status_anggota'] = status;

    if (foto != null) {
      if (kIsWeb) {
        final bytes = await foto.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'foto_anggota',
            bytes,
            filename: foto.name,
          ),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath(
            'foto_anggota',
            (foto as File).path,
          ),
        );
      }
    }

    final response = await request.send();
    return response.statusCode == 200;
  }

  static Future<bool> deleteMember(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delete.php'),
      body: {'id': id.toString()},
    );

    return response.statusCode == 200;
  }
}
