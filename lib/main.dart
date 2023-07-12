import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_shop/providers/auth.dart';
import 'package:provider/provider.dart';

import './providers/cart.dart';
import './providers/products.dart';
import './providers/orders.dart';

import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_products_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_details_screen.dart';
import './screens/cart_screen.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Products()),
          ChangeNotifierProvider(create: (ctx) => Cart()),
          ChangeNotifierProvider(create: (ctx) => Orders()),
          ChangeNotifierProvider(create: (ctx) => Auth())
        ],
        child: Consumer<Auth>(
            builder: (context, auth, _) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'MyShop',
                  theme: ThemeData.light().copyWith(
                      colorScheme:
                          ColorScheme.fromSwatch(primarySwatch: Colors.orange)
                              .copyWith(secondary: Colors.amber),
                      textTheme: GoogleFonts.latoTextTheme()),
                  home: auth.isAuth ?  ProductOverViewScreen() : AuthScreen(),
                  routes: {
                    ProductDetails.routeName: (ctx) => ProductDetails(),
                    CartScreen.routeName: (ctx) => const CartScreen(),
                    OrdersScreen.routeName: (context) => const OrdersScreen(),
                    UserProductScreen.routeName: (context) =>
                        const UserProductScreen(),
                    EditProductsScreen.routeName: (context) =>
                        const EditProductsScreen()
                  },
                )));
  }
}
