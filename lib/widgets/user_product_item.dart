import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/edit_products_screen.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({super.key, required this.id,required this.title, required this.imageUrl});

  final String id;
  final String title;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: SizedBox(
          width: 80,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, EditProductsScreen.routeName , arguments: id);
                },
                icon:  Icon(Icons.edit, color: Theme.of(context).colorScheme.primary,),
              ),
              IconButton(
                onPressed: () {
                  Provider.of<ProductsProvider>(context, listen: false).deleteProduct(id);
                },
                icon: const Icon(Icons.delete, color: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }
}
