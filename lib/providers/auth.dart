import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  late final String _token;
  late final DateTime _expiryDate;
  late final String _userId;

  Future<void> signUp(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAh2sctSnLg_nyUPrrGnpjyzQa1KlIKheU');
    final response = await http.post(
      url,
      body: json.encode(
        {'email': email, 'password': password, 'returnSecureToken': true},
      ),
    );
    print(response.body);
  }
  Future<void> logIn (String email, String password) async {
    final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAh2sctSnLg_nyUPrrGnpjyzQa1KlIKheU');
    final response = http.post(url, body: json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true
    }));
  }
}
