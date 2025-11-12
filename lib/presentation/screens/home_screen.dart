import 'package:flutter/material.dart';
import 'package:myapp/data/models/product_model.dart';
import 'package:myapp/presentation/screens/product_detail_screen.dart';
import 'package:myapp/presentation/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Product> _products = [
    Product(id: '1', name: 'Minimalist Tee', price: '\$50', imageUrl: 'https://picsum.photos/seed/picsum/400/400', description: 'A high-quality, minimalist t-shirt made from 100% organic cotton. Perfect for everyday wear.'),
    Product(id: '2', name: 'Slim Fit Jeans', price: '\$120', imageUrl: 'https://picsum.photos/seed/picsum2/400/400', description: 'Modern slim fit jeans with a bit of stretch for comfort. A staple for any wardrobe.'),
    Product(id: '3', name: 'Leather Jacket', price: '\$350', imageUrl: 'https://picsum.photos/seed/picsum3/400/400', description: 'Classic biker-style leather jacket. Made from genuine leather for a timeless look.'),
    Product(id: '4', name: 'Classic Watch', price: '\$250', imageUrl: 'https://picsum.photos/seed/picsum4/400/400', description: 'An elegant timepiece with a stainless steel case and a leather strap. Water-resistant up to 50m.'),
    Product(id: '5', name: 'Suede Boots', price: '\$180', imageUrl: 'https://picsum.photos/seed/picsum5/400/400', description: 'Stylish suede boots that are perfect for both casual and formal occasions. Comfortable and durable.'),
    Product(id: '6', name: 'Designer Sunglasses', price: '\$220', imageUrl: 'https://picsum.photos/seed/picsum6/400/400', description: 'Protect your eyes in style with these designer sunglasses, featuring UV400 protection.'),
    Product(id: '7', name: 'Product 7', price: '\$100', imageUrl: 'https://picsum.photos/seed/picsum7/400/400', description: 'This is the description for Product 7. It is a high-quality item.'),
    Product(id: '8', name: 'Product 8', price: '\$150', imageUrl: 'https://picsum.photos/seed/picsum8/400/400', description: 'This is the description for Product 8. It is a high-quality item.'),
    Product(id: '9', name: 'Product 9', price: '\$200', imageUrl: 'https://picsum.photos/seed/picsum9/400/400', description: 'This is the description for Product 9. It is a high-quality item.'),
    Product(id: '10', name: 'Product 10', price: '\$250', imageUrl: 'https://picsum.photos/seed/picsum10/400/400', description: 'This is the description for Product 10. It is a high-quality item.'),
    Product(id: '11', name: 'Product 11', price: '\$300', imageUrl: 'https://picsum.photos/seed/picsum11/400/400', description: 'This is the description for Product 11. It is a high-quality item.'),
    Product(id: '12', name: 'Product 12', price: '\$350', imageUrl: 'https://picsum.photos/seed/picsum12/400/400', description: 'This is the description for Product 12. It is a high-quality item.'),
  ];

  int _currentPage = 0;
  final int _productsPerPage = 6;

  @override
  Widget build(BuildContext context) {
    final int totalPages = (_products.length / _productsPerPage).ceil();
    final int startIndex = _currentPage * _productsPerPage;
    final int endIndex = startIndex + _productsPerPage > _products.length ? _products.length : startIndex + _productsPerPage;
    final List<Product> paginatedProducts = _products.sublist(startIndex, endIndex);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.75,
              ),
              itemCount: paginatedProducts.length,
              itemBuilder: (context, index) {
                final product = paginatedProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: ProductCard(product: product),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _currentPage > 0
                      ? () {
                          setState(() {
                            _currentPage--;
                          });
                        }
                      : null,
                  child: const Text('Previous'),
                ),
                const SizedBox(width: 16),
                Text('${_currentPage + 1} / $totalPages', style: const TextStyle(color: Colors.white)),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _currentPage < totalPages - 1
                      ? () {
                          setState(() {
                            _currentPage++;
                          });
                        }
                      : null,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
