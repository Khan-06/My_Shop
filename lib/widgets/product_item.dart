import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  ProductItem(this.id, this.title, this.imageURL, {super.key});

  final String imageURL;
  final String title;
  final String id;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(imageURL, fit: BoxFit.cover),
      footer: GridTileBar(
        title: Text(title, textAlign: TextAlign.center),
      ),

    );
  }
}
