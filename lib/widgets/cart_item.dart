import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  CartItem(
      {required this.quantity,
      required this.price,
      required this.id,
      required this.title});
  final String title;
  final double price;
  final int quantity;
  final String id;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          leading: FittedBox(child: CircleAvatar(child: Text('\$$price'),)),
          title: Text(title),
          subtitle: Text('Total: \$${(price * quantity)}'),
          trailing: Text('$quantity x'),

        ),
      ),
    );
  }
}
