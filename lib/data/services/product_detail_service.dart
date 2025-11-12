import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/product_model.dart';

class ProductDetailService {
  Future<Product> getProductBySlug(String slug) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/api/productos/productos/$slug/');
      print('🔍 Fetching product detail from: $url');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedBody);
        
        final product = Product.fromJson(data);
        
        print('✅ Product loaded: ${product.nombre}');
        print('📦 Variantes: ${product.variantes.length}');
        
        if (product.variantes.isNotEmpty) {
          for (var variante in product.variantes) {
            print('  - SKU: ${variante.sku}, Precio: \$${variante.precio}, Stock: ${variante.stockTotal}');
            print('    Atributos: ${variante.valores.map((v) => '${v.atributo.nombre}: ${v.valor}').join(', ')}');
          }
        }
        
        return product;
      } else if (response.statusCode == 404) {
        throw Exception('Producto no encontrado');
      } else {
        throw Exception('Error al cargar producto: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching product detail: $e');
      rethrow;
    }
  }
}
