import 'package:flutter/material.dart';

import 'package:my_shop/providers/product_provider.dart';
import 'package:my_shop/screens/cart_screen.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/productGrid.dart';
import '../widgets/badge.dart';

enum filterOptions {
  Favorites,
  All,
}

class ProductOverViewScreen extends StatefulWidget {
  const ProductOverViewScreen({Key? key}) : super(key: key);

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
          PopupMenuButton(
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: filterOptions.Favorites,
                      child: Text('Favorites'),
                    ),
                    const PopupMenuItem(
                      value: filterOptions.All,
                      child: Text('Show All'),
                    ),
                  ],
              icon: const Icon(Icons.more_vert),
              onSelected: (filterOptions selectedValue) {
                print(selectedValue);
                setState(() {
                  if (selectedValue == filterOptions.Favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              }),
          Consumer<Cart>(
            builder: (_, cartData, ch) => MyBadge(
                value: cartData.itemCount.toString(),                   //Check this if error comes..
                child: ch as Widget),
                child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, CartScreen.routeName);
                    }, icon: const Icon(Icons.shopping_cart),),

          )
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
