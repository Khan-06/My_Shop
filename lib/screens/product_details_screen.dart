import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class ProductDetails extends StatelessWidget {

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {

    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final product = Provider.of<ProductsProvider>(context);
    final productData = product.items.firstWhere((element) => element.id == productId);


    return  Scaffold(
      appBar: AppBar(
        title:  Text(productData.title),
      ),
      body:  Center(
        child: Text(productData.description),
      ),);
  }
}
