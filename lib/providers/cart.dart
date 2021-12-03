import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.values
        .map((item) => item.quantity)
        .fold(0, (sum, value) => sum + value);
  }

  double get totalAmount {
    return _items.values
        .map((item) => item.price)
        .fold(0, (sum, value) => sum + value);
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    _items.update(
      productId,
      (existingCartItem) => CartItem(
        id: existingCartItem.id,
        title: existingCartItem.title,
        quantity: existingCartItem.quantity + 1,
        price: existingCartItem.price,
      ),
      ifAbsent: () => CartItem(
        id: DateTime.now().toString(),
        title: title,
        quantity: 1,
        price: price,
      ),
    );
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }
}
