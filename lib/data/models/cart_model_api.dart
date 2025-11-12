// Modelos para el carrito desde la API

class CarritoResponse {
  final String id;
  final int usuario;
  final String? sessionKey;
  final List<ItemCarrito> items;
  final String totalCarrito;

  CarritoResponse({
    required this.id,
    required this.usuario,
    this.sessionKey,
    required this.items,
    required this.totalCarrito,
  });

  factory CarritoResponse.fromJson(Map<String, dynamic> json) {
    return CarritoResponse(
      id: json['id'] ?? '',
      usuario: json['usuario'] ?? 0,
      sessionKey: json['session_key'],
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => ItemCarrito.fromJson(item))
              .toList() ??
          [],
      totalCarrito: json['total_carrito'] ?? '0.00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario': usuario,
      'session_key': sessionKey,
      'items': items.map((item) => item.toJson()).toList(),
      'total_carrito': totalCarrito,
    };
  }

  double get totalCarritoDouble {
    return double.tryParse(totalCarrito) ?? 0.0;
  }

  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.cantidad);
  }
}

class ItemCarrito {
  final int id;
  final VarianteCarrito variante;
  final int cantidad;
  final String precioFinal;
  final String subtotal;

  ItemCarrito({
    required this.id,
    required this.variante,
    required this.cantidad,
    required this.precioFinal,
    required this.subtotal,
  });

  factory ItemCarrito.fromJson(Map<String, dynamic> json) {
    return ItemCarrito(
      id: json['id'] ?? 0,
      variante: VarianteCarrito.fromJson(json['variante'] ?? {}),
      cantidad: json['cantidad'] ?? 0,
      precioFinal: json['precio_final'] ?? '0.00',
      subtotal: json['subtotal'] ?? '0.00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'variante': variante.toJson(),
      'cantidad': cantidad,
      'precio_final': precioFinal,
      'subtotal': subtotal,
    };
  }

  double get precioFinalDouble {
    return double.tryParse(precioFinal) ?? 0.0;
  }

  double get subtotalDouble {
    return double.tryParse(subtotal) ?? 0.0;
  }
}

class VarianteCarrito {
  final int id;
  final String nombre;
  final String sku;
  final String? imagenUrl;

  VarianteCarrito({
    required this.id,
    required this.nombre,
    required this.sku,
    this.imagenUrl,
  });

  factory VarianteCarrito.fromJson(Map<String, dynamic> json) {
    return VarianteCarrito(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      sku: json['sku'] ?? '',
      imagenUrl: json['imagen_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'sku': sku,
      'imagen_url': imagenUrl,
    };
  }
}
