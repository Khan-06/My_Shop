import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


import './screens/product_details_screen.dart';
import './providers/cart.dart';
import './screens/products_overview_screen.dart';
import './providers/product_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
        ChangeNotifierProvider(
        create: (ctx) => ProductsProvider()),
      ChangeNotifierProvider(
          create: (ctx) => Cart()),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)
              .copyWith(secondary: Colors.amber),
          textTheme: GoogleFonts.latoTextTheme()
        ),
        home: ProductOverViewScreen(),
        routes: {
          ProductDetails.routeName: (ctx) => ProductDetails()
        },
      ),
    );
  }
}
