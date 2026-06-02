import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewService {
  static final ReviewService _instance = ReviewService._internal();
  factory ReviewService() => _instance;
  ReviewService._internal();

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  Future<void> createReview({
    required String appointmentId,
    required String userId,
    required String userName,
    required String serviceName,
    required double rating,
    required String comment,
  }) async {
    final docRef = _firestore.collection('reviews').doc();
    await docRef.set({
      'appointmentId': appointmentId,
      'userId': userId,
      'userName': userName,
      'serviceName': serviceName,
      'rating': rating,
      'comment': comment,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<bool> hasReviewed(String appointmentId) async {
    final snapshot = await _firestore.collection('reviews')
        .where('appointmentId', isEqualTo: appointmentId)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Stream<List<dynamic>> getReviews() {
    return _firestore.collection('reviews')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }
}

final reviewService = ReviewService();
