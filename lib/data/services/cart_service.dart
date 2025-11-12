import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/cart_model_api.dart';

class CartService {
  // Obtener el carrito del usuario autenticado
  Future<CarritoResponse> getCarrito(String accessToken) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/api/carritos/');
      print('🛒 Fetching cart from: $url');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('📡 Cart response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedBody);
        print('✅ Cart loaded successfully');
        return CarritoResponse.fromJson(data);
      } else {
        final errorBody = utf8.decode(response.bodyBytes);
        print('❌ Failed to load cart: $errorBody');
        throw Exception('Error al cargar el carrito');
      }
    } catch (e) {
      print('❌ Error in getCarrito: $e');
      rethrow;
    }
  }

  // Añadir item al carrito
  Future<CarritoResponse> addItemToCart({
    required String accessToken,
    required int varianteId,
    required int cantidad,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/api/carritos/items/');
      print('➕ Adding item to cart: $url');
      print('📦 Variant ID: $varianteId, Quantity: $cantidad');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          'variante_id': varianteId,
          'cantidad': cantidad,
        }),
      );

      print('📡 Add item response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedBody);
        print('✅ Item added successfully');
        return CarritoResponse.fromJson(data);
      } else {
        final errorBody = utf8.decode(response.bodyBytes);
        print('❌ Failed to add item: $errorBody');
        throw Exception('Error al agregar producto al carrito');
      }
    } catch (e) {
      print('❌ Error in addItemToCart: $e');
      rethrow;
    }
  }

  // Actualizar cantidad de un item
  Future<CarritoResponse> updateItemQuantity({
    required String accessToken,
    required int itemId,
    required int cantidad,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/api/carritos/items/$itemId/');
      print('🔄 Updating item: $url');
      print('📦 New quantity: $cantidad');

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          'cantidad': cantidad,
        }),
      );

      print('📡 Update item response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedBody);
        print('✅ Item updated successfully');
        return CarritoResponse.fromJson(data);
      } else {
        final errorBody = utf8.decode(response.bodyBytes);
        print('❌ Failed to update item: $errorBody');
        throw Exception('Error al actualizar cantidad');
      }
    } catch (e) {
      print('❌ Error in updateItemQuantity: $e');
      rethrow;
    }
  }

  // Eliminar un item del carrito
  Future<CarritoResponse> deleteItem({
    required String accessToken,
    required int itemId,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/api/carritos/items/$itemId/');
      print('🗑️ Deleting item: $url');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('📡 Delete item response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedBody);
        print('✅ Item deleted successfully');
        return CarritoResponse.fromJson(data);
      } else {
        final errorBody = utf8.decode(response.bodyBytes);
        print('❌ Failed to delete item: $errorBody');
        throw Exception('Error al eliminar producto');
      }
    } catch (e) {
      print('❌ Error in deleteItem: $e');
      rethrow;
    }
  }
}
