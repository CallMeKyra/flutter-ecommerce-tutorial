import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  void addToCart(int productId, String title, double price, String thumbnail, String? brand, String? category) {
    final existingItem = _items.firstWhereOrNull((item) => item.productId == productId);

    if (existingItem != null) {
      existingItem.quantity++;
    } else {
      _items.add(CartItem(
        productId: productId,
        title: title,
        price: price,
        thumbnail: thumbnail,
        brand: brand,
        category: category,
      ));
    }
    notifyListeners();
  }

  void incrementQuantity(int productId) {
    final item = _items.firstWhereOrNull((item) => item.productId == productId);
    if (item != null) {
      item.quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(int productId) {
    final item = _items.firstWhereOrNull((item) => item.productId == productId);
    if (item != null) {
      if (item.quantity > 1) {
        item.quantity--;
      } else {
        _items.remove(item);
      }
      notifyListeners();
    }
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}