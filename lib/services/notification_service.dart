import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  Future<void> createNotification({
    required String userId,
    required String title,
    required String message,
    String roleTarget = 'customer',
    String? appointmentId,
    String? type,
  }) async {
    if (appointmentId != null && type != null) {
      final snapshot = await _firestore.collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('roleTarget', isEqualTo: roleTarget)
          .where('appointmentId', isEqualTo: appointmentId)
          .where('type', isEqualTo: type)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        debugPrint('duplicate notification skipped: type: $type, userId: $userId');
        return;
      }
    }

    final docRef = _firestore.collection('notifications').doc();
    final notif = NotificationModel(
      id: docRef.id,
      userId: userId,
      roleTarget: roleTarget,
      title: title,
      message: message,
      appointmentId: appointmentId,
      type: type,
      createdAt: DateTime.now(),
      isRead: false,
    );
    
    debugPrint('--- Creating Notification ---');
    debugPrint('userId: $userId');
    debugPrint('roleTarget: $roleTarget');
    debugPrint('title: $title');
    
    await docRef.set(notif.toMap());
  }

  Stream<List<NotificationModel>> getUserNotifications(String userId, String userRole) {
    Query query = _firestore.collection('notifications');
    if (userRole == 'barber') {
      query = query.where('roleTarget', isEqualTo: 'barber');
    } else {
      query = query.where('userId', isEqualTo: userId);
    }

    return query
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs.map((doc) {
        return NotificationModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList().cast<NotificationModel>();
      
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      debugPrint('--- Stream Notification Updates ---');
      debugPrint('Role queried: $userRole');
      debugPrint('Notifications fetched: ${list.length}');
      
      return list;
    });
  }

  Future<void> deleteNotification(String id) async {
    await _firestore.collection('notifications').doc(id).delete();
  }

  Future<void> deleteAllBarberNotifications() async {
    final snapshot = await _firestore.collection('notifications')
        .where('roleTarget', isEqualTo: 'barber')
        .get();
        
    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<void> deleteAllUserNotifications(String userId) async {
    final snapshot = await _firestore.collection('notifications')
        .where('userId', isEqualTo: userId)
        .get();
        
    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}

final notificationService = NotificationService();
