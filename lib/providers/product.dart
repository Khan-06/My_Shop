import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  bool isFavorite;

  Product(
      {this.isFavorite = false,
      required this.id,
      required this.description,
      required this.title,
      required this.imageUrl,
      required this.price});

  void _setFavValue(bool currentValue) {
    isFavorite = currentValue;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userID) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://my-shop-a4071-default-rtdb.firebaseio.com/userFavorites/$userID/$id.json?auth=$token');
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {'isFavorite': isFavorite},
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
