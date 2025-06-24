import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.shopping_cart, color: AppTheme.primaryOrange, size: 80),
    );
  }
} 