import 'package:flutter/material.dart';

import 'package:my_shop/providers/product_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/productGrid.dart';

enum filterOptions {
Favorites,
  All,
}

class ProductOverViewScreen extends StatefulWidget {
  ProductOverViewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverViewScreen> createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {

  var _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(itemBuilder: (_) => [
            const PopupMenuItem(value: filterOptions.Favorites, child: Text('Favorites'),),
            const PopupMenuItem(value: filterOptions.All, child:  Text('Show All'),),
          ],icon:const Icon(Icons.more_vert),
          onSelected: (filterOptions selectedValue){
            print(selectedValue);
            setState(() {
              if(selectedValue == filterOptions.Favorites){
                _showOnlyFavorites = true;
              } else {
                _showOnlyFavorites = false;
              }
            });
          } )
        ],
      ),
      body:  ProductsGrid(_showOnlyFavorites),
    );
  }
}
