import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user-products';

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  var _ref = false;
  Future<void> _refreshProducts(BuildContext context) async {
    setState(() {
      _ref= true;
    });

    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((value) {
      setState(() {
        _ref = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        color: Colors.red[900],
        onRefresh: () => _refreshProducts(context),
        child: !_ref
            ? Padding(
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: productsData.items.length,
                  itemBuilder: (_, i) => Column(
                    children: [
                      UserProductItem(
                        productsData.items[i].id,
                        productsData.items[i].title,
                        productsData.items[i].imageUrl,
                      ),
                      Divider(),
                    ],
                  ),
                ),
              )
            : AlertDialog(
                title: Text('you are loading'),
                content: Icon(Icons.downloading_outlined,color: Colors.blue,),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0)),
              ),
      ),
    );
  }
}
