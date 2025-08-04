class UserModel {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final String? phoneNumber;
  final String? address;
  final double? latitude;
  final double? longitude;
  final int rating;
  final int totalShares;
  final int totalReceives;
  final DateTime createdAt;
  final bool isVerified;
  final String password;
  final bool isAdmin;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    this.phoneNumber,
    this.address,
    this.latitude,
    this.longitude,
    this.rating = 0,
    this.totalShares = 0,
    this.totalReceives = 0,
    required this.createdAt,
    this.isVerified = false,
    required this.password,
    this.isAdmin = false,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      rating: map['rating']?.toInt() ?? 0,
      totalShares: map['totalShares']?.toInt() ?? 0,
      totalReceives: map['totalReceives']?.toInt() ?? 0,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isVerified: map['isVerified'] ?? false,
      password: map['password'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'totalShares': totalShares,
      'totalReceives': totalReceives,
      'createdAt': createdAt,
      'isVerified': isVerified,
      'password': password,
      'isAdmin': isAdmin,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    String? phoneNumber,
    String? address,
    double? latitude,
    double? longitude,
    int? rating,
    int? totalShares,
    int? totalReceives,
    DateTime? createdAt,
    bool? isVerified,
    String? password,
    bool? isAdmin,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      totalShares: totalShares ?? this.totalShares,
      totalReceives: totalReceives ?? this.totalReceives,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      password: password ?? this.password,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}

// Helper class for Timestamp conversion
class Timestamp {
  final DateTime dateTime;
  
  Timestamp(this.dateTime);
  
  DateTime toDate() => dateTime;
} 