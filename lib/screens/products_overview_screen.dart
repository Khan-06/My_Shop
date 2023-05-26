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
  var _showOnlyFavorites = false;
  bool _isInit = true;
  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts();  Not Working
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit){Provider.of<Products>(context).fetchAndSetProducts();}
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
      drawer: const AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
