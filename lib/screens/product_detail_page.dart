import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../models/cart_model.dart';
import '../models/food_item_model.dart';

class ProductDetailPage extends StatefulWidget {
  final String name;
  final String imageUrl;
  final List<String> imageUrls; // Danh sách nhiều ảnh
  final double rating;
  final int price;

  const ProductDetailPage({
    super.key,
    required this.name,
    required this.imageUrl,
    this.imageUrls = const [], // Mặc định là danh sách rỗng
    required this.rating,
    required this.price,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;
  String selectedSize = 'S';
  String selectedIce = 'direct';
  int currentImageIndex = 0; // Index của ảnh hiện tại
  PageController pageController = PageController(); // Controller cho PageView

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  int getSizePrice() {
    switch (selectedSize) {
      case 'S':
        return widget.price;
      case 'M':
        return widget.price + 5000;
      case 'L':
        return widget.price + 10000;
      case 'XL':
        return widget.price + 15000;
      default:
        return widget.price;
    }
  }

  final Color phucLongGreen = const Color(0xFF007E4F);
  final Color backgroundColor = const Color(0xFFF5F5F5);
  final Color textColor = const Color(0xFF1B1B1B);

  // Hàm helper để hiển thị ảnh sản phẩm (hỗ trợ nhiều ảnh)
  Widget _buildProductImage() {
    // Tạo danh sách tất cả ảnh (bao gồm imageUrl chính và imageUrls)
    List<String> allImages = [];
    if (widget.imageUrl.isNotEmpty) {
      allImages.add(widget.imageUrl);
    }
    allImages.addAll(widget.imageUrls);

    // Nếu không có ảnh nào
    if (allImages.isEmpty) {
      return Container(
        height: 280,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, 
                 color: Colors.grey.shade400, size: 80),
            const SizedBox(height: 8),
            Text('Không có ảnh', 
                 style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // PageView hiển thị ảnh
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                currentImageIndex = index;
              });
            },
            itemCount: allImages.length,
            itemBuilder: (context, index) {
              return _buildSingleImage(allImages[index]);
            },
          ),
        ),
        
        // Indicator hiển thị vị trí ảnh hiện tại (chỉ hiển thị khi có > 1 ảnh)
        if (allImages.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                allImages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentImageIndex == index 
                        ? phucLongGreen 
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
          
        // Số thứ tự ảnh (1/3, 2/3, ...)
        if (allImages.length > 1)
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${currentImageIndex + 1}/${allImages.length}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }

  // Hàm helper để hiển thị một ảnh đơn
  Widget _buildSingleImage(String imageUrl) {
    // Kiểm tra xem đây có phải là đường dẫn file local không
    final bool isLocalFile = imageUrl.isNotEmpty && 
                            !imageUrl.startsWith('http') && 
                            !imageUrl.startsWith('assets/');

    Widget imageWidget;
    
    if (isLocalFile) {
      // Ảnh từ file local
      imageWidget = Image.file(
        File(imageUrl),
        height: 280,
        width: double.infinity,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorImage();
        },
      );
    } else if (imageUrl.startsWith('http')) {
      // Ảnh từ network
      imageWidget = Image.network(
        imageUrl,
        height: 280,
        width: double.infinity,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorImage();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 280,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / 
                      loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      );
    } else {
      // Ảnh từ assets
      imageWidget = Image.asset(
        imageUrl,
        height: 280,
        width: double.infinity,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorImage();
        },
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: imageWidget,
    );
  }

  // Hàm helper để hiển thị error image
  Widget _buildErrorImage() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, 
               color: Colors.grey.shade400, size: 80),
          const SizedBox(height: 8),
          Text('Không thể tải ảnh', 
               style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int basePrice = getSizePrice();
    int totalPrice = basePrice * quantity;
    final currencyFormatter = NumberFormat('#,##0', 'vi_VN');

    return Scaffold(
      backgroundColor: backgroundColor,

      // ✅ Giữ lại phần thêm vào giỏ hàng
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              final item = FoodItemModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: widget.name,
                description: '',
                category: FoodCategory.other, // Hoặc xác định đúng category nếu có
                status: FoodStatus.available,
                donorId: '',
                donorName: '',
                donorPhotoUrl: null,
                imageUrl: widget.imageUrl,
                expiryDate: DateTime.now().add(const Duration(days: 7)),
                createdAt: DateTime.now(),
                latitude: null,
                longitude: null,
                address: null,
                pickupInstructions: null,
                quantity: quantity,
                quantityUnit: 'ly',
                isAllergenFree: false,
                allergens: const [],
                rating: widget.rating,
                reviewCount: 0,
                price: basePrice,
              );
              // Clone list để cập nhật ValueNotifier
              final items = List<FoodItemModel>.from(CartModel.cartItems.value);
              final index = items.indexWhere((e) => e.title == item.title && e.imageUrl == item.imageUrl);
              if (index != -1) {
                final old = items[index];
                items[index] = old.copyWith(quantity: old.quantity + quantity);
              } else {
                items.add(item);
              }
              CartModel.cartItems.value = items;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã thêm vào giỏ hàng')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: phucLongGreen,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Thêm vào giỏ hàng',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 56),
              _buildProductImage(),
              const SizedBox(height: 16),
              _buildWhiteBox(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.name} ($selectedSize)',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: phucLongGreen),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Giá: ${currencyFormatter.format(basePrice)} Đồng',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textColor),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(widget.rating.toString(), style: TextStyle(fontSize: 16, color: textColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Thêm mô tả nếu muốn
                  ],
                ),
              ),

              _buildRadioSection('Chọn Size', {
                'S': 'Size S',
                'M': 'Size M',
                'L': 'Size L',
                'XL': 'Size XL',
              }, selectedSize, (val) => setState(() => selectedSize = val)),

              _buildRadioSection('Chọn mức đá', {
                'direct': 'Lấy đá trực tiếp',
                'separate': 'Lấy đá riêng',
                'none': 'Không lấy đá',
              }, selectedIce, (val) => setState(() => selectedIce = val)),

              // ✅ Khung số lượng
              _buildWhiteBox(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Số lượng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: phucLongGreen)),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            if (quantity > 1) setState(() => quantity--);
                          },
                        ),
                        Text('$quantity', style: TextStyle(fontSize: 18, color: textColor)),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () => setState(() => quantity++),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ✅ Khung tổng giá
              _buildWhiteBox(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tổng giá', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: phucLongGreen)),
                    Text('${currencyFormatter.format(totalPrice)} Đồng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                  ],
                ),
              ),

              const SizedBox(height: 160), // Chừa chỗ cho bottomSheet
            ],
          ),

          // Nút quay lại
          Positioned(
            top: 24,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioSection(
    String title,
    Map<String, String> options,
    String selectedValue,
    Function(String) onChanged,
  ) {
    return _buildWhiteBox(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: phucLongGreen)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: options.entries.map((entry) {
              return ChoiceChip(
                label: Text(entry.value),
                selected: selectedValue == entry.key,
                selectedColor: phucLongGreen,
                labelStyle: TextStyle(
                  color: selectedValue == entry.key ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                backgroundColor: Colors.grey[200],
                onSelected: (_) => onChanged(entry.key),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteBox(Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: child,
    );
  }
}
