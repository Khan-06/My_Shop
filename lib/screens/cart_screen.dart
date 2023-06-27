import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartData.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  OrderButton(cart: cartData)
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => CartItem(
                  productID: cartData.items.keys.toList()[index],
                  quantity: cartData.items.values.toList()[index].quantity,
                  price: cartData.items.values.toList()[index].price,
                  id: cartData.items.values.toList()[index].id,
                  title: cartData.items.values.toList()[index].title),
              itemCount: cartData.itemCount,
            ),
          )
        ],
      ),
    );
  }
}



class OrderButton extends StatefulWidget {
  const OrderButton({super.key, required this.cart});
  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading =  false;
  @override
  Widget build(BuildContext context) {
    return  TextButton(onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
        ? null
        : () async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false)
          .addOrder(widget.cart.items.values.toList(),
          widget.cart.totalAmount);
      setState(() {
        _isLoading = false;
      });
      widget.cart.clear();
    }, child: _isLoading ? const  CircularProgressIndicator() : const Text('Order Now'));
  }
}
