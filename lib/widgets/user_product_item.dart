import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/edit_products_screen.dart';
import './pop_up_bottomBar.dart';

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
                onPressed: () async {
                  try{
                   await Provider.of<Products>(context, listen: false).deleteProduct(id);
                  }
                  catch (error) {
                   PopUpBar(title: "Deleting Failed", message: error.toString(), ctx: context);
                  }
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

//https://cdn.pixabay.com/photo/2015/12/03/08/50/paper-1074131_1280.jpg
