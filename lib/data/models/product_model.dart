class Product {
  final int id;
  final String nombre;
  final String slug;
  final String? descripcion;
  final Category categoria;
  final List<ImagenGaleria> imagenesGaleria;
  final List<Variante> variantes;
  final String? price; // Mantener para compatibilidad

  Product({
    required this.id,
    required this.nombre,
    required this.slug,
    this.descripcion,
    required this.categoria,
    required this.imagenesGaleria,
    this.variantes = const [],
    this.price,
  });

  // Propiedades de compatibilidad con el código existente
  String get name => nombre;
  String get description => descripcion ?? '';
  String get imageUrl => mainImage;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      nombre: json['nombre'],
      slug: json['slug'],
      descripcion: json['descripcion'],
      categoria: Category.fromJson(json['categoria']),
      imagenesGaleria: (json['imagenes_galeria'] as List?)
              ?.map((img) => ImagenGaleria.fromJson(img))
              .toList() ??
          [],
      variantes: (json['variantes'] as List?)
              ?.map((v) => Variante.fromJson(v))
              .toList() ??
          [],
      price: json['price'],
    );
  }

  String get mainImage {
    if (imagenesGaleria.isEmpty) return '';
    
    final principal = imagenesGaleria.firstWhere(
      (img) => img.esPrincipal,
      orElse: () => imagenesGaleria.first,
    );
    return principal.imagenUrl ?? principal.imagen ?? '';
  }

  // Helper methods para obtener opciones de variantes
  List<String> getTallas() {
    final Set<String> tallas = {};
    for (var variante in variantes) {
      for (var valor in variante.valores) {
        if (valor.atributo.nombre.toLowerCase() == 'talla') {
          tallas.add(valor.valor);
        }
      }
    }
    return tallas.toList();
  }

  List<String> getColores() {
    final Set<String> colores = {};
    for (var variante in variantes) {
      for (var valor in variante.valores) {
        if (valor.atributo.nombre.toLowerCase() == 'color') {
          colores.add(valor.valor);
        }
      }
    }
    return colores.toList();
  }

  Variante? getVarianteBySelection(String? color, String? talla) {
    if (color == null || talla == null) return null;
    
    return variantes.firstWhere(
      (v) {
        bool hasColor = false;
        bool hasTalla = false;
        
        for (var valor in v.valores) {
          if (valor.atributo.nombre.toLowerCase() == 'color' && 
              valor.valor == color) {
            hasColor = true;
          }
          if (valor.atributo.nombre.toLowerCase() == 'talla' && 
              valor.valor == talla) {
            hasTalla = true;
          }
        }
        
        return hasColor && hasTalla;
      },
      orElse: () => variantes.isNotEmpty ? variantes.first : Variante(
        id: 0,
        sku: '',
        precio: '0',
        stockTotal: 0,
        valores: [],
      ),
    );
  }
}

class Category {
  final int id;
  final String nombre;
  final String slug;

  Category({
    required this.id,
    required this.nombre,
    required this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nombre: json['nombre'],
      slug: json['slug'],
    );
  }
}

class ImagenGaleria {
  final int id;
  final String? imagenUrl;
  final String? imagen;
  final bool esPrincipal;

  ImagenGaleria({
    required this.id,
    this.imagenUrl,
    this.imagen,
    required this.esPrincipal,
  });

  factory ImagenGaleria.fromJson(Map<String, dynamic> json) {
    return ImagenGaleria(
      id: json['id'],
      imagenUrl: json['imagen_url'],
      imagen: json['imagen'],
      esPrincipal: json['es_principal'] ?? false,
    );
  }
}

class Variante {
  final int id;
  final String sku;
  final String precio;
  final int stockTotal;
  final List<ValorAtributo> valores;

  Variante({
    required this.id,
    required this.sku,
    required this.precio,
    required this.stockTotal,
    required this.valores,
  });

  factory Variante.fromJson(Map<String, dynamic> json) {
    return Variante(
      id: json['id'],
      sku: json['sku'] ?? '',
      precio: json['precio']?.toString() ?? '0',
      stockTotal: json['stock_total'] ?? 0,
      valores: (json['valores'] as List?)
              ?.map((v) => ValorAtributo.fromJson(v))
              .toList() ??
          [],
    );
  }

  String getValorAtributo(String nombreAtributo) {
    try {
      return valores
          .firstWhere((v) => v.atributo.nombre.toLowerCase() == nombreAtributo.toLowerCase())
          .valor;
    } catch (_) {
      return '';
    }
  }
}

class ValorAtributo {
  final int id;
  final String valor;
  final Atributo atributo;

  ValorAtributo({
    required this.id,
    required this.valor,
    required this.atributo,
  });

  factory ValorAtributo.fromJson(Map<String, dynamic> json) {
    return ValorAtributo(
      id: json['id'],
      valor: json['valor'] ?? '',
      atributo: Atributo.fromJson(json['atributo']),
    );
  }
}

class Atributo {
  final int id;
  final String nombre;

  Atributo({
    required this.id,
    required this.nombre,
  });

  factory Atributo.fromJson(Map<String, dynamic> json) {
    return Atributo(
      id: json['id'],
      nombre: json['nombre'] ?? '',
    );
  }
}

class ProductsResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Product> results;

  ProductsResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    return ProductsResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List?)
              ?.map((product) => Product.fromJson(product))
              .toList() ??
          [],
    );
  }
}
