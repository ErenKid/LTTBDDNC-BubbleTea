import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'profile_screen.dart';
import 'explore_screen.dart';
import 'cart_screen.dart';

class HomeTabContent extends StatelessWidget {
  const HomeTabContent({super.key});
    Widget _buildFilterChip(String label, {bool selected = false}) {
  return Padding(
    padding: const EdgeInsets.only(right: 8),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppTheme.primaryOrange : Colors.grey[200],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Montserrat',
          color: selected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
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
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/images/pfp.png'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search, color: Colors.grey),
                      hintText: 'Bạn muốn uống gì',
                      hintStyle: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Filter Buttons (All, Combos, etc.)
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _buildFilterChip('All', selected: true),
                    _buildFilterChip('Combos'),
                    _buildFilterChip('Sliders'),
                    _buildFilterChip('Classic'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

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
            SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    const SizedBox(width: 12),
                    _buildCategoryFF('Trà', 'assets/images/tea.png'),
                    _buildCategoryFF('Nước Trái Cây', 'assets/images/juice.png'),
                    _buildCategoryFF('Sữa', 'assets/images/milk.png'),
                    _buildCategoryFF('Nước Có Ga', 'assets/images/soda.png'),
                    _buildCategoryFF('Mocktail', 'assets/images/mocktail.png'),
                    _buildCategoryFF('Trà Sữa', 'assets/images/bubble_tea.png'),
                    _buildCategoryFF('Cà Phê', 'assets/images/coffee.png'),
                    _buildCategoryFF('Nước Lọc', 'assets/images/water.png'),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            const SizedBox(height: 18),
            // Special Offers
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Nước uống đặc biệt',
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
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
              children: [
                _buildProductCard('Trà Đào Cam Sả', 4.9, 'https://lofita.vn/public/upload/files/Tra%20dao%20cam%20sa.jpg', isNetwork: true),
                _buildProductCard('Matcha Latte', 4.8, 'https://product.hstatic.net/200000399631/product/matcha_latte_0d1b0d9ae0914815bb771b78ed338e98_master.jpg', isNetwork: true),
                _buildProductCard('Cà Phê Sữa Đá', 4.8, 'https://product.hstatic.net/200000399631/product/cafe_sua_da_538f1cb5c8ca482e940a03121ab0975c_master.jpg', isNetwork: true),
                _buildProductCard('Cà Phê Đen', 4.9, 'https://product.hstatic.net/200000399631/product/cafe_den_da_93a2be4731c94c84b28dee1600e4ff1f_1024x1024.jpg', isNetwork: true),
                _buildProductCard('Trà Vải', 4.6, 'https://product.hstatic.net/200000399631/product/nang_dd840ca67504440186053f6512d5c319_1024x1024.jpg', isNetwork: true),
                _buildProductCard('Trà Thanh Long Dâu', 4.9, 'https://product.hstatic.net/200000399631/product/tra_thanh_long_dau_f4d8ad8dd4ce42f299e0850e85defafe_master.jpg', isNetwork: true),
                _buildProductCard('Matcha Latte', 4.7, 'https://katinat.vn/wp-content/uploads/2023/07/matcha-latte.jpg', isNetwork: true),
                _buildProductCard('Nước Ép Cam', 4.5, 'https://katinat.vn/wp-content/uploads/2023/07/nuoc-ep-cam.jpg', isNetwork: true),
                _buildProductCard('Soda Việt Quất', 4.4, 'https://katinat.vn/wp-content/uploads/2023/07/soda-viet-quat.jpg', isNetwork: true),
                _buildProductCard('Nước Lọc', 4.2, 'https://katinat.vn/wp-content/uploads/2023/07/nuoc-loc.jpg', isNetwork: true),
              ],
            ),
          ),

          ],
        ),
      ),
    );
  }

      Widget _buildCategoryFF(String name, String imagePath) {
      return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 4),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: AppTheme.textDark,
              ),
            ),
          ],
        ),
      );
    }
}
Widget _buildProductCard(String name, double rating, String imagePath, {bool isNetwork = false}) {
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
            child: isNetwork
                ? Image.network(
                    imagePath,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  )
                : Image.asset(
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


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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