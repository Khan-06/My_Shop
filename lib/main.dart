import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_shop/screens/product_details_screen.dart';


import 'screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
