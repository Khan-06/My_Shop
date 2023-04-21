import 'package:flutter/material.dart';
import 'package:my_shop/providers/product.dart';
import 'package:my_shop/providers/product_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/productGrid.dart';

enum filterOptions {
Favorites,
  All,
}

class ProductOverViewScreen extends StatelessWidget {
  ProductOverViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(itemBuilder: (_) => [
            PopupMenuItem(child: Text('Favorites'),value: filterOptions.Favorites),
            PopupMenuItem(child: Text('Show All'),value: filterOptions.All),
          ],icon:const Icon(Icons.more_vert),
          onSelected: (filterOptions selectedValue){
            print(selectedValue);
            if(selectedValue == filterOptions.Favorites){
              productsContainer.showFavoriteOnly();
            } else {
              productsContainer.showAll();
            }
          } )
        ],
      ),
      body: const ProductsGrid(),
    );
  }
}
