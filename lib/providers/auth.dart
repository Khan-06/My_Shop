import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
    String? _token;
  late  DateTime? _expiryDate = null; //Check for errors later
    String? _userId;
    Timer? _authTimer;

  bool get isAuth {
   return token != null;
  }

  String? get token {
    if(_expiryDate != null && _expiryDate!.isAfter(DateTime.now()) && _token != null){
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId!;
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
      if(responseData == null){
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn']),),);
      autoLogOut();
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

  void logout(){
    _token = null;
    _userId = '';
    _expiryDate = null;
    if(_authTimer != null){
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  void autoLogOut (){
    if(_authTimer != null){
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout,);
  }
}
