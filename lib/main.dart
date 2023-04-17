import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


import './screens/product_details_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/product_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ProductsProvider() ,
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
