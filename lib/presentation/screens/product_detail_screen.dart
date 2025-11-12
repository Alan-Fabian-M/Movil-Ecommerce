import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/data/models/product_model.dart';
import 'package:myapp/data/providers/auth_provider.dart';
import 'package:myapp/data/providers/cart_provider.dart';
import 'package:myapp/data/services/product_detail_service.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String slug;

  const ProductDetailScreen({super.key, required this.slug});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductDetailService _productService = ProductDetailService();
  
  Product? _product;
  bool _isLoading = true;
  String? _error;
  
  String? _selectedColor;
  String? _selectedSize;
  Variante? _selectedVariante;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final product = await _productService.getProductBySlug(widget.slug);
      
      if (!mounted) return;
      
      setState(() {
        _product = product;
        _isLoading = false;
        
        // Auto-seleccionar primera opción si hay variantes
        if (product.variantes.isNotEmpty) {
          final colores = product.getColores();
          final tallas = product.getTallas();
          
          if (colores.isNotEmpty) _selectedColor = colores.first;
          if (tallas.isNotEmpty) _selectedSize = tallas.first;
          
          _updateSelectedVariante();
        }
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _updateSelectedVariante() {
    if (_product != null && mounted) {
      setState(() {
        _selectedVariante = _product!.getVarianteBySelection(_selectedColor, _selectedSize);
      });
    }
  }

  void _incrementQuantity() {
    if (_selectedVariante != null && _quantity < _selectedVariante!.stockTotal) {
      setState(() {
        _quantity++;
      });
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _product?.nombre ?? 'Cargando...',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              'Error al cargar el producto',
              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: GoogleFonts.roboto(color: Colors.white60, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_product == null) {
      return const Center(
        child: Text('Producto no encontrado', style: TextStyle(color: Colors.white)),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  _product!.mainImage,
                  fit: BoxFit.cover,
                  height: 300,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 300,
                      color: Colors.grey[800],
                      child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 60),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Nombre del producto
            Text(
              _product!.nombre,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Categoría
            Text(
              _product!.categoria.nombre,
              style: GoogleFonts.roboto(
                color: Colors.white60,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            
            // Precio y stock de la variante seleccionada
            if (_selectedVariante != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${_selectedVariante!.precio}',
                    style: GoogleFonts.roboto(
                      color: Colors.greenAccent,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _selectedVariante!.stockTotal > 0 
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _selectedVariante!.stockTotal > 0 
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    child: Text(
                      _selectedVariante!.stockTotal > 0 
                          ? 'Stock: ${_selectedVariante!.stockTotal}'
                          : 'Sin Stock',
                      style: GoogleFonts.roboto(
                        color: _selectedVariante!.stockTotal > 0 
                            ? Colors.green
                            : Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            
            // Descripción
            if (_product!.descripcion != null && _product!.descripcion!.isNotEmpty) ...[
              Text(
                _product!.descripcion!,
                style: GoogleFonts.roboto(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            // Selector de color
            if (_product!.getColores().isNotEmpty) ...[
              Text(
                'Color:',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _product!.getColores().map((color) {
                  final isSelected = color == _selectedColor;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                        _updateSelectedVariante();
                        _quantity = 1; // Reset quantity
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.greenAccent : Colors.grey[800],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? Colors.greenAccent : Colors.grey[700]!,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        color,
                        style: GoogleFonts.roboto(
                          color: isSelected ? Colors.black : Colors.white,
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
            
            // Selector de talla
            if (_product!.getTallas().isNotEmpty) ...[
              Text(
                'Talla:',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _product!.getTallas().map((size) {
                  final isSelected = size == _selectedSize;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSize = size;
                        _updateSelectedVariante();
                        _quantity = 1; // Reset quantity
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.greenAccent : Colors.grey[800],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? Colors.greenAccent : Colors.grey[700]!,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        size,
                        style: GoogleFonts.roboto(
                          color: isSelected ? Colors.black : Colors.white,
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
            ],
            
            // Selector de cantidad
            if (_selectedVariante != null && _selectedVariante!.stockTotal > 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.white, size: 30),
                    onPressed: _decrementQuantity,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    '$_quantity',
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 30),
                    onPressed: _incrementQuantity,
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
            
            // Botón agregar al carrito
            Consumer2<CartProvider, AuthProvider>(
              builder: (context, cartProvider, authProvider, child) {
                final isLoading = cartProvider.isLoading;
                final canAddToCart = _selectedVariante != null && 
                                    _selectedVariante!.stockTotal > 0 && 
                                    authProvider.isLoggedIn;
                
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canAddToCart
                          ? Colors.white
                          : Colors.grey[800],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: isLoading ? null : (canAddToCart
                        ? () async {
                            final success = await cartProvider.addItem(
                              accessToken: authProvider.accessToken!,
                              varianteId: _selectedVariante!.id,
                              cantidad: _quantity,
                            );
                            
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success 
                                        ? 'Agregado $_quantity ${_product!.nombre} al carrito!'
                                        : 'Error al agregar al carrito',
                                    style: GoogleFonts.roboto(),
                                  ),
                                  backgroundColor: success ? Colors.green : Colors.red,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        : !authProvider.isLoggedIn
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Debes iniciar sesión para agregar al carrito',
                                      style: GoogleFonts.roboto(),
                                    ),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            : null),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            !authProvider.isLoggedIn
                                ? 'Inicia sesión para comprar'
                                : (_selectedVariante != null && _selectedVariante!.stockTotal > 0
                                    ? 'Agregar al Carrito'
                                    : 'Sin Stock Disponible'),
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
