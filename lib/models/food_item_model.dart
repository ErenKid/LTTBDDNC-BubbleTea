
enum FoodCategory {
  fruits,
  vegetables,
  grains,
  dairy,
  meat,
  baked,
  canned,
  other,
}

extension FoodCategoryExtension on FoodCategory {
  String get categoryDisplayName {
    switch (this) {
      case FoodCategory.fruits:
        return 'Fruits';
      case FoodCategory.vegetables:
        return 'Vegetables';
      case FoodCategory.grains:
        return 'Grains';
      case FoodCategory.dairy:
        return 'Dairy';
      case FoodCategory.meat:
        return 'Meat';
      case FoodCategory.baked:
        return 'Baked Goods';
      case FoodCategory.canned:
        return 'Canned Food';
      case FoodCategory.other:
        return 'Other';
    }
  }
}

enum FoodStatus {
  available,
  reserved,
  claimed,
  expired,
}

extension FoodStatusExtension on FoodStatus {
  String get statusDisplayName {
    switch (this) {
      case FoodStatus.available:
        return 'Available';
      case FoodStatus.reserved:
        return 'Reserved';
      case FoodStatus.claimed:
        return 'Claimed';
      case FoodStatus.expired:
        return 'Expired';
    }
  }
}

class FoodItemModel {
  final String id;
  final String title;
  final String description;
  final FoodCategory category;
  final FoodStatus status;
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

  FoodItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
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

  factory FoodItemModel.fromMap(Map<String, dynamic> map) {
    return FoodItemModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: FoodCategory.values.firstWhere(
        (e) => e.toString() == 'FoodCategory.${map['category']}',
        orElse: () => FoodCategory.other,
      ),
      status: FoodStatus.values.firstWhere(
        (e) => e.toString() == 'FoodStatus.${map['status']}',
        orElse: () => FoodStatus.available,
      ),
      donorId: map['donorId'] ?? '',
      donorName: map['donorName'] ?? '',
      donorPhotoUrl: map['donorPhotoUrl'],
      imageUrl: map['imageUrl'],
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      expiryDate: DateTime.parse(map['expiryDate'] ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      address: map['address'],
      pickupInstructions: map['pickupInstructions'],
      quantity: map['quantity']?.toInt() ?? 1,
      quantityUnit: map['quantityUnit'] ?? 'piece',
      isAllergenFree: map['isAllergenFree'] ?? false,
      allergens: List<String>.from(map['allergens'] ?? []),
      rating: map['rating']?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount']?.toInt() ?? 0,
      price: map['price']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.toString().split('.').last,
      'status': status.toString().split('.').last,
      'donorId': donorId,
      'donorName': donorName,
      'donorPhotoUrl': donorPhotoUrl,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
      'expiryDate': expiryDate,
      'createdAt': createdAt,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'pickupInstructions': pickupInstructions,
      'quantity': quantity,
      'quantityUnit': quantityUnit,
      'isAllergenFree': isAllergenFree,
      'allergens': allergens,
      'rating': rating,
      'reviewCount': reviewCount,
      'price': price,
    };
  }

  bool get isExpired => DateTime.now().isAfter(expiryDate);
  bool get isExpiringSoon => DateTime.now().isAfter(expiryDate.subtract(const Duration(days: 1)));

  String get categoryDisplayName => category.categoryDisplayName;

  String get statusDisplayName => status.statusDisplayName;

  FoodItemModel copyWith({
    String? id,
    String? title,
    String? description,
    FoodCategory? category,
    FoodStatus? status,
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
    return FoodItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
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