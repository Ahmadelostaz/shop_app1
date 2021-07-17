import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite =false,
  });
  void _isFav(bool oldStatus) {
    isFavorite = oldStatus;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    bool oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.https(
        'shops-22913-default-rtdb.firebaseio.com', '/Products/$id.json');
    try {
      final responce =
          await http.patch(url, body: json.encode({'isFavorite': isFavorite}));
      if (responce.statusCode >= 400) {
        _isFav(oldStatus);
      }
    } catch (error) {
      _isFav(oldStatus);
    }
  }
}
