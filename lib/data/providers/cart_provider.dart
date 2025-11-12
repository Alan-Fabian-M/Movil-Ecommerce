import 'package:flutter/foundation.dart';
import '../models/cart_model_api.dart';
import '../services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();
  
  CarritoResponse? _carrito;
  bool _isLoading = false;
  String? _error;
  bool _isLoadingCart = false; // Bandera para evitar múltiples cargas simultáneas

  CarritoResponse? get carrito => _carrito;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  int get itemCount => _carrito?.itemCount ?? 0;
  double get totalCarrito => _carrito?.totalCarritoDouble ?? 0.0;
  List<ItemCarrito> get items => _carrito?.items ?? [];

  // Cargar el carrito
  Future<void> loadCart(String accessToken) async {
    // Evitar múltiples cargas simultáneas
    if (_isLoadingCart) {
      print('Cart is already loading, skipping...');
      return;
    }

    try {
      _isLoadingCart = true;
      _isLoading = true;
      _error = null;
      notifyListeners();

      _carrito = await _cartService.getCarrito(accessToken);
      
      _isLoading = false;
      _isLoadingCart = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      _isLoadingCart = false;
      notifyListeners();
      print('Error loading cart: $e');
    }
  }

  // Añadir item al carrito
  Future<bool> addItem({
    required String accessToken,
    required int varianteId,
    required int cantidad,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _carrito = await _cartService.addItemToCart(
        accessToken: accessToken,
        varianteId: varianteId,
        cantidad: cantidad,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error adding item to cart: $e');
      return false;
    }
  }

  // Actualizar cantidad de un item
  Future<bool> updateItemQuantity({
    required String accessToken,
    required int itemId,
    required int cantidad,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _carrito = await _cartService.updateItemQuantity(
        accessToken: accessToken,
        itemId: itemId,
        cantidad: cantidad,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error updating item quantity: $e');
      return false;
    }
  }

  // Eliminar item del carrito
  Future<bool> deleteItem({
    required String accessToken,
    required int itemId,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _carrito = await _cartService.deleteItem(
        accessToken: accessToken,
        itemId: itemId,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error deleting item: $e');
      return false;
    }
  }

  // Limpiar carrito (cuando se cierra sesión)
  void clearCart() {
    _carrito = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
