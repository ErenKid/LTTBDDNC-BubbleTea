class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String? iconName; // Tên icon để lưu trong DB
  final String colorHex; // Màu sắc dạng hex string
  final DateTime createdAt;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    this.iconName,
    required this.colorHex,
    required this.createdAt,
    this.isActive = true,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      iconName: map['iconName'] as String?,
      colorHex: map['colorHex'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      isActive: (map['isActive'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconName': iconName,
      'colorHex': colorHex,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive ? 1 : 0,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? iconName,
    String? colorHex,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
