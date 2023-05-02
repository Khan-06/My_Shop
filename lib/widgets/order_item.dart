import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatelessWidget {
  final ord.OrderItem order;

  OrderItem({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${order.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy').format(order.dateTime),),
            trailing: IconButton(onPressed: (){}, icon: const Icon(Icons.expand_more),),
          )
        ],
      ),
    );
  }
}
