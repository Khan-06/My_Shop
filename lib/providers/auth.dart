import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  final String _token;
  final DateTime _expiryDate;
  final String _userId;

  Auth(this._userId, this._token, this._expiryDate);

  Future<void> signUp(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAh2sctSnLg_nyUPrrGnpjyzQa1KlIKheU');
    http.post(
      url,
      body: json.encode(
        {'email': email, 'password': password, 'returnSecureToken': true},
      ),
    );
  }
}
