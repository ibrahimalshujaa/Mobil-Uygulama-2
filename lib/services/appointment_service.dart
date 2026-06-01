import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment_model.dart';

class AppointmentService {
  static final AppointmentService _instance = AppointmentService._internal();
  factory AppointmentService() => _instance;
  AppointmentService._internal();

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  Future<bool> createAppointment(AppointmentModel appointment) async {
    try {
      // Check for existing appointment at same date/time
      final querySnapshot = await _firestore.collection('appointments')
          .where('barberId', isEqualTo: appointment.barberId)
          .where('date', isEqualTo: appointment.date)
          .where('time', isEqualTo: appointment.time)
          .get();

      if (querySnapshot.docs.any((doc) => doc.data()['status'] != 'İptal Edildi')) {
        return false;
      }

      await _firestore.collection('appointments').doc(appointment.id).set(appointment.toMap());
      return true;
    } catch (e) {
      print('Error creating appointment: $e');
      return false;
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
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return AppointmentModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList().cast<AppointmentModel>();
    });
  }

  Future<void> updateAppointmentStatus(String appointmentId, String newStatus) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': newStatus,
      });
    } catch (e) {
      print('Error updating appointment status: \$e');
    }
  }
}

final appointmentService = AppointmentService();
