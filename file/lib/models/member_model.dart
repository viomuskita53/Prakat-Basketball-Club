class Member {
  final int id;
  final String nama;
  final String status;
  final String fotoUrl; // URL lengkap dari API

  Member({
    required this.id,
    required this.nama,
    required this.status,
    required this.fotoUrl,
  });

  /// 🔽 dari JSON (API → Flutter)
  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: int.parse(json['id'].toString()),
      nama: json['nama_anggota'] ?? '',
      status: json['status_anggota'] ?? '',
      fotoUrl: json['foto_url'] ?? '', // PENTING
    );
  }

  /// 🔼 ke JSON (Flutter → API)
  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'nama_anggota': nama,
      'status_anggota': status,
      // foto tidak dikirim via json, tapi via Multipart
    };
  }
}
