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
  final String authToken;

  Orders(this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    var url = Uri.https('my-shop-a4071-default-rtdb.firebaseio.com', '/orders.json?auth=$authToken');
    final response = await http.get(url);

    final extractedData = json.decode(response.body) as Map<String, dynamic>?;
    final List<OrderItem> loadedData = [];

    if (extractedData == null) {
      _orders = [];
      notifyListeners();
      return;
    }

    extractedData.forEach((orderID, orderData) {

      loadedData.add(OrderItem(
        id: orderID,
        amount: orderData['amount'],
        products: (orderData['products'] as List<dynamic>)
            .map(
              (item) => CartItem(
            title: item['title'],
            id: item['id'],
            price: item['price'],
            quantity: item['quantity'],
          ),
        )
            .toList(),
        dateTime: DateTime.parse(orderData['dateTime']),
      ));
    });

    _orders = loadedData.reversed.toList();
    notifyListeners();
  }
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    var url =
    Uri.https('my-shop-a4071-default-rtdb.firebaseio.com', '/orders.json');
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
            'title': cp.title,
            'id': cp.id,
            'price': cp.price,
            'quantity': cp.quantity
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
          dateTime: timeStamp),
    );
    notifyListeners();
  }
}
