import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_products_screen.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);

  static const routeName = '/user-products';

  Future<void> _refreshPage(BuildContext ctx) async {
    await Provider.of<Products>(ctx, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, EditProductsScreen.routeName);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
            future: _refreshPage(context),
            builder: (ctx, snapShot) => snapShot.connectionState ==
                    ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshPage(context),
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: const EdgeInsets.all(9),
                        child: ListView.builder(
                            itemBuilder: (_, index) => UserProductItem(
                                id: productsData.items[index].id,
                                title: productsData.items[index].title,
                                imageUrl: productsData.items[index].imageUrl),
                            itemCount: productsData.items.length),
                      ),
                    ),
                  )));
  }
}
