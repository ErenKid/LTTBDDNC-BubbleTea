

enum ProductStatus {
  available,
  reserved,
  claimed,
  expired,
}

extension ProductStatusExtension on ProductStatus {
  String get statusDisplayName {
    switch (this) {
      case ProductStatus.available:
        return 'Có sẵn';
      case ProductStatus.reserved:
        return 'Đã đặt trước';
      case ProductStatus.claimed:
        return 'Đã nhận';
      case ProductStatus.expired:
        return 'Hết hạn';
    }
  }

  String get statusColor {
    switch (this) {
      case ProductStatus.available:
        return '#4CAF50'; // Green
      case ProductStatus.reserved:
        return '#FF9800'; // Orange
      case ProductStatus.claimed:
        return '#2196F3'; // Blue
      case ProductStatus.expired:
        return '#F44336'; // Red
    }
  }
}

class ProductModel {
  final String id;
  final String title;
  final String description;
  final String categoryId; // Reference đến CategoryModel
  final ProductStatus status;
  final String donorId;
  final String donorName;
  final String? donorPhotoUrl;
  final String? imageUrl;
  final List<String> imageUrls; // Danh sách nhiều ảnh
  final DateTime expiryDate;
  final DateTime createdAt;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? pickupInstructions;
  final int quantity;
  final String quantityUnit;
  final bool isAllergenFree;
  final List<String> allergens;
  final double rating;
  final int reviewCount;
  final int price;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.status,
    required this.donorId,
    required this.donorName,
    this.donorPhotoUrl,
    this.imageUrl,
    this.imageUrls = const [], // Mặc định là danh sách rỗng
    required this.expiryDate,
    required this.createdAt,
    this.latitude,
    this.longitude,
    this.address,
    this.pickupInstructions,
    required this.quantity,
    required this.quantityUnit,
    this.isAllergenFree = false,
    this.allergens = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.price = 0,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      categoryId: map['categoryId'] as String,
      status: ProductStatus.values.firstWhere(
        (e) => e.toString() == 'ProductStatus.${map['status']}',
        orElse: () => ProductStatus.available,
      ),
      donorId: map['donorId'] as String,
      donorName: map['donorName'] as String,
      donorPhotoUrl: map['donorPhotoUrl'] as String?,
      imageUrl: map['imageUrl'] as String?,
      imageUrls: (map['imageUrls'] as String? ?? '').split(',').where((s) => s.isNotEmpty).toList(),
      expiryDate: DateTime.parse(map['expiryDate'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      latitude: map['latitude'] != null ? (map['latitude'] as num).toDouble() : null,
      longitude: map['longitude'] != null ? (map['longitude'] as num).toDouble() : null,
      address: map['address'] as String?,
      pickupInstructions: map['pickupInstructions'] as String?,
      quantity: (map['quantity'] as num).toInt(),
      quantityUnit: map['quantityUnit'] as String,
      isAllergenFree: (map['isAllergenFree'] as int) == 1,
      allergens: (map['allergens'] as String).split(',').where((s) => s.isNotEmpty).toList(),
      rating: (map['rating'] as num).toDouble(),
      reviewCount: (map['reviewCount'] as num).toInt(),
      price: (map['price'] as num).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'status': status.toString().split('.').last,
      'donorId': donorId,
      'donorName': donorName,
      'donorPhotoUrl': donorPhotoUrl,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls.join(','), // Chuyển List thành String
      'expiryDate': expiryDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'pickupInstructions': pickupInstructions,
      'quantity': quantity,
      'quantityUnit': quantityUnit,
      'isAllergenFree': isAllergenFree ? 1 : 0,
      'allergens': allergens.join(','),
      'rating': rating,
      'reviewCount': reviewCount,
      'price': price,
    };
  }

  ProductModel copyWith({
    String? id,
    String? title,
    String? description,
    String? categoryId,
    ProductStatus? status,
    String? donorId,
    String? donorName,
    String? donorPhotoUrl,
    String? imageUrl,
    List<String>? imageUrls,
    DateTime? expiryDate,
    DateTime? createdAt,
    double? latitude,
    double? longitude,
    String? address,
    String? pickupInstructions,
    int? quantity,
    String? quantityUnit,
    bool? isAllergenFree,
    List<String>? allergens,
    double? rating,
    int? reviewCount,
    int? price,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      status: status ?? this.status,
      donorId: donorId ?? this.donorId,
      donorName: donorName ?? this.donorName,
      donorPhotoUrl: donorPhotoUrl ?? this.donorPhotoUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt ?? this.createdAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      pickupInstructions: pickupInstructions ?? this.pickupInstructions,
      quantity: quantity ?? this.quantity,
      quantityUnit: quantityUnit ?? this.quantityUnit,
      isAllergenFree: isAllergenFree ?? this.isAllergenFree,
      allergens: allergens ?? this.allergens,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      price: price ?? this.price,
    );
  }
}
