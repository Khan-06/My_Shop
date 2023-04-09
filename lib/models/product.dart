import 'package:flutter/material.dart';

class Product {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageURL;
  bool isFavorite;

  Product({
    this.isFavorite = false,
    required this.id,
    required this.description,
    required this.title,
    required this.imageURL,
    required this.price});
}
