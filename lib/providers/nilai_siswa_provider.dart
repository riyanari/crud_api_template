import 'package:flutter/material.dart';

import '../models/nilai_siswa_model.dart';
import '../services/nilai_siswa_service.dart';

class NilaiSiswaByUserProvider with ChangeNotifier {
  final NilaiSiswaByUserService _nilaiSiswaByUserService = NilaiSiswaByUserService();
  List<NilaiSiswaByUserModel>? _nilaiSiswaByUserList;
  bool _isLoading = false;
  String _errorMessage = '';

  List<NilaiSiswaByUserModel>? get nilaiSiswaByUserList => _nilaiSiswaByUserList; // Update the data type
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Setter methods do not need to be changed because the data type of properties already matches

  void setLoading(bool value) {
    _isLoading = value;
    // notifyListeners();
  }

  Future<void> getNilaiSiswaByUser(String token) async {
    _isLoading = true;
    _errorMessage = '';

    try {
      // Check if the data has been fetched before and is not null
      if (_nilaiSiswaByUserList == null) {
        final List<NilaiSiswaByUserModel>? fetchedNilaiSiswaByUser = await _nilaiSiswaByUserService.getNilaiSiswaByUser(token);

        if (fetchedNilaiSiswaByUser != null) {
          _nilaiSiswaByUserList = fetchedNilaiSiswaByUser;
        } else {
          _nilaiSiswaByUserList = null;
        }
      }
    } catch (e) {
      // Handle errors
      _errorMessage = 'Error: $e';
    } finally {
      // End the loading process
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> nilaiSiswaByNisnKelas(String token, int nomorKelas, String nisn) async {
    _isLoading = true;
    _errorMessage = '';

    try {
      // Check if the data has been fetched before and is not null
      if (_nilaiSiswaByUserList == null) {
        final List<NilaiSiswaByUserModel>? fetchedNilaiSiswaByUser = await _nilaiSiswaByUserService.nilaiSiswaByNisnKelas(token, nomorKelas, nisn);
        if (fetchedNilaiSiswaByUser != null) {
          _nilaiSiswaByUserList = fetchedNilaiSiswaByUser;
        } else {
          _nilaiSiswaByUserList = null;
        }
      } else {
        final List<NilaiSiswaByUserModel>? fetchedNilaiSiswaByUser = await _nilaiSiswaByUserService.nilaiSiswaByNisnKelas(token, nomorKelas, nisn);
        _nilaiSiswaByUserList = fetchedNilaiSiswaByUser;
      }
    } catch (e) {
      // Handle errors
      _errorMessage = 'Error: $e';
    } finally {
      // End the loading process
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> nilaiSiswaByKelasPelajaran(String token, int idKelas, int idPelajaran) async {
    _isLoading = true;
    _errorMessage = '';
    _nilaiSiswaByUserList = null;

    try {
      // Check if the data has been fetched before and is not null
      if (_nilaiSiswaByUserList == null) {
        final List<NilaiSiswaByUserModel>? fetchedNilaiSiswaByKelasPelajaran = await _nilaiSiswaByUserService.nilaiSiswaByKelasPelajaran(token, idKelas, idPelajaran);
        if (fetchedNilaiSiswaByKelasPelajaran != null) {
          _nilaiSiswaByUserList = fetchedNilaiSiswaByKelasPelajaran;
        } else {
          _nilaiSiswaByUserList = null;
        }
      } else {
        final List<NilaiSiswaByUserModel>? fetchedNilaiSiswaByKelasPelajaran = await _nilaiSiswaByUserService.nilaiSiswaByKelasPelajaran(token, idKelas, idPelajaran);
        _nilaiSiswaByUserList = fetchedNilaiSiswaByKelasPelajaran;
      }
    } catch (e) {
      // Handle errors
      _errorMessage = 'Error: $e';
    } finally {
      // End the loading process
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNilaiSiswa(String token, int idUser, int idKelas, int idSemester, int idMataPelajaran, int idGuruPengampu, double nilai) async {
    setLoading(true);
    _errorMessage = '';

    try {
      await _nilaiSiswaByUserService.addNilaiSiswa(
          token,
        idUser,
        idKelas,
        idSemester,
        idMataPelajaran,
        idGuruPengampu,
        nilai
      );
      // Handle any additional state updates if needed
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      setLoading(false);
    }
  }
  Future<void> updateNilaiSiswa(String token, int id, int idGuruPengampu, double nilai) async {
    setLoading(true);
    _errorMessage = '';

    try {
      await _nilaiSiswaByUserService.updateNilaiSiswa(
          token,
        id,
        idGuruPengampu,
        nilai
      );
      // Handle any additional state updates if needed
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteNilaiSiswa(String token, int id) async {
    setLoading(true);
    _errorMessage = '';

    try {
      await _nilaiSiswaByUserService.deleteNilaiSiswa(
          token,
        id
      );
      // Handle any additional state updates if needed
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      setLoading(false);
    }
  }
}
