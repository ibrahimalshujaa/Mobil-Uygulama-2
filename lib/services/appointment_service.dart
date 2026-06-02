import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment_model.dart';
import '../services/notification_service.dart';

class AppointmentService {
  static final AppointmentService _instance = AppointmentService._internal();
  factory AppointmentService() => _instance;
  AppointmentService._internal();

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  Future<String> createAppointment(AppointmentModel appointment) async {
    try {
      debugPrint('checking appointment conflict date/time: ${appointment.date} ${appointment.time}');
      final querySnapshot = await _firestore.collection('appointments')
          .where('barberId', isEqualTo: appointment.barberId)
          .where('date', isEqualTo: appointment.date)
          .where('time', isEqualTo: appointment.time)
          .get();

      final hasConflict = querySnapshot.docs.any((doc) {
        final data = doc.data();
        return data['status'] != 'İptal Edildi' && data['isArchived'] != true;
      });

      debugPrint('conflict found: $hasConflict');

      if (hasConflict) {
        return 'conflict';
      }

      await _firestore.collection('appointments').doc(appointment.id).set(appointment.toMap());
      
      debugPrint('Creating customer notification for uid: ${appointment.userId}');
      await notificationService.createNotification(
        userId: appointment.userId,
        roleTarget: 'customer',
        title: 'Randevu Oluşturuldu',
        message: 'Randevunuz başarıyla oluşturuldu.',
        appointmentId: appointment.id,
        type: 'appointment_created',
      );

      debugPrint('Creating barber notification:');
      await notificationService.createNotification(
        userId: 'barber',
        roleTarget: 'barber',
        title: 'Yeni Randevu Talebi',
        message: '${appointment.userName} adlı müşteri ${appointment.date} tarihinde saat ${appointment.time} için yeni randevu oluşturdu.',
        appointmentId: appointment.id,
        type: 'new_appointment',
      );

      return 'success';
    } catch (e) {
      print('Error creating appointment: $e');
      return 'error';
    }
  }

  Stream<List<AppointmentModel>> getUserAppointments(String userId) {
    return _firestore.collection('appointments')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs.map((doc) {
        return AppointmentModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList().cast<AppointmentModel>();
      
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  Stream<List<AppointmentModel>> getAllAppointments() {
    return _firestore.collection('appointments')
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs.map((doc) {
        return AppointmentModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList().cast<AppointmentModel>();
      
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  Future<void> updateAppointmentStatus(String appointmentId, String newStatus, {String? userId}) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': newStatus,
      });
      
      String? customerName;
      
      final doc = await _firestore.collection('appointments').doc(appointmentId).get();
      if (doc.exists) {
        userId ??= doc.data()?['userId'] as String?;
        customerName = doc.data()?['userName'] as String?;
      }
      customerName ??= 'Bir müşteri';

      if (userId != null) {
        String customerTitle = '';
        String customerMessage = '';
        String barberTitle = '';
        String barberMessage = '';

        if (newStatus == 'Onaylandı') {
          customerTitle = 'Randevu Onaylandı';
          customerMessage = 'Randevunuz onaylandı.';
          barberTitle = 'Randevu Onaylandı';
          barberMessage = '$customerName adlı müşterinin randevusu onaylandı.';
        } else if (newStatus == 'Reddedildi') {
          customerTitle = 'Randevu Reddedildi';
          customerMessage = 'Randevunuz reddedildi.';
          barberTitle = 'Randevu Reddedildi';
          barberMessage = '$customerName adlı müşterinin randevusu reddedildi.';
        } else if (newStatus == 'İptal Edildi') {
          customerTitle = 'Randevu İptal Edildi';
          customerMessage = 'Randevunuz iptal edildi.';
          barberTitle = 'Randevu İptal Edildi';
          barberMessage = '$customerName adlı müşteri randevusunu iptal etti.';
        } else if (newStatus == 'Tamamlandı') {
          customerTitle = 'Randevu Tamamlandı';
          customerMessage = 'Randevunuz tamamlandı. Değerlendirme yapabilirsiniz.';
          barberTitle = 'Randevu Tamamlandı';
          barberMessage = '$customerName adlı müşterinin randevusu başarıyla tamamlandı.';
        }

        if (customerTitle.isNotEmpty) {
          debugPrint('Creating customer notification for uid: $userId');
          await notificationService.createNotification(
            userId: userId, 
            roleTarget: 'customer',
            title: customerTitle, 
            message: customerMessage,
            appointmentId: appointmentId,
            type: 'status_update',
          );
          
          debugPrint('Creating barber notification:');
          await notificationService.createNotification(
            userId: 'barber', 
            roleTarget: 'barber',
            title: barberTitle, 
            message: barberMessage,
            appointmentId: appointmentId,
            type: 'status_update',
          );
        }
      }
    } catch (e) {
      print('Error updating appointment status: $e');
    }
  }

  Future<void> deleteAppointment(String appointmentId) async {
    try {
      debugPrint('archived appointment id: $appointmentId');
      await _firestore.collection('appointments').doc(appointmentId).update({
        'isArchived': true,
        'archivedAt': DateTime.now().toIso8601String(),
      });
      debugPrint('delete success');
    } catch (e) {
      debugPrint('delete error: $e');
    }
  }
}

final appointmentService = AppointmentService();
