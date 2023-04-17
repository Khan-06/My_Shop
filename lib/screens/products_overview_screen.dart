import 'package:flutter/material.dart';

import '../widgets/productGrid.dart';

class ProductOverViewScreen extends StatelessWidget {
  ProductOverViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Shop'),
      ),
      body: ProductsGrid(),
    );
  }
}
