import 'dart:async';
import '../models/appointment_model.dart';

class AppointmentService {
  static final AppointmentService _instance = AppointmentService._internal();
  factory AppointmentService() => _instance;
  AppointmentService._internal();

  List<AppointmentModel> _appointments = [];
  final _appointmentsController = StreamController<List<AppointmentModel>>.broadcast();

  Stream<List<AppointmentModel>> get appointmentsStream => _appointmentsController.stream;

  Future<bool> createAppointment(AppointmentModel appointment) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    bool exists = _appointments.any((a) => 
        a.barberId == appointment.barberId && 
        a.date == appointment.date && 
        a.time == appointment.time && 
        a.status != 'İptal Edildi');

    if (exists) {
      return false; 
    }

    _appointments.add(appointment);
    _appointmentsController.add(_appointments);
    return true;
  }

  Stream<List<AppointmentModel>> getUserAppointments(String userId) async* {
    yield _appointments.where((a) => a.userId == userId).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    yield* _appointmentsController.stream.map((appointments) => 
      appointments.where((a) => a.userId == userId).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt))
    );
  }

  Stream<List<AppointmentModel>> getAllAppointments() async* {
    final list = List<AppointmentModel>.from(_appointments);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    yield list;

    yield* _appointmentsController.stream.map((appointments) {
      final list = List<AppointmentModel>.from(appointments);
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  Future<void> updateAppointmentStatus(String appointmentId, String newStatus) async {
    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(status: newStatus);
      _appointmentsController.add(_appointments);
    }
  }
}

final appointmentService = AppointmentService();
