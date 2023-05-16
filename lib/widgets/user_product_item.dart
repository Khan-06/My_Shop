import 'package:flutter/material.dart';
import '../screens/edit_products_screen.dart';

class UserProductItem extends StatelessWidget {
  UserProductItem({required this.id,required this.title, required this.imageUrl});

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
                onPressed: () {},
                icon: const Icon(Icons.delete, color: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }
}
