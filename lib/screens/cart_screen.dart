import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lttbddnc/screens/home_screen.dart';
import '../theme/app_theme.dart';
import '../models/cart_model.dart';
import '../models/food_item_model.dart';
import 'package:intl/intl.dart';
import 'payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Thêm danh sách lưu trạng thái tích chọn
  late List<bool> checked;

  @override
  void initState() {
    super.initState();
    checked = List.generate(CartModel.cartItems.value.length, (index) => false);
    CartModel.loadCartForCurrentUser();
    CartModel.cartItems.addListener(_onCartChanged);
    CartModel.cartItems.addListener(_saveCartOnChange);
  }

  @override
  void dispose() {
    CartModel.cartItems.removeListener(_onCartChanged);
    CartModel.cartItems.removeListener(_saveCartOnChange);
    super.dispose();
  }

  void _saveCartOnChange() {
    CartModel.saveCartForCurrentUser();
  }

  void _onCartChanged() {
    setState(() {
      checked = List.generate(CartModel.cartItems.value.length, (index) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,###', 'vi_VN');
    return ValueListenableBuilder<List<FoodItemModel>>(
      valueListenable: CartModel.cartItems,
      builder: (context, cartItems, _) {
        // Đảm bảo checked luôn đồng bộ với cartItems
        if (checked.length != cartItems.length) {
          checked = List.generate(cartItems.length, (index) => false);
        }
        int totalSelectedQuantity = 0;
        int totalSelectedPrice = 0;
        for (int i = 0; i < cartItems.length; i++) {
          if (checked[i]) {
            totalSelectedQuantity += cartItems[i].quantity;
            totalSelectedPrice += cartItems[i].price * cartItems[i].quantity;
          }
        }
        return Scaffold(
          backgroundColor: const Color(0xFFF5F6FA),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: cartItems.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        const Text(
                          'Giỏ hàng',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Center Content
                        const Spacer(),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/empty_cart.png',
                                width: 180,
                                height: 180,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Thêm sản phẩm vào giỏ hàng',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Sản phẩm sẽ xuất hiện ở đây khi bạn thêm sản phẩm!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  color: AppTheme.textLight,
                                ),
                              ),
                              const SizedBox(height: 32),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                                    (Route<dynamic> route) => false,
                                  );
                                },

                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Vào cửa hàng !',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),

                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Giỏ hàng',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              return Card(
                                color: AppTheme.white,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                        value: checked[index],
                                        activeColor: AppTheme.primaryOrange,
                                        onChanged: (val) {
                                          setState(() {
                                            checked[index] = val ?? false;
                                          });
                                        },
                                      ),
                                      (item.imageUrl != null && item.imageUrl!.startsWith('http'))
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.network(item.imageUrl!, width: 56, height: 56, fit: BoxFit.cover),
                                            )
                                        : (item.imageUrl != null && item.imageUrl!.isNotEmpty && (item.imageUrl!.startsWith('/data') || item.imageUrl!.startsWith('/storage')))
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.file(File(item.imageUrl!), width: 56, height: 56, fit: BoxFit.cover),
                                            )
                                        : (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.asset(item.imageUrl!, width: 56, height: 56, fit: BoxFit.cover),
                                            )
                                          : const Icon(Icons.fastfood, size: 40, color: AppTheme.primaryOrange),
                                      const SizedBox(width: 8),
                                      // Phần thông tin sản phẩm co giãn
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.title,
                                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark, fontSize: 16),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.remove_circle_outline, color: AppTheme.primaryOrange),
                                                  onPressed: () {
                                                    final items = List<FoodItemModel>.from(cartItems);
                                                    final checkedCopy = List<bool>.from(checked);
                                                    if (item.quantity > 1) {
                                                      items[index] = item.copyWith(quantity: item.quantity - 1);
                                                    } else {
                                                      items.removeAt(index);
                                                      checkedCopy.removeAt(index);
                                                    }
                                                    setState(() {
                                                      CartModel.cartItems.value = items;
                                                      checked = checkedCopy;
                                                    });
                                                  },
                                                  constraints: const BoxConstraints(),
                                                  padding: EdgeInsets.zero,
                                                ),
                                                Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryOrange, fontSize: 16)),
                                                IconButton(
                                                  icon: const Icon(Icons.add_circle_outline, color: AppTheme.primaryOrange),
                                                  onPressed: () {
                                                    final items = List<FoodItemModel>.from(cartItems);
                                                    setState(() {
                                                      items[index] = item.copyWith(quantity: item.quantity + 1);
                                                      CartModel.cartItems.value = items;
                                                      // checked giữ nguyên
                                                    });
                                                  },
                                                  constraints: const BoxConstraints(),
                                                  padding: EdgeInsets.zero,
                                                ),
                                                // Không còn hiển thị đơn giá ở đây nữa
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      // Phần giá thành tiền và nút xóa
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${currencyFormatter.format(item.price * item.quantity)}đ',
                                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryOrange, fontSize: 16),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, color: AppTheme.errorRed),
                                            onPressed: () {
                                              final items = List<FoodItemModel>.from(cartItems);
                                              items.removeAt(index);
                                              CartModel.cartItems.value = items;
                                            },
                                            constraints: const BoxConstraints(),
                                            padding: EdgeInsets.zero,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Tổng tiền
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tổng tiền:', style: TextStyle(fontSize: 16, color: AppTheme.textDark)),
                                  SizedBox(height: 4),
                                  Text('${currencyFormatter.format(totalSelectedPrice)}đ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryOrange)),
                                ],
                              ),
                              // Nút tiếp tục
                              ElevatedButton(
                                onPressed: totalSelectedQuantity > 0 ? () {
                                  // Lấy danh sách sản phẩm đã chọn
                                  final selectedItems = <FoodItemModel>[];
                                  for (int i = 0; i < cartItems.length; i++) {
                                    if (checked[i]) selectedItems.add(cartItems[i]);
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaymentScreen(
                                        selectedItems: selectedItems,
                                        totalPrice: totalSelectedPrice,
                                      ),
                                    ),
                                  );
                                } : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryOrange,
                                  foregroundColor: AppTheme.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text('Tiếp tục', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
