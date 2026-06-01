class ServiceModel {
  final String id;
  final String name;
  final int duration; // in minutes
  final double price;
  final String description;
  final List<String>? subServices; // for bundle packages

  ServiceModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.description,
    this.subServices,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> data) {
    return ServiceModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      duration: data['duration'] ?? 0,
      price: (data['price'] ?? 0.0).toDouble(),
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'price': price,
      'description': description,
    };
  }
}
