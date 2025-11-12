import 'package:flutter/foundation.dart';
import 'package:myapp/data/models/product_model.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });
}

class CartModel extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(Product product, int quantity) {
    final productId = product.id.toString();
    
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          name: existingCartItem.name,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
          quantity: existingCartItem.quantity + quantity,
        ),
      );
    } else {
      // Usar un precio por defecto si no está disponible
      final price = product.price != null 
          ? double.tryParse(product.price!.replaceAll(r'$', '')) ?? 0.0
          : 0.0;
          
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          name: product.name,
          price: price,
          imageUrl: product.imageUrl,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
