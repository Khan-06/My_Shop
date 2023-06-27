import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
   List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }
   Future<void> fetchAndSetOrders() async {
     final url = Uri.https('flutter-update.firebaseio.com', '/orders.json');
     final response = await http.get(url);
     final List<OrderItem> loadedOrders = [];
     final extractedData = json.decode(response.body) as Map<String, dynamic>;
     if (extractedData == null) {
       return;
     }
     extractedData.forEach((orderId, orderData) {
       loadedOrders.add(
         OrderItem(
           id: orderId,
           amount: orderData['amount'],
           dateTime: DateTime.parse(orderData['dateTime']),
           products: (orderData['products'] as List<dynamic>)
               .map(
                 (item) => CartItem(
               id: item['id'],
               price: item['price'],
               quantity: item['quantity'],
               title: item['title'],
             ),
           ).toList(),
         ),
       );
     });
     _orders = loadedOrders.reversed.toList();
     notifyListeners();
   }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    var timeStamp = DateTime.now();
    var url =
        Uri.https('my-shop-a4071-default-rtdb.firebaseio.com', '/orders.json');
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity,
                    'id': cp.id
                  })
              .toList()
        }));
    print(response.body);
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
