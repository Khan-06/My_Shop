import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);

  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add),),],
      ),
      drawer: const AppDrawer(),
      body: Padding(padding: const EdgeInsets.all(8),
      child: ListView.builder(itemBuilder: (_, index) => UserProductItem(title: productsData.items[index].title, imageUrl: productsData.items[index].imageUrl),itemCount: productsData.items.length),),
    );
  }
}