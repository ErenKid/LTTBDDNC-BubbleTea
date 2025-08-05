import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../theme/app_theme.dart';
import 'profile_screen.dart';
import 'explore_screen.dart';
import 'cart_screen.dart';
import 'product_detail_page.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../providers/category_provider.dart';
import '../providers/product_provider.dart';
import '../services/mock_auth_service.dart';

class HomeTabContent extends StatefulWidget {
  const HomeTabContent({super.key});

  @override
  State<HomeTabContent> createState() => _HomeTabContentState();
}

class _HomeTabContentState extends State<HomeTabContent> {
  String selectedCategory = 'Tất cả';
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';

  // Sử dụng ProductProvider từ provider
  List<ProductModel> get filteredProducts {
    final productProvider = Provider.of<ProductProvider>(context);
    return productProvider.products.where((p) {
      final matchCategory = selectedCategory == 'Tất cả' || _getCategoryNameById(p.categoryId) == selectedCategory;
      final matchName = searchText.isEmpty || p.title.toLowerCase().contains(searchText.toLowerCase());
      return matchCategory && matchName;
    }).toList();
  }

  String _getCategoryNameById(String categoryId) {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final category = categoryProvider.categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => CategoryModel(
        id: '', 
        name: 'Khác', 
        colorHex: '#808080',
        description: '',
        createdAt: DateTime.now(),
      ),
    );
    return category.name;
  }

  @override
  void initState() {
    super.initState();
    // Load categories và products khi khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).loadCategories();
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<CategoryProvider>(context, listen: false).refreshCategories();
          await Provider.of<ProductProvider>(context, listen: false).refreshProducts();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Location Bar
            // Top Greeting + Avatar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Đặt đồ uống bạn yêu thích!',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none),
                          color: AppTheme.textDark,
                          onPressed: () {
                            Navigator.pushNamed(context, '/notifications');
                          },
                        ),
                        const SizedBox(width: 4),
                        Consumer<MockAuthService>(
                          builder: (context, authService, child) {
                            final user = authService.currentUser;
                            return CircleAvatar(
                              radius: 20,
                              backgroundColor: AppTheme.primaryOrange.withOpacity(0.2),
                              child: user?.photoUrl?.isNotEmpty == true
                                  ? ClipOval(
                                      child: Image.network(
                                        user!.photoUrl!,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(
                                            Icons.person,
                                            color: AppTheme.primaryOrange,
                                            size: 24,
                                          );
                                        },
                                      ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      color: AppTheme.primaryOrange,
                                      size: 24,
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: AppTheme.textDark),
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search, color: AppTheme.primaryOrange),
                      hintText: 'Bạn muốn uống gì?',
                      hintStyle: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15, 
                        color: AppTheme.textLight,
                      ),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Filter Buttons (All, Combos, etc.)
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _buildFilterChip('All', icon: Icons.local_drink, selected: true),
                    _buildFilterChip('Combos', icon: Icons.star),
                    _buildFilterChip('Sliders', icon: Icons.local_cafe),
                    _buildFilterChip('Classic', icon: Icons.cake),
                  ],
                ),
              ),
              const SizedBox(height: 14),

            const SizedBox(height: 12),
            // Browse Categories
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Các loại nước uống',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.textDark,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Dynamic Categories from Database
            Consumer<CategoryProvider>(
              builder: (context, categoryProvider, child) {
                if (categoryProvider.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                
                if (categoryProvider.categories.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Chưa có danh mục nào',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  );
                }
                
                return Container(
                  height: 50, // Giảm chiều cao
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryProvider.categories.length + 1, // +1 for "Tất cả" button
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // "Tất cả" button
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: _buildAllCategoriesButton(),
                        );
                      }
                      final category = categoryProvider.categories[index - 1];
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: _buildDynamicCategory(category),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 18),
            // Special Offers
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Đặc biệt!',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.textDark,
                ),
              ),
            ),
            const SizedBox(height: 10),
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  children: [
                    // Background image
                    Image.asset(
                      'assets/images/banner.png',
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                    // Overlay text
                    Positioned(
                      right: 18,
                      top: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            'Siêu\nGiảm giá',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                              shadows: [Shadow(blurRadius: 4, color: Colors.black45, offset: Offset(1, 1))],
                            ),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(height: 6),
                          Text(
                            '15% trị giá',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white,
                              shadows: [Shadow(blurRadius: 4, color: Colors.black45, offset: Offset(1, 1))],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                return productProvider.isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                        childAspectRatio: 0.7,

                        children: filteredProducts.map((product) => _buildProductCard(
                          product.title,
                          4.5, // Default rating since ProductModel might not have rating
                          product.imageUrl ?? '', // Use product imageUrl instead of donorPhotoUrl
                          isNetwork: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                  name: product.title,
                                  imageUrl: product.imageUrl ?? '',
                                  imageUrls: product.imageUrls, // Truyền danh sách ảnh
                                  rating: 4.5,
                                  price: product.price,
                                ),
                              ),
                            );
                          },
                        )).toList(),
                      );
              },
            ),
          ),

          ],
        ),
      ),
        ),
    );
  }

  Widget _buildFilterChip(String label, {IconData? icon, bool selected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryOrange : Colors.grey[200],
          borderRadius: BorderRadius.circular(24),
          boxShadow: selected
              ? [BoxShadow(color: AppTheme.primaryOrange.withOpacity(0.18), blurRadius: 8, offset: Offset(0, 2))]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: selected ? Colors.white : AppTheme.primaryOrange),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: selected ? Colors.white : AppTheme.textDark,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

      Widget _buildCategoryFF(String name, String imagePath, {bool selected = false, VoidCallback? onTap}) {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppTheme.primaryOrange : Colors.transparent,
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                imagePath,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
                color: selected ? AppTheme.primaryOrange : AppTheme.textDark,
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildDynamicCategory(CategoryModel category) {
      final isSelected = selectedCategory == category.name;
      return GestureDetector(
        onTap: () {
          setState(() {
            if (selectedCategory == category.name) {
              selectedCategory = 'Tất cả';
            } else {
              selectedCategory = category.name;
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected 
                ? Color(int.parse(category.colorHex.substring(1), radix: 16) + 0xFF000000)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected 
                  ? Color(int.parse(category.colorHex.substring(1), radix: 16) + 0xFF000000)
                  : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Text(
            category.name,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
              color: isSelected ? Colors.white : AppTheme.textDark,
            ),
          ),
        ),
      );
    }

    Widget _buildAllCategoriesButton() {
      final isSelected = selectedCategory == 'Tất cả';
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = 'Tất cả';
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryOrange : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppTheme.primaryOrange : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Text(
            'Tất cả',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
              color: isSelected ? Colors.white : AppTheme.textDark,
            ),
          ),
        ),
      );
    }
}
Widget _buildProductCard(String name, double rating, String imagePath, {bool isNetwork = false, VoidCallback? onTap}) {
  // Kiểm tra xem đây có phải là đường dẫn file local không
  final bool isLocalFile = imagePath.isNotEmpty && !imagePath.startsWith('http') && !imagePath.startsWith('assets/');
  
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: _buildImageWidget(imagePath, isNetwork, isLocalFile),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            name,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: AppTheme.textDark,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
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
              Icon(Icons.favorite_border, size: 18, color: AppTheme.primaryOrange.withOpacity(0.5)),
            ],
          ),
        ],
      ),
    ),
  );
}

