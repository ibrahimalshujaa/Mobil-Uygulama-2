class ServiceModel {
  final String id;
  final String name;
  final int duration; // in minutes
  final double price;
  final String description;
  final bool isActive;
  final DateTime? createdAt;
  final List<String>? subServices; // for bundle packages

  ServiceModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.description,
    this.isActive = true,
    this.createdAt,
    this.subServices,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> data, [String docId = '']) {
    return ServiceModel(
      id: docId.isNotEmpty ? docId : (data['id'] ?? ''),
      name: data['name'] ?? '',
      duration: data['duration'] ?? 0,
      price: (data['price'] ?? 0.0).toDouble(),
      description: data['description'] ?? '',
      isActive: data['isActive'] ?? true,
      createdAt: data['createdAt'] != null ? DateTime.tryParse(data['createdAt'].toString()) : null,
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'price': price,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  ServiceModel copyWith({
    String? id,
    String? name,
    int? duration,
    double? price,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    List<String>? subServices,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      subServices: subServices ?? this.subServices,
    );
  }
}
