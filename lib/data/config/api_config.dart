class ApiConfig {
  // Cambiar esta URL según tu configuración
  // Para emulador Android: http://10.0.2.2:8000
  // Para dispositivo físico: http://TU_IP_LOCAL:8000
  // Para iOS simulator: http://localhost:8000
  static const String baseUrl = 'http://192.168.0.53:8000';
  
  static const String productsEndpoint = '/api/productos/productos/';
  
  static String getProductsUrl({int page = 1, int pageSize = 12}) {
    return '$baseUrl$productsEndpoint?page=$page&page_size=$pageSize';
  }
}
