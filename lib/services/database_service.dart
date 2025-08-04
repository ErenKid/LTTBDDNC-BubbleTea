
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class DatabaseService {
  // Xóa user khỏi database
  Future<int> deleteUser(String userId) async {
    final dbClient = await db;
    return await dbClient.delete(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }
 // Cập nhật thông tin user
  Future<int> updateUser(UserModel user) async {
    final dbClient = await db;
    return await dbClient.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');
    return await openDatabase(
      path,
      version: 5, // Tăng version để thêm trường imageUrls
      onCreate: (db, version) async {
        // Tạo bảng users
        await db.execute('''
          CREATE TABLE users(
            id TEXT PRIMARY KEY,
            email TEXT UNIQUE,
            name TEXT,
            password TEXT,
            photoUrl TEXT,
            phoneNumber TEXT,
            address TEXT,
            latitude REAL,
            longitude REAL,
            rating INTEGER,
            totalShares INTEGER,
            totalReceives INTEGER,
            createdAt TEXT,
            isVerified INTEGER,
            isAdmin INTEGER DEFAULT 0
          )
        ''');

        // Tạo bảng categories
        await db.execute('''
          CREATE TABLE categories(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT,
            iconName TEXT,
            colorHex TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            isActive INTEGER DEFAULT 1
          )
        ''');

        // Tạo bảng products
        await db.execute('''
          CREATE TABLE products(
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT,
            categoryId TEXT NOT NULL,
            status TEXT DEFAULT 'available',
            donorId TEXT NOT NULL,
            donorName TEXT NOT NULL,
            donorPhotoUrl TEXT,
            imageUrl TEXT,
            imageUrls TEXT DEFAULT '',
            expiryDate TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            latitude REAL,
            longitude REAL,
            address TEXT,
            pickupInstructions TEXT,
            quantity INTEGER DEFAULT 1,
            quantityUnit TEXT DEFAULT 'piece',
            isAllergenFree INTEGER DEFAULT 0,
            allergens TEXT DEFAULT '',
            rating REAL DEFAULT 0.0,
            reviewCount INTEGER DEFAULT 0,
            price INTEGER DEFAULT 0,
            FOREIGN KEY (categoryId) REFERENCES categories (id),
            FOREIGN KEY (donorId) REFERENCES users (id)
          )
        ''');

        // Thêm categories mặc định
        await _insertDefaultCategories(db);
        
        // Thêm products mặc định
        await _insertDefaultProducts(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Tạo bảng categories
          await db.execute('''
            CREATE TABLE categories(
              id TEXT PRIMARY KEY,
              name TEXT NOT NULL,
              description TEXT,
              iconName TEXT,
              colorHex TEXT NOT NULL,
              createdAt TEXT NOT NULL,
              isActive INTEGER DEFAULT 1
            )
          ''');

          // Tạo bảng products
          await db.execute('''
            CREATE TABLE products(
              id TEXT PRIMARY KEY,
              title TEXT NOT NULL,
              description TEXT,
              categoryId TEXT NOT NULL,
              status TEXT DEFAULT 'available',
              donorId TEXT NOT NULL,
              donorName TEXT NOT NULL,
              donorPhotoUrl TEXT,
              imageUrl TEXT,
              imageUrls TEXT DEFAULT '',
              expiryDate TEXT NOT NULL,
              createdAt TEXT NOT NULL,
              latitude REAL,
              longitude REAL,
              address TEXT,
              pickupInstructions TEXT,
              quantity INTEGER DEFAULT 1,
              quantityUnit TEXT DEFAULT 'piece',
              isAllergenFree INTEGER DEFAULT 0,
              allergens TEXT DEFAULT '',
              rating REAL DEFAULT 0.0,
              reviewCount INTEGER DEFAULT 0,
              price INTEGER DEFAULT 0,
              FOREIGN KEY (categoryId) REFERENCES categories (id),
              FOREIGN KEY (donorId) REFERENCES users (id)
            )
          ''');
        }
        
        if (oldVersion < 3) {
          // Clear và thêm lại categories với data mới hơn
          await db.delete('categories');
          await _insertDefaultCategories(db);
          
          // Clear và thêm lại products với data mới hơn
          await db.delete('products');
          await _insertDefaultProducts(db);
        }

        if (oldVersion < 5) {
          // Thêm trường imageUrls vào bảng products
          await db.execute('ALTER TABLE products ADD COLUMN imageUrls TEXT DEFAULT ""');
        }
      },
    );
  }

  // Method để reset database (dùng cho debugging)
  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');
    await deleteDatabase(path);
    _db = null;
  }

  // Thêm categories mặc định
  Future<void> _insertDefaultCategories(Database db) async {
    final defaultCategories = [
      {
        'id': 'cat_001',
        'name': 'Trái cây',
        'description': 'Các loại trái cây tươi',
        'iconName': 'fruits',
        'colorHex': '#FF6B6B',
        'createdAt': DateTime.now().toIso8601String(),
        'isActive': 1,
      },
      {
        'id': 'cat_002',
        'name': 'Rau củ',
        'description': 'Rau xanh và củ quả',
        'iconName': 'vegetables',
        'colorHex': '#4ECDC4',
        'createdAt': DateTime.now().toIso8601String(),
        'isActive': 1,
      },
      {
        'id': 'cat_003',
        'name': 'Đồ uống',
        'description': 'Nước uống các loại',
        'iconName': 'drinks',
        'colorHex': '#45B7D1',
        'createdAt': DateTime.now().toIso8601String(),
        'isActive': 1,
      },
      {
        'id': 'cat_004',
        'name': 'Bánh kẹo',
        'description': 'Bánh ngọt và kẹo',
        'iconName': 'sweets',
        'colorHex': '#F9CA24',
        'createdAt': DateTime.now().toIso8601String(),
        'isActive': 1,
      },
      {
        'id': 'cat_005',
        'name': 'Thực phẩm khô',
        'description': 'Gạo, mì, ngũ cốc',
        'iconName': 'grains',
        'colorHex': '#F0932B',
        'createdAt': DateTime.now().toIso8601String(),
        'isActive': 1,
      },
      {
        'id': 'cat_006',
        'name': 'Đồ ăn nhanh',
        'description': 'Thức ăn nhanh, tiện lợi',
        'iconName': 'fastfood',
        'colorHex': '#E74C3C',
        'createdAt': DateTime.now().toIso8601String(),
        'isActive': 1,
      },
      {
        'id': 'cat_007',
        'name': 'Đồ ăn chay',
        'description': 'Thức ăn chay, healthy',
        'iconName': 'vegetarian',
        'colorHex': '#27AE60',
        'createdAt': DateTime.now().toIso8601String(),
        'isActive': 1,
      },
      {
        'id': 'cat_008',
        'name': 'Khác',
        'description': 'Các loại thực phẩm khác',
        'iconName': 'other',
        'colorHex': '#95A5A6',
        'createdAt': DateTime.now().toIso8601String(),
        'isActive': 1,
      },
    ];

    for (final category in defaultCategories) {
      await db.insert('categories', category);
    }
  }

  // Thêm products mặc định
  Future<void> _insertDefaultProducts(Database db) async {
    final defaultProducts = [
      {
        'id': 'prod_001',
        'title': 'Trà Sữa Oolong Hạt Sen',
        'description': 'Trà sữa thơm ngon với hạt sen tươi',
        'categoryId': 'cat_001', // Trái cây
        'status': 'available',
        'donorId': 'admin',
        'donorName': 'Admin',
        'donorPhotoUrl': '',
        'imageUrl': 'https://product.hstatic.net/200000399631/product/oolong_hat_sen_9d503ae63b534f8fabc58ce733a80360_1024x1024.jpg',
        'expiryDate': DateTime.now().add(Duration(days: 30)).toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
        'latitude': 10.762622,
        'longitude': 106.660172,
        'address': 'TP. Hồ Chí Minh',
        'pickupInstructions': 'Liên hệ trước khi đến',
        'quantity': 10,
        'quantityUnit': 'ly',
        'isAllergenFree': 0,
        'allergens': 'sữa',
        'rating': 4.7,
        'reviewCount': 128,
        'price': 58000,
      },
      {
        'id': 'prod_002',
        'title': 'Trà Lài Sữa Chân Châu',
        'description': 'Trà lài thơm với chân châu dai ngon',
        'categoryId': 'cat_002', // Rau củ
        'status': 'available',
        'donorId': 'admin',
        'donorName': 'Admin',
        'donorPhotoUrl': '',
        'imageUrl': 'https://product.hstatic.net/200000399631/product/tra_lai_sua_tran_chau_cd661d498a9547c6b110ac5ebd67feda_1024x1024.jpg',
        'expiryDate': DateTime.now().add(Duration(days: 30)).toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
        'latitude': 10.762622,
        'longitude': 106.660172,
        'address': 'TP. Hồ Chí Minh',
        'pickupInstructions': 'Liên hệ trước khi đến',
        'quantity': 15,
        'quantityUnit': 'ly',
        'isAllergenFree': 0,
        'allergens': 'sữa',
        'rating': 4.5,
        'reviewCount': 95,
        'price': 40000,
      },
      {
        'id': 'prod_003',
        'title': 'Cà Phê Đen Đá',
        'description': 'Cà phê đen nguyên chất, đậm đà',
        'categoryId': 'cat_003', // Thịt, cá
        'status': 'available',
        'donorId': 'admin',
        'donorName': 'Admin',
        'donorPhotoUrl': '',
        'imageUrl': 'https://product.hstatic.net/200000399631/product/cafe_den_da_93a2be4731c94c84b28dee1600e4ff1f_1024x1024.jpg',
        'expiryDate': DateTime.now().add(Duration(days: 60)).toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
        'latitude': 10.762622,
        'longitude': 106.660172,
        'address': 'TP. Hồ Chí Minh',
        'pickupInstructions': 'Có thể lấy ngay',
        'quantity': 20,
        'quantityUnit': 'ly',
        'isAllergenFree': 1,
        'allergens': '',
        'rating': 4.9,
        'reviewCount': 234,
        'price': 45000,
      },
      {
        'id': 'prod_004',
        'title': 'Bánh Mì Bơ Tỏi',
        'description': 'Bánh mì giòn với bơ tỏi thơm ngon',
        'categoryId': 'cat_004', // Bánh kẹo
        'status': 'available',
        'donorId': 'admin',
        'donorName': 'Admin',
        'donorPhotoUrl': '',
        'imageUrl': 'https://product.hstatic.net/200000399631/product/banh_mi_bo_toi_695e5600e21a4f01ba120de3e3510ec9_1024x1024.jpg',
        'expiryDate': DateTime.now().add(Duration(days: 3)).toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
        'latitude': 10.762622,
        'longitude': 106.660172,
        'address': 'TP. Hồ Chí Minh',
        'pickupInstructions': 'Nên lấy trong ngày',
        'quantity': 5,
        'quantityUnit': 'ổ',
        'isAllergenFree': 0,
        'allergens': 'gluten, sữa',
        'rating': 4.4,
        'reviewCount': 67,
        'price': 40000,
      },
    ];

    for (final product in defaultProducts) {
      await db.insert('products', product);
    }
  }

  Future<int> registerUser(UserModel user) async {
    final dbClient = await db;
    try {
      return await dbClient.insert('users', {
        ...user.toMap(),
        'createdAt': user.createdAt.toIso8601String(),
        'isVerified': user.isVerified ? 1 : 0,
        'isAdmin': user.isAdmin ? 1 : 0,
      });
    } catch (e) {
      // Nếu email đã tồn tại sẽ throw
      return -1;
    }
  }

  Future<UserModel?> loginUser(String email, String password) async {
    final dbClient = await db;
    final res = await dbClient.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (res.isNotEmpty) {
      final map = res.first;
      return UserModel(
        id: map['id'] as String,
        email: map['email'] as String,
        name: map['name'] as String,
        password: map['password'] as String,
        photoUrl: map['photoUrl'] as String?,
        phoneNumber: map['phoneNumber'] as String?,
        address: map['address'] as String?,
        latitude: map['latitude'] != null ? (map['latitude'] as num).toDouble() : null,
        longitude: map['longitude'] != null ? (map['longitude'] as num).toDouble() : null,
        rating: map['rating'] != null ? (map['rating'] as num).toInt() : 0,
        totalShares: map['totalShares'] != null ? (map['totalShares'] as num).toInt() : 0,
        totalReceives: map['totalReceives'] != null ? (map['totalReceives'] as num).toInt() : 0,
        createdAt: DateTime.parse(map['createdAt'] as String),
        isVerified: map['isVerified'] == 1,
        isAdmin: map['isAdmin'] == 1,
      );
    }
    return null;
  }

  Future<void> createAdminUser() async {
    final adminUser = UserModel(
      id: 'admin_001',
      email: 'admin@gmail.com',
      name: 'Admin',
      password: 'admin123',
      createdAt: DateTime.now(),
      isVerified: true,
      isAdmin: true,
    );

    try {
      await registerUser(adminUser);
      print('Admin user created successfully');
    } catch (e) {
      print('Admin user might already exist: $e');
    }
  }

  Future<bool> isAdminUser(String email) async {
    final dbClient = await db;
    final res = await dbClient.query(
      'users',
      where: 'email = ? AND isAdmin = ?',
      whereArgs: [email, 1],
    );
    return res.isNotEmpty;
  }

  Future<List<UserModel>> getAllUsers() async {
    final dbClient = await db;
    final res = await dbClient.query('users');
    return res.map((map) => UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      password: map['password'] as String,
      photoUrl: map['photoUrl'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      address: map['address'] as String?,
      latitude: map['latitude'] != null ? (map['latitude'] as num).toDouble() : null,
      longitude: map['longitude'] != null ? (map['longitude'] as num).toDouble() : null,
      rating: map['rating'] != null ? (map['rating'] as num).toInt() : 0,
      totalShares: map['totalShares'] != null ? (map['totalShares'] as num).toInt() : 0,
      totalReceives: map['totalReceives'] != null ? (map['totalReceives'] as num).toInt() : 0,
      createdAt: DateTime.parse(map['createdAt'] as String),
      isVerified: map['isVerified'] == 1,
      isAdmin: map['isAdmin'] == 1,
    )).toList();
  }

  // ============ CATEGORY METHODS ============
  
  // Lấy tất cả categories
  Future<List<CategoryModel>> getAllCategories() async {
    final dbClient = await db;
    final res = await dbClient.query(
      'categories',
      where: 'isActive = ?',
      whereArgs: [1],
      orderBy: 'name ASC',
    );
    return res.map((map) => CategoryModel.fromMap(map)).toList();
  }

  // Thêm category mới
  Future<int> addCategory(CategoryModel category) async {
    final dbClient = await db;
    return await dbClient.insert('categories', category.toMap());
  }

  // Cập nhật category
  Future<int> updateCategory(CategoryModel category) async {
    final dbClient = await db;
    return await dbClient.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  // Xóa category (soft delete)
  Future<int> deleteCategory(String categoryId) async {
    final dbClient = await db;
    return await dbClient.update(
      'categories',
      {'isActive': 0},
      where: 'id = ?',
      whereArgs: [categoryId],
    );
  }

  // ============ PRODUCT METHODS ============
  
  // Lấy tất cả products
  Future<List<ProductModel>> getAllProducts() async {
    final dbClient = await db;
    final res = await dbClient.query(
      'products',
      orderBy: 'createdAt DESC',
    );
    return res.map((map) => ProductModel.fromMap(map)).toList();
  }

  // Lấy products theo category
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    final dbClient = await db;
    final res = await dbClient.query(
      'products',
      where: 'categoryId = ?',
      whereArgs: [categoryId],
      orderBy: 'createdAt DESC',
    );
    return res.map((map) => ProductModel.fromMap(map)).toList();
  }

  // Lấy products theo user (donor)
  Future<List<ProductModel>> getProductsByUser(String userId) async {
    final dbClient = await db;
    final res = await dbClient.query(
      'products',
      where: 'donorId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );
    return res.map((map) => ProductModel.fromMap(map)).toList();
  }

  // Thêm product mới
  Future<int> addProduct(ProductModel product) async {
    print('DEBUG - Adding product: ${product.title}');
    final dbClient = await db;
    final result = await dbClient.insert('products', product.toMap());
    print('DEBUG - Product added successfully with result: $result');
    return result;
  }

  // Cập nhật product
  Future<int> updateProduct(ProductModel product) async {
    final dbClient = await db;
    return await dbClient.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Xóa product
  Future<int> deleteProduct(String productId) async {
    final dbClient = await db;
    return await dbClient.delete(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  // Tìm kiếm products
  Future<List<ProductModel>> searchProducts(String query) async {
    final dbClient = await db;
    final res = await dbClient.query(
      'products',
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'createdAt DESC',
    );
    return res.map((map) => ProductModel.fromMap(map)).toList();
  }

  // Lấy product theo ID
  Future<ProductModel?> getProductById(String productId) async {
    final dbClient = await db;
    final res = await dbClient.query(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
    );
    if (res.isNotEmpty) {
      return ProductModel.fromMap(res.first);
    }
    return null;
  }

  // Lấy category theo ID
  Future<CategoryModel?> getCategoryById(String categoryId) async {
    final dbClient = await db;
    final res = await dbClient.query(
      'categories',
      where: 'id = ?',
      whereArgs: [categoryId],
    );
    if (res.isNotEmpty) {
      return CategoryModel.fromMap(res.first);
    }
    return null;
  }
} 