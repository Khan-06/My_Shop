
import 'package:flutter/material.dart';

class Product with ChangeNotifier  {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  bool isFavorite;

  Product({
    this.isFavorite = false,
    required this.id,
    required this.description,
    required this.title,
    required this.imageUrl,
    required this.price});

  void toggleFavorite(){
    isFavorite = !isFavorite;
    notifyListeners();
  }
}