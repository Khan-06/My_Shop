import 'package:flutter/material.dart';

class CartItem {
  CartItem(
      {required this.title,
      required this.id,
      required this.price,
      required this.quantity});
  final String id;
  final String title;
  final int quantity;
  final double price;
}

class Cart with ChangeNotifier {
   Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }
  int get itemCount {
    return items == null ? 0 :items.length;
}
double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
}

  void addItem(String productID, String title, double price) {
    if (_items.containsKey(productID)) {
      //change Quanitiy
      _items.update(
        productID,
        (existingCartItem) => CartItem(
            title: existingCartItem.title,
            id: existingCartItem.id,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        productID,
        () => CartItem(
            title: title,
            id: DateTime.now().toString(),
            price: price,
            quantity: 1),
      );
      notifyListeners();
    }
  }

  void removeItem (String productId){
    _items.remove(productId);
    notifyListeners();
  }

  void clear (){
    _items = {};
    notifyListeners();
  }
}
