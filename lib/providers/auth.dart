import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  late final String? _token;
  late  DateTime? _expiryDate = null; //Check for errors later
  late final String _userId;

  bool get isAuth {
   return token != null;
  }

  String? get token {
    if(_expiryDate != null && _expiryDate!.isAfter(DateTime.now()) && _token != null){
      return _token;
    }
    return null;
  }


  Future<void> _authentication (String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAh2sctSnLg_nyUPrrGnpjyzQa1KlIKheU');
    try{
      final response = await http.post(
        url,
        body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true},
        ),
      );
      print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if(responseData != null){
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    }catch(error){
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authentication(email, password, 'signUp');
  }
  Future<void> logIn (String email, String password) async {
   return _authentication(email, password, 'signInWithPassword');
  }
}
