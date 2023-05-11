import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  UserProductItem({required this.title, required this.imageUrl});

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
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
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
