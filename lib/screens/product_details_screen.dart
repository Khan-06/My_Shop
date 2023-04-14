import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  //
  // ProductDetails(this.title, {super.key});
  //
  // final String title;

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {

    final productId = ModalRoute.of(context)?.settings.arguments as String;
    return  Scaffold(
      appBar: AppBar(
        title:  Text('title'),
      ),
      body: const Center(
        child: Text('Product Details'),
      ),);
  }
}
