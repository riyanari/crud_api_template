import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../api/dafa_api.dart';
import '../models/nilai_siswa_model.dart';

class NilaiSiswaByUserService {
  Future<List<NilaiSiswaByUserModel>?> getNilaiSiswaByUser(String token) async {
    var url = DafaApi.nilaiSiswaByUser;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      try {
        final jsonData = jsonDecode(response.body);
        final dynamic data = jsonData['data'];

        if (data != null && data is List<dynamic>) {
          List<NilaiSiswaByUserModel> nilaiSiswaByUserList = data.map((nilaiSiswa) {
            return NilaiSiswaByUserModel.fromJson(nilaiSiswa);
          }).toList();
          return nilaiSiswaByUserList;
        } else {
          return [];
        }
      } catch (e) {
        throw Exception('Failed to parse nilai siswa by user data service');
      }
    } else {
      // Jika kode status bukan 200, lempar pengecualian dengan pesan kesalahan
      throw Exception('Failed to load nilai siswa by user service. Status code: ${response.statusCode}');
    }
  }


  Future<List<NilaiSiswaByUserModel>?> nilaiSiswaByNisnKelas(String token, int nomorKelas, String nisn) async {
    var url = '${DafaApi.nilaiSiswaByNisnKelas}/$nomorKelas/$nisn';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      try {
        final jsonData = jsonDecode(response.body);
        final dynamic data = jsonData['data'];

        if (data != null) {
          final List<dynamic> nilaiSiswaByUserData = data as List<dynamic>;
          List<NilaiSiswaByUserModel> nilaiSiswaByUserList = nilaiSiswaByUserData.map((nilai) {
            return NilaiSiswaByUserModel.fromJson(nilai);
          }).toList();
          return nilaiSiswaByUserList;
        } else {
          return [];
        }
      } catch (e) {
        throw Exception('Failed to parse nilai siswa by user data service');
      }
    } else {
      // Jika kode status bukan 200, lempar pengecualian dengan pesan kesalahan
      throw Exception('Failed to load nilai siswa by user service. Status code: ${response.statusCode}');
    }
  }

  Future<List<NilaiSiswaByUserModel>?> nilaiSiswaByKelasPelajaran(String token, int idKelas, int idPelajaran) async {
    var url = '${DafaApi.nilaiSiswaByKelasPelajaran}/$idKelas/$idPelajaran';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );


    if (response.statusCode == 200) {
      try {
        final jsonData = jsonDecode(response.body);
        final dynamic data = jsonData['data'];

        if (data != null) {
          final List<dynamic> nilaiSiswaByKelasPelajaranData = data as List<dynamic>;
          List<NilaiSiswaByUserModel> nilaiSiswaByKelasPelajaranList = nilaiSiswaByKelasPelajaranData.map((nilai) {
            return NilaiSiswaByUserModel.fromJson(nilai);
          }).toList();
          return nilaiSiswaByKelasPelajaranList;
        } else {
          return [];
        }
      } catch (e) {
        throw Exception('Failed to parse nilai siswa by user data service');
      }
    } else {
      // Jika kode status bukan 200, lempar pengecualian dengan pesan kesalahan
      throw Exception('Failed to load nilai siswa by user service. Status code: ${response.statusCode}');
    }
  }

  Future<void> addNilaiSiswa(String token, int idUser, int idKelas, int idSemester, int idMataPelajaran, int idGuruPengampu, double nilai) async {
    var url = DafaApi.addNilaiSiswa;
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);
      request.fields.addAll({
        'id_user': idUser.toString(),
        'id_kelas':idKelas.toString(),
        'id_semester':idSemester.toString(),
        'id_mata_pelajaran':idMataPelajaran.toString(),
        'id_guru_pengampu':idGuruPengampu.toString(),
        'nilai':nilai.toString(),
      });

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseString = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseString);
        // Handle the response data if needed
      } else {
        throw Exception(
            'Failed to addNilaiSiswa. Status code: ${response
                .statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to addNilaiSiswa.');
    }
  }

  Future<void> updateNilaiSiswa(String token, int id, int idGuruPengampu, double nilai) async {
    var url = DafaApi.updateNilaiSiswa;
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);
      request.fields.addAll({
        'id': id.toString(),
        'id_guru_pengampu':idGuruPengampu.toString(),
        'nilai':nilai.toString(),
      });

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseString = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseString);
        // Handle the response data if needed
      } else {
        throw Exception(
            'Failed to updateNilaiSiswa. Status code: ${response
                .statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to updateNilaiSiswa.');
    }
  }

  Future<void> deleteNilaiSiswa(String token, int id) async {
    var url = DafaApi.deleteNilaiSiswa;
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);
      request.fields.addAll({
        'id': id.toString(),
      });

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseString = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseString);
        // Handle the response data if needed
      } else {
        throw Exception(
            'Failed to deleteNilaiSiswa. Status code: ${response
                .statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to deleteNilaiSiswa.');
    }
  }
}
