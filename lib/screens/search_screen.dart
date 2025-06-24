import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text('Search', style: TextStyle(fontFamily: 'Montserrat', color: AppTheme.textDark, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppTheme.primaryOrange),
      ),
      body: const Center(
        child: Icon(Icons.search, color: AppTheme.primaryOrange, size: 80),
      ),
    );
  }
} 