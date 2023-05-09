import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';
import '../screens/product_details_screen.dart';
import './pop_up_bottomBar.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    print('Rendered');
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (context, value, child) => IconButton(
              onPressed: () {
                product.toggleFavorite();
              },
              icon: Icon(
                product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border, //Favorite
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          backgroundColor: Colors.black54,
          title: Text(product.title, textAlign: TextAlign.center),
          trailing: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
              PopUpBar(
                title: 'Product Added',
                message: '${product.title} added to your cart',
                ctx: context,
                icon: Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
                button: ElevatedButton(
                  onPressed: () => cart.removeSingleItem(product.id),
                  child: const Text('Undo'),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart), //Shopping cart
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: product.id);
          },
          child: Image.network(product.imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

//
// Flushbar(
// title: 'Product Added',
// icon: Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
// message: '${product.title} added to your cart',
// duration: const Duration(seconds: 2),
// margin: const EdgeInsets.all(5),
// borderRadius: BorderRadius.circular(20),
// mainButton: ElevatedButton(
// onPressed: () {
// cart.removeSingleItem(product.id);
// },
// child: const Text('Undo'),
// // ),
// ).show(context);