// Hàm helper để xử lý hiển thị ảnh  
Widget _buildImageWidget(String imagePath, bool isNetwork, bool isLocalFile) {
  if (imagePath.isEmpty) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, 
               color: Colors.grey.shade400, size: 40),
          const SizedBox(height: 4),
          Text('Sản phẩm', 
               style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
        ],
      ),
    );
  }

  Widget imageWidget;
  
  if (isLocalFile) {
    // Ảnh từ file local
    imageWidget = Image.file(
      File(imagePath),
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      width: 110,
      height: 110,
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorImageWidget();
      },
    );
  } else if (isNetwork || imagePath.startsWith('http')) {
    // Ảnh từ network
    imageWidget = Image.network(
      imagePath,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      width: 110,
      height: 110,
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorImageWidget();
      },
    );
  } else {
    // Ảnh từ assets
    imageWidget = Image.asset(
      imagePath,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      width: 110,
      height: 110,
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorImageWidget();
      },
    );
  }

  return ClipRRect(
    borderRadius: BorderRadius.circular(14),
    child: imageWidget,
  );
}

// Hàm helper để hiển thị error image
Widget _buildErrorImageWidget() {
  return Container(
    width: 110,
    height: 110,
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image_not_supported, 
             color: Colors.grey.shade400, size: 40),
        const SizedBox(height: 4),
        Text('Không có ảnh', 
             style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
      ],
    ),
  );
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // Cho phép truy cập allProducts từ ngoài
  static final List<Map<String, dynamic>> allProducts = [
    {
      'name': 'Oolong Hạt Sen',
      'image': 'https://product.hstatic.net/200000399631/product/oolong_hat_sen_9d503ae63b534f8fabc58ce733a80360_1024x1024.jpg',
      'rating': 4.7,
      'price': 58000,
      'category': 'Trà Sữa',
    },
    {
      'name': 'Trà Lài Sữa Chân Châu',
      'image': 'https://product.hstatic.net/200000399631/product/tra_lai_sua_tran_chau_cd661d498a9547c6b110ac5ebd67feda_1024x1024.jpg',
      'rating': 4.5,
      'price': 40000,
      'category': 'Trà Sữa',
    },
    {
      'name': 'Trà Vải',
      'image': 'https://product.hstatic.net/200000399631/product/nang_dd840ca67504440186053f6512d5c319_1024x1024.jpg',
      'rating': 4.6,
      'price': 35000,
      'category': 'Nước Trái Cây',
    },
    {
      'name': 'Trà Thanh Long Dâu',
      'image': 'https://product.hstatic.net/200000399631/product/tra_thanh_long_dau_f4d8ad8dd4ce42f299e0850e85defafe_master.jpg',
      'rating': 4.9,
      'price': 52000,
      'category': 'Nước Trái Cây',
    },
    {
      'name': 'Cà Phê Đen',
      'image': 'https://product.hstatic.net/200000399631/product/cafe_den_da_93a2be4731c94c84b28dee1600e4ff1f_1024x1024.jpg',
      'rating': 4.9,
      'price': 45000,
      'category': 'Cà Phê',
    },
    {
      'name': 'Cà Phê Sữa Đá',
      'image': 'https://product.hstatic.net/200000399631/product/cafe_sua_da_538f1cb5c8ca482e940a03121ab0975c_master.jpg',
      'rating': 4.8,
      'price': 50000,
      'category': 'Cà Phê',
    },
    {
      'name': 'Bánh mì bơ tỏi',
      'image': 'https://product.hstatic.net/200000399631/product/banh_mi_bo_toi_695e5600e21a4f01ba120de3e3510ec9_1024x1024.jpg',
      'rating': 4.4,
      'price': 40000,
      'category': 'Bánh',
    },
    {
      'name': 'Bánh Sừng Bò',
      'image': 'https://product.hstatic.net/200000399631/product/banh_croissant_5da481cf60b4447c9f7a98bb90803a9c.jpg',
      'rating': 4.2,
      'price': 30000,
      'category': 'Bánh',
    },
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeTabContent(),
    const ExploreScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBusinessCard(String name, String desc, double rating, double distance) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              desc,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.star, color: AppTheme.primaryOrange, size: 18),
                const SizedBox(width: 4),
                Text('$rating',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: AppTheme.textDark,
                    )),
                const SizedBox(width: 8),
                const Text('Rating',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: AppTheme.textLight,
                    )),
                const SizedBox(width: 16),
                Icon(Icons.location_on, color: AppTheme.primaryOrange, size: 18),
                const SizedBox(width: 4),
                Text('$distance Km',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: AppTheme.textDark,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: AppTheme.primaryOrange,
      unselectedItemColor: AppTheme.textLight,
      selectedLabelStyle: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontFamily: 'Montserrat'),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          activeIcon: Icon(Icons.search),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          activeIcon: Icon(Icons.shopping_cart),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: '',
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      elevation: 8,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}