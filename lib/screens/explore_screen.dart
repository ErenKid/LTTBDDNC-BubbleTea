import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';

  final List<Map<String, dynamic>> _allProducts = [
    {
      'name': 'Matcha Latte',
      'rating': 4.9,
      'image': 'assets/images/matcha.png',
      'category': 'Trà',
    },
    {
      'name': 'Sữa tươi trân châu đường đen',
      'rating': 4.8,
      'image': 'assets/images/suatuoi.png',
      'category': 'Sữa',
    },
    {
      'name': 'Nước ép Việt Quốc',
      'rating': 4.6,
      'image': 'assets/images/vietquoc.png',
      'category': 'Nước ép',
    },
    {
      'name': 'Nước cộng đồng LGBT+',
      'rating': 4.5,
      'image': 'assets/images/lgbt.png',
      'category': 'Đặc biệt',
    },
    // Thêm sản phẩm khác nếu cần
  ];

  final List<String> _categories = [
    'Tất cả', 'Trà', 'Sữa', 'Nước ép', 'Đặc biệt'
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
                                    'Chọn loại sản phẩm',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
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
                                            selectedCategory = cat;
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

  Widget _buildProductCard(String name, double rating, String imagePath) {
    return Container(
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
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
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
    );
  }
}
