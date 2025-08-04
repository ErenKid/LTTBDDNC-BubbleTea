import 'package:flutter/material.dart';
import '../models/food_item_model.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:lttbddnc/screens/home_screen.dart';

class PaymentScreen extends StatefulWidget {
  final List<FoodItemModel> selectedItems;
  final int totalPrice;
  const PaymentScreen({super.key, required this.selectedItems, required this.totalPrice});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedPayment = 0;
  final List<String> paymentMethods = [
    'Ví ZaloPay',
    'Ví MoMo',
    'Thẻ ATM/Ngân hàng',
    'Visa/Master/JCB',
  ];
  final TextEditingController _promoController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  int discount = 0;
  String promoMessage = '';

  // Gợi ý món khác (mock data)
  List<FoodItemModel> getSuggestions() {
    final selectedTitles = widget.selectedItems.map((e) => e.title).toSet();
    final List<Map<String, dynamic>> allProducts = HomeScreen.allProducts;
    return allProducts
        .where((p) => !selectedTitles.contains(p['name']))
        .map((p) => FoodItemModel(
              id: p['name'],
              title: p['name'],
              description: '',
              category: FoodCategory.other,
              status: FoodStatus.available,
              donorId: '',
              donorName: '',
              expiryDate: DateTime.now(),
              createdAt: DateTime.now(),
              quantity: 1,
              quantityUnit: 'ly',
              isAllergenFree: false,
              allergens: [],
              rating: p['rating']?.toDouble() ?? 0.0,
              reviewCount: 0,
              price: p['price'] ?? 0,
              imageUrl: p['image'],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,###', 'vi_VN');
    int finalTotal = widget.totalPrice - discount;
    if (finalTotal < 0) finalTotal = 0;
    final suggestions = getSuggestions();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận đơn hàng', style: TextStyle(color: AppTheme.textDark)),
        backgroundColor: AppTheme.white,
        iconTheme: const IconThemeData(color: AppTheme.textDark),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                // Thông tin giao hàng
                const Text('Thông tin giao hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textDark)),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Họ và tên',
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: AppTheme.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: AppTheme.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _addressController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Địa chỉ giao hàng',
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: AppTheme.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                // Sản phẩm đã chọn
                const Text('Sản phẩm đã chọn', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.textDark)),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.selectedItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.selectedItems[index];
                    return Card(
                      color: AppTheme.white,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: item.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(item.imageUrl!, width: 48, height: 48, fit: BoxFit.cover),
                              )
                            : const Icon(Icons.fastfood, size: 32, color: AppTheme.primaryOrange),
                        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                        subtitle: Text('Số lượng: ${item.quantity}'),
                        trailing: Text('${currencyFormatter.format(item.price * item.quantity)}đ', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryOrange)),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Mã khuyến mãi
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _promoController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Nhập mã khuyến mãi',
                          hintStyle: const TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: AppTheme.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_promoController.text.trim().toUpperCase() == 'GIAM30K') {
                            discount = 30000;
                            promoMessage = 'Áp dụng thành công mã GIAM30K (-30.000đ)';
                          } else if (_promoController.text.trim().toUpperCase() == 'FREESHIP') {
                            discount = 15000;
                            promoMessage = 'Áp dụng thành công mã FREESHIP (-15.000đ)';
                          } else {
                            discount = 0;
                            promoMessage = 'Mã không hợp lệ hoặc hết hạn.';
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryOrange,
                        foregroundColor: AppTheme.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Áp dụng'),
                    ),
                  ],
                ),
                if (promoMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: Text(promoMessage, style: TextStyle(color: discount > 0 ? Colors.green : Colors.red)),
                  ),
                const SizedBox(height: 16),
                // Phương thức thanh toán
                const Text('Phương thức thanh toán', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textDark)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(paymentMethods.length, (i) {
                    final isSelected = _selectedPayment == i;
                    final icons = [
                      Icons.account_balance_wallet, // ZaloPay
                      Icons.account_balance_wallet_outlined, // MoMo
                      Icons.credit_card, // ATM
                      Icons.payment, // Visa/Master/JCB
                    ];
                    final colors = [
                      Color(0xFF00B4D8), // ZaloPay xanh
                      Color(0xFFAE1F63), // MoMo hồng
                      Color(0xFF1976D2), // ATM xanh
                      Color(0xFFF9A825), // Visa vàng
                    ];
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedPayment = i),
                        child: Card(
                          color: isSelected ? colors[i].withOpacity(0.08) : AppTheme.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(
                              color: isSelected ? colors[i] : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          elevation: isSelected ? 4 : 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(icons[i], color: colors[i], size: 28),
                                const SizedBox(height: 6),
                                Text(paymentMethods[i],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppTheme.textDark,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle, color: Colors.green, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                // Gợi ý cho bạn
                const Text('Gợi ý cho bạn', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textDark)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: suggestions.length,
                    separatorBuilder: (context, i) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final s = suggestions[i];
                      return Container(
                        width: 120,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 2))],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(s.imageUrl ?? '', width: 60, height: 60, fit: BoxFit.cover),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              height: 32,
                              child: Center(
                                child: Text(
                                  s.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Text('${currencyFormatter.format(s.price)}đ', style: const TextStyle(color: AppTheme.primaryOrange, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Tổng số sản phẩm và tổng tiền (ngay trên nút đặt hàng)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${widget.selectedItems.length} sản phẩm', style: const TextStyle(fontSize: 16, color: AppTheme.textDark)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (discount > 0)
                          Text('${currencyFormatter.format(widget.totalPrice)}đ', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                        Text('${currencyFormatter.format(finalTotal)}đ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryOrange)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Nút đặt hàng
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Xử lý đặt hàng
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đặt hàng thành công!')));
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryOrange,
                      foregroundColor: AppTheme.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Đặt hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 24),
              ]
            )
          )
      );
  }
} 