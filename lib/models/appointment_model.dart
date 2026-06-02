class AppointmentModel {
  final String id;
  final String userId;
  final String userName;
  final String serviceId;
  final String serviceName;
  final String barberId;
  final String barberName;
  final String date; // Format: yyyy-MM-dd
  final String time; // Format: HH:mm
  final double price;
  final String status;
  final DateTime createdAt;
  final bool isArchived;
  final DateTime? archivedAt;

  AppointmentModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.serviceId,
    required this.serviceName,
    required this.barberId,
    required this.barberName,
    required this.date,
    required this.time,
    required this.price,
    required this.status,
    required this.createdAt,
    this.isArchived = false,
    this.archivedAt,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> data, String documentId) {
    return AppointmentModel(
      id: documentId,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      serviceId: data['serviceId'] ?? '',
      serviceName: data['serviceName'] ?? '',
      barberId: data['barberId'] ?? '',
      barberName: data['barberName'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'Bekliyor',
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] is DateTime ? data['createdAt'] : DateTime.parse(data['createdAt'].toString())) 
          : DateTime.now(),
      isArchived: data['isArchived'] ?? false,
      archivedAt: data['archivedAt'] != null ? DateTime.tryParse(data['archivedAt'].toString()) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'barberId': barberId,
      'barberName': barberName,
      'date': date,
      'time': time,
      'price': price,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'isArchived': isArchived,
      'archivedAt': archivedAt?.toIso8601String(),
    };
  }

  AppointmentModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? serviceId,
    String? serviceName,
    String? barberId,
    String? barberName,
    String? date,
    String? time,
    double? price,
    String? status,
    DateTime? createdAt,
    bool? isArchived,
    DateTime? archivedAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      barberId: barberId ?? this.barberId,
      barberName: barberName ?? this.barberName,
      date: date ?? this.date,
      time: time ?? this.time,
      price: price ?? this.price,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      isArchived: isArchived ?? this.isArchived,
      archivedAt: archivedAt ?? this.archivedAt,
    );
  }
}
