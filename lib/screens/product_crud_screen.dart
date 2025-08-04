import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../services/database_service.dart';
import '../services/mock_auth_service.dart';
import '../theme/app_theme.dart';

class ProductCrudScreen extends StatefulWidget {
  const ProductCrudScreen({super.key});

  @override
  State<ProductCrudScreen> createState() => _ProductCrudScreenState();
}

class _ProductCrudScreenState extends State<ProductCrudScreen> {
  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];
  CategoryModel? _selectedCategory;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final categories = await DatabaseService().getAllCategories();
      final products = await DatabaseService().getAllProducts();

      setState(() {
        _categories = categories;
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải dữ liệu: $e')),
        );
      }
    }
  }

  Future<void> _filterByCategory(CategoryModel? category) async {
    setState(() {
      _selectedCategory = category;
      _isLoading = true;
    });

    try {
      List<ProductModel> products;
      if (category == null) {
        products = await DatabaseService().getAllProducts();
      } else {
        products = await DatabaseService().getProductsByCategory(category.id);
      }

      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi lọc sản phẩm: $e')),
        );
      }
    }
  }

  Future<void> _showAddEditProductDialog({ProductModel? product, int? index}) async {
    final titleController = TextEditingController(text: product?.title ?? '');
    final descriptionController = TextEditingController(text: product?.description ?? '');
    final quantityController = TextEditingController(text: product?.quantity.toString() ?? '1');
    final priceController = TextEditingController(text: product?.price.toString() ?? '0');
    final pickupInstructionsController = TextEditingController(text: product?.pickupInstructions ?? '');

    CategoryModel? selectedCategory = product != null 
        ? _categories.firstWhere((c) => c.id == product.categoryId, orElse: () => _categories.first)
        : (_categories.isNotEmpty ? _categories.first : null);
    
    String selectedQuantityUnit = product?.quantityUnit ?? 'cái';
    DateTime selectedExpiryDate = product?.expiryDate ?? DateTime.now().add(const Duration(days: 7));
    ProductStatus selectedStatus = product?.status ?? ProductStatus.available;

    final quantityUnits = [
      'cái', 'kg', 'gram', 'lít', 'ml', 'hộp', 'gói', 'chai', 'lon', 'miếng'
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            product == null ? 'Thêm sản phẩm mới' : 'Chỉnh sửa sản phẩm',
            style: const TextStyle(
              fontFamily: 'Montserrat', 
              fontWeight: FontWeight.bold
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tên sản phẩm
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Tên sản phẩm *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.shopping_bag),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Mô tả
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Mô tả',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // Danh mục
                  DropdownButtonFormField<CategoryModel>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Danh mục *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Color(int.parse(category.colorHex.substring(1), radix: 16) + 0xFF000000),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(category.name)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Số lượng và đơn vị
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: quantityController,
                          decoration: const InputDecoration(
                            labelText: 'Số lượng *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.numbers),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: DropdownButtonFormField<String>(
                          value: selectedQuantityUnit,
                          decoration: const InputDecoration(
                            labelText: 'Đơn vị',
                            border: OutlineInputBorder(),
                          ),
                          items: quantityUnits.map((unit) {
                            return DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              selectedQuantityUnit = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Giá
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Giá (VNĐ)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.monetization_on),
                      suffixText: 'VNĐ',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  // Ngày hết hạn
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedExpiryDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null && picked != selectedExpiryDate) {
                        setDialogState(() {
                          selectedExpiryDate = picked;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Ngày hết hạn *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        '${selectedExpiryDate.day}/${selectedExpiryDate.month}/${selectedExpiryDate.year}',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Trạng thái
                  DropdownButtonFormField<ProductStatus>(
                    value: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Trạng thái',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.info),
                    ),
                    items: ProductStatus.values.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status.statusDisplayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedStatus = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Hướng dẫn nhận hàng
                  TextFormField(
                    controller: pickupInstructionsController,
                    decoration: const InputDecoration(
                      labelText: 'Hướng dẫn nhận hàng',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.info_outline),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryOrange,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (titleController.text.trim().isEmpty || selectedCategory == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin bắt buộc')),
                  );
                  return;
                }

                try {
                  final user = context.read<MockAuthService>().currentUser;
                  if (user == null) {
                    throw Exception('Người dùng chưa đăng nhập');
                  }

                  if (product == null) {
                    // Thêm mới
                    final newProduct = ProductModel(
                      id: 'product_${DateTime.now().millisecondsSinceEpoch}',
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      categoryId: selectedCategory!.id,
                      status: selectedStatus,
                      donorId: user.id,
                      donorName: user.name,
                      donorPhotoUrl: user.photoUrl,
                      expiryDate: selectedExpiryDate,
                      createdAt: DateTime.now(),
                      quantity: int.parse(quantityController.text),
                      quantityUnit: selectedQuantityUnit,
                      price: int.parse(priceController.text),
                      pickupInstructions: pickupInstructionsController.text.trim(),
                      address: user.address,
                      latitude: user.latitude,
                      longitude: user.longitude,
                    );
                    await DatabaseService().addProduct(newProduct);
                  } else {
                    // Cập nhật
                    final updatedProduct = product.copyWith(
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      categoryId: selectedCategory!.id,
                      status: selectedStatus,
                      expiryDate: selectedExpiryDate,
                      quantity: int.parse(quantityController.text),
                      quantityUnit: selectedQuantityUnit,
                      price: int.parse(priceController.text),
                      pickupInstructions: pickupInstructionsController.text.trim(),
                    );
                    await DatabaseService().updateProduct(updatedProduct);
                  }

                  if (mounted) {
                    Navigator.pop(context);
                    _loadData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(product == null 
                          ? 'Thêm sản phẩm thành công!' 
                          : 'Cập nhật sản phẩm thành công!'
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi: $e')),
                    );
                  }
                }
              },
              child: Text(product == null ? 'Thêm' : 'Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteProduct(ProductModel product, int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa sản phẩm "${product.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await DatabaseService().deleteProduct(product.id);
        _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Xóa sản phẩm thành công!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi xóa sản phẩm: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Quản lý sản phẩm',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            tooltip: 'Làm mới',
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter
          if (_categories.isNotEmpty)
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length + 1, // +1 for "All" option
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // "All" option
                    return _buildCategoryChip(
                      'Tất cả',
                      '#6C757D',
                      _selectedCategory == null,
                      () => _filterByCategory(null),
                    );
                  }

                  final category = _categories[index - 1];
                  return _buildCategoryChip(
                    category.name,
                    category.colorHex,
                    _selectedCategory?.id == category.id,
                    () => _filterByCategory(category),
                  );
                },
              ),
            ),

          // Products list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _products.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            final product = _products[index];
                            return _buildProductCard(product, index);
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditProductDialog(),
        backgroundColor: AppTheme.primaryOrange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Thêm sản phẩm',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String name, String colorHex, bool isSelected, VoidCallback onTap) {
    final color = Color(int.parse(colorHex.substring(1), radix: 16) + 0xFF000000);
    
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
          ),
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.white,
        selectedColor: color,
        checkmarkColor: Colors.white,
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header với tên và status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.description.isNotEmpty 
                          ? product.description 
                          : 'Không có mô tả',
                        style: TextStyle(
                          fontSize: 14,
                          color: product.description.isNotEmpty 
                            ? AppTheme.textLight 
                            : Colors.grey.shade500,
                          fontFamily: 'Montserrat',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(int.parse(product.status.statusColor.substring(1), radix: 16) + 0xFF000000),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        product.status.statusDisplayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            _showAddEditProductDialog(product: product, index: index);
                            break;
                          case 'delete':
                            _deleteProduct(product, index);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.blue),
                              SizedBox(width: 8),
                              Text('Chỉnh sửa'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Xóa'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Thông tin chi tiết
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildInfoChip(Icons.person, product.donorName, Colors.blue),
                _buildInfoChip(Icons.shopping_basket, '${product.quantity} ${product.quantityUnit}', Colors.green),
                _buildInfoChip(Icons.access_time, 'HSD: ${product.expiryDate.day}/${product.expiryDate.month}/${product.expiryDate.year}', Colors.orange),
                if (product.price > 0)
                  _buildInfoChip(Icons.monetization_on, '${product.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} VNĐ', Colors.red)
                else
                  _buildInfoChip(Icons.volunteer_activism, 'Miễn phí', Colors.purple),
              ],
            ),

            if (product.pickupInstructions?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        product.pickupInstructions!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_basket_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            _selectedCategory == null 
                ? 'Chưa có sản phẩm nào'
                : 'Không có sản phẩm trong danh mục này',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy thêm sản phẩm đầu tiên!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddEditProductDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text(
              'Thêm sản phẩm',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
