import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {

  ProductDetails(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:  Text(title),
      ),
      body: const Center(
        child: Text('Product Details'),
      ),);
  }
}
