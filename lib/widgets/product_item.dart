import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

import '../screens/product_details_screen.dart';

import './pop_up_bottomBar.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context);

    print('Rendered');
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (context, value, child) => IconButton(
              onPressed: () {
                product.toggleFavorite(
                    authData.token.toString(), authData.userId.toString());
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
                icon: Icon(Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary),
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
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
