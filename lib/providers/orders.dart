import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
   final dato =  DateTime.now();
    final url =
        Uri.https('shops-22913-default-rtdb.firebaseio.com', '/Orders.json');
   final responce =  await http
        .post(url,
            body: json.encode({
              'amount': total,
              'dateTime': dato.toIso8601String(),
              'products': cartProducts.map((e) => {
                'id' : e.id,
                'price' :e.price,
                'quantity':e.quantity,
                'title':e.title
              }).toList()
            }))
        .then((value) {
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(value.body)['name'],
          amount: total,
          dateTime: dato,
          products: cartProducts,
        ),
      );
      notifyListeners();
    });
  }
}
