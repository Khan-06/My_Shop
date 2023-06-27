import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = '/orders';

  //not using initState because we have to then change the state of the widget. So now we can use FutureBuilder!
  // void initState() {
  //   // setState(() {
  //   //   _isLoading = true;
  //   // });
  //   // Provider.of<Orders>(context, listen: false)
  //   //     .fetchAndSetOrders()
  //   //     .then((_) => setState(() {
  //   //           _isLoading = false;
  //   //         }));
  //   super.initState();
  // }

  @override

  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
            future:
            Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.error != null) {
                  return const Center(
                    child: Text('SomeThing went wrong!.. OoPs'),
                  ); //error handling
                } else {
                  return Consumer<Orders>(
                      builder: (context, orderData, child) => ListView.builder(
                          itemBuilder: (context, index) =>
                              OrderItem(order: orderData.orders[index]),
                          itemCount: orderData.orders.length));
                }
              }
            }));
  }
}
