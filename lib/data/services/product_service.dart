import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/product_model.dart';

class ProductService {
  Future<ProductsResponse> getProducts({int page = 1, int pageSize = 12}) async {
    try {
      final url = ApiConfig.getProductsUrl(page: page, pageSize: pageSize);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        return ProductsResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<List<Product>> searchProducts(String query, {int page = 1}) async {
    try {
      final response = await getProducts(page: page, pageSize: 50);
      
      if (query.isEmpty) {
        return response.results;
      }

      return response.results.where((product) {
        return product.nombre.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      throw Exception('Error searching products: $e');
    }
  }
}
