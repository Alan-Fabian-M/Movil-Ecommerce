import 'package:flutter/material.dart';
import 'package:myapp/data/models/product_model.dart';
import 'package:myapp/data/services/product_service.dart';
import 'package:myapp/presentation/screens/product_detail_screen.dart';
import 'package:myapp/presentation/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1;
  int _totalPages = 1;
  final int _productsPerPage = 12;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _productService.getProducts(
        page: _currentPage,
        pageSize: _productsPerPage,
      );
      
      setState(() {
        _products = response.results;
        _filteredProducts = response.results;
        _totalPages = (response.count / _productsPerPage).ceil();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar productos: $e';
        _isLoading = false;
      });
    }
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _products;
      } else {
        _filteredProducts = _products
            .where((product) =>
                product.nombre.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  List<Widget> _buildPageNumbers() {
    List<Widget> pageWidgets = [];
    
    // Mostrar máximo 5 números de página
    int start = (_currentPage - 2).clamp(1, _totalPages);
    int end = (_currentPage + 2).clamp(1, _totalPages);
    
    // Ajustar para mostrar siempre 5 páginas cuando sea posible
    if (end - start < 4) {
      if (start == 1) {
        end = (start + 4).clamp(1, _totalPages);
      } else if (end == _totalPages) {
        start = (end - 4).clamp(1, _totalPages);
      }
    }
    
    // Agregar primera página y ellipsis si es necesario
    if (start > 1) {
      pageWidgets.add(_buildPageButton(1));
      if (start > 2) {
        pageWidgets.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text('...', style: TextStyle(color: Colors.white)),
          ),
        );
      }
    }
    
    // Agregar páginas en el rango
    for (int i = start; i <= end; i++) {
      pageWidgets.add(_buildPageButton(i));
    }
    
    // Agregar ellipsis y última página si es necesario
    if (end < _totalPages) {
      if (end < _totalPages - 1) {
        pageWidgets.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text('...', style: TextStyle(color: Colors.white)),
          ),
        );
      }
      pageWidgets.add(_buildPageButton(_totalPages));
    }
    
    return pageWidgets;
  }

  Widget _buildPageButton(int pageNumber) {
    final isCurrentPage = pageNumber == _currentPage;
    
    return GestureDetector(
      onTap: () {
        if (!isCurrentPage) {
          setState(() {
            _currentPage = pageNumber;
          });
          _loadProducts();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isCurrentPage ? Colors.greenAccent : Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCurrentPage ? Colors.greenAccent : Colors.grey[700]!,
            width: 1,
          ),
        ),
        child: Text(
          '$pageNumber',
          style: TextStyle(
            color: isCurrentPage ? Colors.black : Colors.white,
            fontWeight: isCurrentPage ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Banner Hero
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blueAccent.withOpacity(0.3),
                  Colors.black,
                ],
              ),
            ),
            child: const Column(
              children: [
                Text(
                  'Todos los productos',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Explora nuestra colección completa',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterProducts,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[800]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[800]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
                filled: true,
                fillColor: Colors.grey[900],
              ),
            ),
          ),

          // Contador de productos
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Productos (${_filteredProducts.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
                if (_totalPages > 1)
                  Text(
                    'Página $_currentPage de $_totalPages',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[400],
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Lista de productos
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                size: 60, color: Colors.grey[600]),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                _errorMessage!,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadProducts,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                              ),
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      )
                    : _filteredProducts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_bag_outlined,
                                    size: 60, color: Colors.grey[600]),
                                const SizedBox(height: 16),
                                const Text(
                                  'No se encontraron productos',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadProducts,
                            color: Colors.blueAccent,
                            child: GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: _filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = _filteredProducts[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailScreen(slug: product.slug),
                                      ),
                                    );
                                  },
                                  child: ProductCard(product: product),
                                );
                              },
                            ),
                          ),
          ),

          // Paginación mejorada
          if (_totalPages > 1)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botón Primera Página
                    IconButton(
                      onPressed: _currentPage > 1
                          ? () {
                              setState(() {
                                _currentPage = 1;
                              });
                              _loadProducts();
                            }
                          : null,
                      icon: const Icon(Icons.first_page),
                      color: Colors.white,
                      disabledColor: Colors.grey[700],
                    ),
                    
                    // Botón Anterior
                    IconButton(
                      onPressed: _currentPage > 1
                          ? () {
                              setState(() {
                                _currentPage--;
                              });
                              _loadProducts();
                            }
                          : null,
                      icon: const Icon(Icons.chevron_left),
                      color: Colors.white,
                      disabledColor: Colors.grey[700],
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // Números de página
                    ..._buildPageNumbers(),
                    
                    const SizedBox(width: 8),
                    
                    // Botón Siguiente
                    IconButton(
                      onPressed: _currentPage < _totalPages
                          ? () {
                              setState(() {
                                _currentPage++;
                              });
                              _loadProducts();
                            }
                          : null,
                      icon: const Icon(Icons.chevron_right),
                      color: Colors.white,
                      disabledColor: Colors.grey[700],
                    ),
                    
                    // Botón Última Página
                    IconButton(
                      onPressed: _currentPage < _totalPages
                          ? () {
                              setState(() {
                                _currentPage = _totalPages;
                              });
                              _loadProducts();
                            }
                          : null,
                      icon: const Icon(Icons.last_page),
                      color: Colors.white,
                      disabledColor: Colors.grey[700],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
