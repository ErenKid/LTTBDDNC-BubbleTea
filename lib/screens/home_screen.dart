import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'profile_screen.dart';
import 'explore_screen.dart';
import 'cart_screen.dart';

class HomeTabContent extends StatelessWidget {
  const HomeTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryOrange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryOrange.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'location',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.location_on, color: AppTheme.primaryOrange, size: 20),
                    const SizedBox(width: 4),
                    const Expanded(
                      child: Text(
                        'Baner, Pune - 411045',
                        style: TextStyle(
                          color: AppTheme.textDark,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                  _buildCategoryFF('Breakfast', 'https://cdn.pixabay.com/photo/2022/05/07/16/38/poha-7180676__340.jpg'),
                  _buildCategoryFF('Lunch', 'https://cdn.pixabay.com/photo/2012/07/09/07/16/thali-51996__340.jpg'),
                  _buildCategoryFF('Snacks', 'https://cdn.pixabay.com/photo/2018/08/29/19/01/fig-3640553_960_720.jpg'),
                  _buildCategoryFF('Dinner', 'https://cdn.pixabay.com/photo/2017/09/09/12/09/india-2731817__340.jpg'),
                  _buildCategoryFF('Beverages', 'https://cdn.pixabay.com/photo/2017/08/03/21/48/drinks-2578446__340.jpg'),
                  _buildCategoryFF('Grocery', 'https://storage.needpix.com/rsynced_images/grocery-2932906_1280.jpg'),
                  _buildCategoryFF('Fruits', 'https://cdn.pixabay.com/photo/2017/09/26/13/42/apple-2788662__340.jpg'),
                  _buildCategoryFF('Vegetables', 'https://cdn.pixabay.com/photo/2015/05/04/10/16/vegetables-752153_960_720.jpg'),
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
              child: Container(
                width: double.infinity,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.network(
                          'https://cdn-icons-png.flaticon.com/512/3075/3075977.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            'Siêu\nGiảm giá',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppTheme.primaryOrange,
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
                              color: AppTheme.textDark,
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
            // Businesses Near You
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Các doanh nghiệp gần bạn',
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
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('[Tên doanh nghiệp]',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppTheme.textDark,
                        )),
                    const SizedBox(height: 4),
                    const Text('[Mô tả doanh nghiệp]',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: AppTheme.textLight,
                        )),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        Icon(Icons.star, color: AppTheme.primaryOrange, size: 18),
                        SizedBox(width: 4),
                        Text('[Đánh giá]',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: AppTheme.textDark,
                            )),
                        SizedBox(width: 4),
                        Text('Đánh giá',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: AppTheme.textLight,
                            )),
                        SizedBox(width: 16),
                        Icon(Icons.location_on, color: AppTheme.primaryOrange, size: 18),
                        SizedBox(width: 4),
                        Text('[Khoảng cách] Km',
                            style: TextStyle(
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
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFF(String name, String imageUrl) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xB0969696),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imageUrl),
              ),
              shape: BoxShape.circle,
            ),
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