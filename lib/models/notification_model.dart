class NotificationModel {
  final String id;
  final String userId;
  final String roleTarget;
  final String title;
  final String message;
  final String? appointmentId;
  final String? type;
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.userId,
    this.roleTarget = 'customer',
    required this.title,
    required this.message,
    this.appointmentId,
    this.type,
    required this.createdAt,
    this.isRead = false,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> data, String documentId) {
    return NotificationModel(
      id: documentId,
      userId: data['userId'] ?? '',
      roleTarget: data['roleTarget'] ?? 'customer',
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      appointmentId: data['appointmentId'],
      type: data['type'],
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] is DateTime ? data['createdAt'] : DateTime.parse(data['createdAt'].toString())) 
          : DateTime.now(),
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'roleTarget': roleTarget,
      'title': title,
      'message': message,
      'appointmentId': appointmentId,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? roleTarget,
    String? title,
    String? message,
    String? appointmentId,
    String? type,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      roleTarget: roleTarget ?? this.roleTarget,
      title: title ?? this.title,
      message: message ?? this.message,
      appointmentId: appointmentId ?? this.appointmentId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
