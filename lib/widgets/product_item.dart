import 'package:flutter/material.dart';
import 'package:my_shop/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  ProductItem(this.id, this.title, this.imageURL, {super.key});

  final String imageURL;
  final String title;
  final String id;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          leading: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {},
            icon: const Icon(Icons.favorite),
          ),
          backgroundColor: Colors.black54,
          title: Text(title, textAlign: TextAlign.center),
          trailing: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ProductDetails.routeName, arguments: id);
          },
          child: Image.network(imageURL, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
