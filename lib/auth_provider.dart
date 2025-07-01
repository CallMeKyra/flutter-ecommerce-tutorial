import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String _username = "";
  String _password = "";
  String _message = "";

  String get message => _message;

  void setUsername(String username) {
    _username = username;
  }

  void setPassword(String password) {
    _password = password;
  }

  Future<bool> login() async {
    if (_username.isEmpty || _password.isEmpty) {
      _message = "Username dan password tidak boleh kosong!";
      notifyListeners();
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': _username,
          'password': _password,
        }),
      );

      if (response.statusCode == 200) {
        _message = 'Login Berhasil!';
        notifyListeners();
        return true;
      } else {
        _message = 'Username atau Password salah!';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _message = 'Terjadi kesalahan saat login!';
      notifyListeners();
      return false;
    }
  }
}
