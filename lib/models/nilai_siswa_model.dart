import 'package:dafa_smart/models/jadwal-pelajaran/mata_pelajaran_model.dart';
import 'package:dafa_smart/models/kelas/kelas_model.dart';
import '../semester_model.dart';
import '../user_model.dart';

class NilaiSiswaByUserModel {
  final int id;
  final UserModel? user;
  final SemesterModel? semester;
  final MataPelajaranModel? mataPelajaran;
  final UserModel? guruPengampu;
  final KelasModel? kelas;
  final int idKelas;
  final double nilai;

  NilaiSiswaByUserModel({
    required this.id,
    required this.user,
    required this.semester,
    required this.mataPelajaran,
    required this.guruPengampu,
    required this.kelas,
    required this.idKelas,
    required this.nilai,
  });

  factory NilaiSiswaByUserModel.fromJson(Map<String, dynamic> json) {
    return NilaiSiswaByUserModel(
      id: json['id'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      semester: json['semester'] != null ? SemesterModel.fromJson(json['semester']) : null,
      mataPelajaran: json['mata_pelajaran'] != null ? MataPelajaranModel.fromJson(json['mata_pelajaran']) : null,
      guruPengampu: json['guru_pengampu'] != null ? UserModel.fromJson(json['guru_pengampu']) : null,
      kelas: json['kelas'] != null ? KelasModel.fromJson(json['kelas']) : null,
      idKelas: json['id_kelas'],
      nilai: (json['nilai'] as num).toDouble(), // to handle cases where json['nilai'] is int or double
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'semester': semester?.toJson(),
      'mata_pelajaran': mataPelajaran?.toJson(),
      'guru_pengampu': guruPengampu?.toJson(),
      'kelas': kelas?.toJson(),
      'id_kelas': idKelas,
      'nilai': nilai,
    };
  }
}
