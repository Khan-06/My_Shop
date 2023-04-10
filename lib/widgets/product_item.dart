import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  ProductItem(this.id, this.title, this.imageURL, {super.key});

  final String imageURL;
  final String title;
  final String id;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: GridTileBar(
        leading: IconButton(onPressed: (){}, icon: const Icon(Icons.favorite)),
        backgroundColor: Colors.black54,
        title: Text(title, textAlign: TextAlign.center),
        trailing: IconButton(onPressed: (){}, icon: const Icon(Icons.shopping_cart)),
      ),
      child:  Image.network(imageURL, fit: BoxFit.cover),

    );
  }
}
