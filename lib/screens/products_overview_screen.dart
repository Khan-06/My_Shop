import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/productGrid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';

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

  bool _showOnlyFavorites = false;
  bool _isInit = true;
  bool _isLoading = false;
  //
  // @override
  // void initState() {
  //   // Provider.of<Products>(context).fetchAndSetProducts();  Not Working
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() => _isLoading = true);
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() => _isLoading = false);
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
                //print(selectedValue);
                setState(() {
                  if (selectedValue == filterOptions.Favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              }),
          Consumer<Cart>(
            builder: (_, cartData, child) => MyBadge(
                value:
                    cartData.itemCount.toString(), //Check this if error comes..
                child: child as Widget),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) :ProductsGrid(_showOnlyFavorites),
    );
  }
}
