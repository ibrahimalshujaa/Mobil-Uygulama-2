import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_model.dart';

class SalonService {
  static final SalonService _instance = SalonService._internal();
  factory SalonService() => _instance;
  SalonService._internal();

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  // Settings
  Future<Map<String, dynamic>> getSalonSettings() async {
    final doc = await _firestore.collection('settings').doc('salon').get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    }
    return {
      'salonName': 'StyleHub Barber Studio',
      'phone': '+90 555 555 55 55',
      'address': 'Bartın Merkez, Türkiye',
      'workingHours': 'Her Gün: 09:00 - 21:00',
      'about': 'Modern ve lüks saç kesim deneyimi için doğru yerdesiniz.',
      'instagram': '',
      'whatsapp': '',
    };
  }

  Future<void> updateSalonSettings(Map<String, dynamic> data) async {
    await _firestore.collection('settings').doc('salon').set(data, SetOptions(merge: true));
  }
  
  Stream<Map<String, dynamic>> salonSettingsStream() {
    return _firestore.collection('settings').doc('salon').snapshots().map((doc) {
      if (doc.exists) return doc.data() as Map<String, dynamic>;
      return {
        'salonName': 'StyleHub Barber Studio',
        'phone': '+90 555 555 55 55',
        'address': 'Bartın Merkez, Türkiye',
        'workingHours': 'Her Gün: 09:00 - 21:00',
        'about': 'Modern ve lüks saç kesim deneyimi için doğru yerdesiniz.',
        'instagram': '',
        'whatsapp': '',
      };
    });
  }

  // Services
  Stream<List<ServiceModel>> getServices({bool onlyActive = false}) {
    Query query = _firestore.collection('services');
    if (onlyActive) {
      query = query.where('isActive', isEqualTo: true);
    }
    return query.snapshots().map((snapshot) {
      final list = snapshot.docs.map((doc) {
        return ServiceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList().cast<ServiceModel>();
      list.sort((a, b) => a.name.compareTo(b.name));
      return list;
    });
  }

  Future<void> addService(ServiceModel service) async {
    final docRef = _firestore.collection('services').doc();
    final newService = service.copyWith(id: docRef.id, createdAt: DateTime.now());
    await docRef.set(newService.toMap());
  }

  Future<void> updateService(ServiceModel service) async {
    await _firestore.collection('services').doc(service.id).update(service.toMap());
  }

  Future<void> deleteService(String id) async {
    await _firestore.collection('services').doc(id).delete();
  }
}

final salonService = SalonService();
