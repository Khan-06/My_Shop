import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  // const ProductItem(this.id, this.title, this.imageURL, {super.key});
  //
  // final String imageURL;
  // final String title;
  // final String id;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          leading: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              product.toggleFavorite();
            },
            icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border),        //Favorite Icon
          ),
          backgroundColor: Colors.black54,
          title: Text(product.title, textAlign: TextAlign.center),
          trailing: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart),                                    //Shopping cart
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
