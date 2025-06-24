import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FoodListScreen extends StatelessWidget {
  const FoodListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final foods = [
      {
        'name': 'Salad Bowl',
        'weight': '250g',
        'price': '20',
        'image': 'https://i.imgur.com/1bX5QH6.png',
      },
      {
        'name': 'Chicken Rice',
        'weight': '300g',
        'price': '25',
        'image': 'https://i.imgur.com/2nCt3Sbl.jpg',
      },
      {
        'name': 'Veggie Mix',
        'weight': '200g',
        'price': '18',
        'image': 'https://i.imgur.com/0y8Ftya.jpg',
      },
      {
        'name': 'Fruit Bowl',
        'weight': '150g',
        'price': '15',
        'image': 'https://i.imgur.com/9UgBvQk.jpg',
      },
    ];
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 24, bottom: 0),
        width: 400,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.primaryOrange, width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: AppTheme.primaryOrange, size: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Browse Food',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // Food List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                itemCount: foods.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, i) {
                  final food = foods[i];
                  return _buildFoodCard(
                    name: food['name']!,
                    weight: food['weight']!,
                    price: food['price']!,
                    imageUrl: food['image']!,
                    highlight: i == 0,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodCard({
    required String name,
    required String weight,
    required String price,
    required String imageUrl,
    bool highlight = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(highlight ? 0.10 : 0.04),
            blurRadius: highlight ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: highlight ? Border.all(color: AppTheme.primaryOrange, width: 2) : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            width: 54,
            height: 54,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: highlight ? AppTheme.textDark : AppTheme.textLight,
          ),
        ),
        subtitle: Text(
          weight,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            fontSize: 13,
            color: highlight ? AppTheme.textLight : AppTheme.textLight.withOpacity(0.7),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              price,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: highlight ? AppTheme.textDark : AppTheme.textLight,
              ),
            ),
            const SizedBox(height: 4),
            const Icon(Icons.chevron_right, color: AppTheme.textLight, size: 22),
          ],
        ),
        onTap: () {},
      ),
    );
  }
} 