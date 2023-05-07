import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  CartItem(
      {required this.quantity,
      required this.productID,
      required this.price,
      required this.id,
      required this.title});
  final String title;
  final String productID;
  final double price;
  final int quantity;
  final String id;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productID);
      },
      confirmDismiss: (direction) => showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text('Do you want to remove the item from the cart?'),
            actions: [
              TextButton(onPressed: (){Navigator.of(context).pop(false);}, child: const Text('No')),
              TextButton(onPressed: (){Navigator.of(context).pop(true);}, child: const Text('Yes'))
            ],
              )),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Padding(
          padding: EdgeInsets.only(right: 20),
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
            leading: FittedBox(
                child: CircleAvatar(
              child: Text('\$$price'),
            )),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
