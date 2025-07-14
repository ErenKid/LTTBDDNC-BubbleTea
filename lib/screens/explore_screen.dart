import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/product_data.dart';
import 'product_detail_page.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';

  final List<Map<String, dynamic>> _allProducts = productList;

  final List<String> _categories = [
    'Tất cả', 'Trà Sữa', 'Cà Phê', 'Nước Trái Cây', 'Bánh'
  ];
  String selectedCategory = 'Tất cả';

  List<Map<String, dynamic>> get _filteredProducts {
    return _allProducts.where((p) {
      final matchName = searchText.isEmpty || p['name'].toString().toLowerCase().contains(searchText.toLowerCase());
      final matchCategory = selectedCategory == 'Tất cả' || p['category'] == selectedCategory;
      return matchName && matchCategory;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar
              Row(
                children: [
                  const SizedBox(width: 4),
                  const Text(
                    'Tìm kiếm',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppTheme.textLight),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: AppTheme.textDark),
                        decoration: const InputDecoration(
                          hintText: 'Tìm kiếm',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchText = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_alt_outlined, color: AppTheme.textLight),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Chọn món',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    spacing: 10,
                                    children: _categories.map((cat) {
                                      final isSelected = selectedCategory == cat;
                                      return ChoiceChip(
                                        label: Text(cat),
                                        selected: isSelected,
                                        onSelected: (_) {
                                          setState(() {
                                            if (isSelected) {
                                              selectedCategory = 'Tất cả';
                                            } else {
                                              selectedCategory = cat;
                                            }
                                          });
                                          Navigator.pop(context);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Section Title
              const Text(
                'Các món nổi bật!',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 12),

              // Product Grid
              Expanded(
                child: _filteredProducts.isEmpty
                    ? const Center(child: Text('Không tìm thấy sản phẩm nào!'))
                    : GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.7,
                        children: _filteredProducts
                            .map((product) => _buildProductCard(
                                  product['name'],
                                  product['rating'],
                                  product['image'],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetailPage(
                                          name: product['name'],
                                          imageUrl: product['image'],
                                          rating: product['rating'],
                                          price: product['price'],
                                        ),
                                      ),
                                    );
                                  },
                                ))
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(String name, double rating, String imagePath, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Image.network(
                  imagePath,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  width: 110,
                  height: 110,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppTheme.textDark,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.star, color: AppTheme.primaryOrange, size: 16),
                const SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.favorite_border, size: 18, color: AppTheme.textLight),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
