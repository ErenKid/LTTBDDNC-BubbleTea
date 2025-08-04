import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
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
    print('DEBUG - _loadData called');
    setState(() {
      _isLoading = true;
    });

    try {
      print('DEBUG - Loading categories...');
      final categories = await DatabaseService().getAllCategories();
      print('DEBUG - Loaded ${categories.length} categories');
      
      print('DEBUG - Loading products...');
      final products = await DatabaseService().getAllProducts();
      print('DEBUG - Loaded ${products.length} products');

      setState(() {
        _categories = categories;
        _products = products;
        _isLoading = false;
      });
      
      print('DEBUG - Data loaded successfully');
    } catch (e) {
      print('DEBUG - Error loading data: $e');
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

  // Navigasi ke AddProductScreen thay vì dialog
  void _navigateToAddProduct([ProductModel? product]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductScreen(
          product: product,
          categories: _categories,
        ),
      ),
    ).then((_) => _loadData()); // Refresh sau khi quay lại
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
        onPressed: () => _navigateToAddProduct(),
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
                // Status và menu
                Wrap(
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.center,
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
                            _navigateToAddProduct(product);
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
                            mainAxisSize: MainAxisSize.min,
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
                            mainAxisSize: MainAxisSize.min,
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
            onPressed: () => _navigateToAddProduct(),
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

// ============= ADD PRODUCT SCREEN (SIMPLIFIED) =============
class AddProductScreen extends StatefulWidget {
  final ProductModel? product;
  final List<CategoryModel> categories;

  const AddProductScreen({
    super.key,
    this.product,
    required this.categories,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _stockController;
  late final TextEditingController _priceController;

  CategoryModel? _selectedCategory;
  File? _selectedImage; // Biến để lưu ảnh chính đã chọn
  List<File> _selectedImages = []; // Danh sách nhiều ảnh đã chọn
  String? _existingImageUrl; // Ảnh cũ từ URL (nếu có)
  List<String> _existingImageUrls = []; // Danh sách ảnh cũ từ URL
  final ImagePicker _imagePicker = ImagePicker(); // ImagePicker

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers
    _titleController = TextEditingController(text: widget.product?.title ?? '');
    _descriptionController = TextEditingController(text: widget.product?.description ?? '');
    _stockController = TextEditingController(text: widget.product?.quantity.toString() ?? '1');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '0');

    // Initialize existing image URL if editing
    _existingImageUrl = widget.product?.imageUrl;
    _existingImageUrls = widget.product?.imageUrls ?? [];

    // Initialize category
    if (widget.product != null) {
      _selectedCategory = widget.categories.firstWhere(
        (c) => c.id == widget.product!.categoryId,
        orElse: () => widget.categories.first,
      );
    } else {
      _selectedCategory = widget.categories.isNotEmpty ? widget.categories.first : null;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Method để chọn ảnh từ thư viện
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _existingImageUrl = null; // Xóa ảnh cũ khi chọn ảnh mới
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi chọn ảnh: $e')),
      );
    }
  }

  // Method để chụp ảnh mới
  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _existingImageUrl = null; // Xóa ảnh cũ khi chọn ảnh mới
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi chụp ảnh: $e')),
      );
    }
  }

  // Method để thêm ảnh vào danh sách
  Future<void> _addImageToList() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (image != null) {
        setState(() {
          // Thêm ảnh mới vào danh sách
          _selectedImages.add(File(image.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi chọn ảnh: $e')),
      );
    }
  }

  // Method để xóa ảnh khỏi danh sách
  void _removeImage(int index, {bool isExisting = false}) {
    setState(() {
      if (isExisting) {
        _existingImageUrls.removeAt(index);
      } else {
        _selectedImages.removeAt(index);
      }
    });
  }

  // Method để hiển thị dialog chọn nguồn ảnh
  Future<void> _showImageSourceDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Chọn nguồn ảnh',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: const Text(
                'Thư viện ảnh',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.green),
              title: const Text(
                'Chụp ảnh mới',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
            if (_selectedImage != null || _existingImageUrl != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Xóa ảnh',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedImage = null;
                    _existingImageUrl = null; // Xóa luôn ảnh cũ
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn danh mục')),
      );
      return;
    }

    try {
      final user = context.read<MockAuthService>().currentUser;
      if (user == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }

      if (widget.product == null) {
        // Thêm mới - ID tự động tạo
        final newProduct = ProductModel(
          id: 'product_${DateTime.now().millisecondsSinceEpoch}', // ID tự động
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          categoryId: _selectedCategory!.id,
          status: ProductStatus.available, // Mặc định available
          donorId: user.id,
          donorName: user.name,
          donorPhotoUrl: user.photoUrl,
          imageUrl: _selectedImage?.path, // Sử dụng đường dẫn file local
          imageUrls: _selectedImages.map((file) => file.path).toList(), // Danh sách ảnh bổ sung
          expiryDate: DateTime.now().add(const Duration(days: 30)), // Mặc định 30 ngày
          createdAt: DateTime.now(),
          quantity: int.parse(_stockController.text),
          quantityUnit: 'cái', // Mặc định 'cái'
          price: int.parse(_priceController.text),
          pickupInstructions: '', // Mặc định trống
          address: user.address ?? '',
          latitude: user.latitude ?? 0.0,
          longitude: user.longitude ?? 0.0,
        );
        
        // Sử dụng ProductProvider để thêm product
        await Provider.of<ProductProvider>(context, listen: false).addProduct(newProduct);
      } else {
        // Cập nhật
        final updatedProduct = widget.product!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          categoryId: _selectedCategory!.id,
          quantity: int.parse(_stockController.text),
          price: int.parse(_priceController.text),
          imageUrl: _selectedImage?.path ?? widget.product!.imageUrl, // Giữ ảnh cũ nếu không chọn ảnh mới
          imageUrls: _selectedImages.isNotEmpty 
              ? [..._existingImageUrls, ..._selectedImages.map((file) => file.path)]
              : _existingImageUrls,
        );
        
        // Sử dụng ProductProvider để cập nhật product
        await Provider.of<ProductProvider>(context, listen: false).updateProduct(updatedProduct);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.product == null 
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          widget.product == null ? 'Thêm sản phẩm mới' : 'Chỉnh sửa sản phẩm',
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tên sản phẩm
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _titleController,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Tên sản phẩm *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.shopping_bag),
                    ),
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Vui lòng nhập tên sản phẩm';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Mô tả
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _descriptionController,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Mô tả',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Danh mục
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DropdownButtonFormField<CategoryModel>(
                    value: _selectedCategory,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Danh mục *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: widget.categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                            Text(category.name),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Vui lòng chọn danh mục';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Hình ảnh sản phẩm
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Hình ảnh sản phẩm',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: AppTheme.textDark,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _showImageSourceDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryOrange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(Icons.add_a_photo, size: 18),
                            label: const Text(
                              'Chọn ảnh',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Preview ảnh chính đã chọn
                      if (_selectedImage != null || _existingImageUrl != null) ...[
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _selectedImage != null 
                              ? Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                )
                              : (_existingImageUrl != null
                                  ? Image.network(
                                      _existingImageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey.shade100,
                                          child: const Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.error_outline, color: Colors.red, size: 40),
                                              SizedBox(height: 8),
                                              Text(
                                                'Không thể tải ảnh', 
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontFamily: 'Montserrat',
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Container(
                                          color: Colors.grey.shade100,
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      },
                                    )
                                  : const SizedBox()),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Section ảnh bổ sung
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ảnh bổ sung (${_selectedImages.length + _existingImageUrls.length})',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _addImageToList,
                            icon: const Icon(Icons.add_photo_alternate, size: 20),
                            label: const Text('Thêm ảnh'),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF007E4F),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Grid hiển thị ảnh bổ sung
                      if (_selectedImages.isNotEmpty || _existingImageUrls.isNotEmpty) ...[
                        SizedBox(
                          height: 120,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              // Hiển thị ảnh cũ
                              ..._existingImageUrls.asMap().entries.map((entry) {
                                int index = entry.key;
                                String imageUrl = entry.value;
                                return Container(
                                  width: 100,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          imageUrl,
                                          width: 100,
                                          height: 120,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey.shade200,
                                              child: const Icon(Icons.error, color: Colors.red),
                                            );
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () => _removeImage(index, isExisting: true),
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              
                              // Hiển thị ảnh mới
                              ..._selectedImages.asMap().entries.map((entry) {
                                int index = entry.key;
                                File imageFile = entry.value;
                                return Container(
                                  width: 100,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          imageFile,
                                          width: 100,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () => _removeImage(index, isExisting: false),
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ] else ...[
                        Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Chưa có ảnh bổ sung nào',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Giá
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _priceController,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Giá (VNĐ) *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.monetization_on),
                      suffixText: 'VNĐ',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Vui lòng nhập giá';
                      }
                      if (int.tryParse(value!) == null || int.parse(value) < 0) {
                        return 'Giá phải là số không âm';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Stock (Số lượng tồn kho)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _stockController,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Số lượng tồn kho *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.inventory),
                      suffixText: 'cái',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Vui lòng nhập số lượng';
                      }
                      if (int.tryParse(value!) == null || int.parse(value) <= 0) {
                        return 'Số lượng phải là số nguyên dương';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save button
              ElevatedButton(
                onPressed: _saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  widget.product == null ? 'Thêm sản phẩm' : 'Cập nhật sản phẩm',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
