import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  var _showFavoritesOnly = false;
  final String authToken;
  final String userID;

  Products(this.authToken, this.userID ,this._items);

  List<Product> get items {
    if (_showFavoritesOnly) {
      return _items
          .where(
            (element) => element.isFavorite,
          )
          .toList();
    }
    return [..._items];
  }

  List<Product> get favItems {
    return items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    var url = Uri.parse('https://my-shop-a4071-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.get(url);
      //print(json.decode(response.body));
      final List<Product> loadedProducts = [];
      final Map<String, dynamic>? extractedData = json.decode(response.body);
      if(extractedData == null){
        return;
      }
      url = Uri.parse('https://my-shop-a4071-default-rtdb.firebaseio.com/userFavorites/$userID.json?auth=$authToken');
      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            description: prodData['description'],
            title: prodData['title'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            isFavorite: favData == null ? false : favData[prodId] ?? false));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProducts(Product product) async {
    var url = Uri.https(
        'my-shop-a4071-default-rtdb.firebaseio.com', '/products.json', {'auth': authToken},);
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          },
        ),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          description: product.description,
          title: product.title,
          imageUrl: product.imageUrl,
          price: product.price);
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  void showFavoriteOnly() {
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoritesOnly = false;
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      final url = Uri.parse('https://my-shop-a4071-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl
          }));
      notifyListeners();
    } else {
      print('no ID');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse('https://my-shop-a4071-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');

    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeWhere((element) => element.id == id);

    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete the product!');
    }
    existingProduct = null;
  }
}
