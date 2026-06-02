import 'dart:async';
import '../models/service_model.dart';
import '../models/barber_model.dart';
import '../models/booking_model.dart';

class FirestoreService {
  // Local Data Stores
  static List<ServiceModel> _services = [];
  static List<BarberModel> _barbers = [];
  static final List<BookingModel> _bookings = [];

  // Stream Controllers
  static final _servicesController = StreamController<List<ServiceModel>>.broadcast();
  static final _barbersController = StreamController<List<BarberModel>>.broadcast();
  static final _bookingsController = StreamController<List<BookingModel>>.broadcast();

  FirestoreService() {
    if (_services.isEmpty || _barbers.isEmpty) {
      initializeDummyData();
    }
  }

  Stream<List<ServiceModel>> getServices() async* {
    yield _services;
    yield* _servicesController.stream;
  }

  Stream<List<BarberModel>> getBarbers() async* {
    yield _barbers;
    yield* _barbersController.stream;
  }

  Future<bool> createBooking(BookingModel booking) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    bool exists = _bookings.any((b) => 
        b.barberId == booking.barberId && 
        b.date == booking.date && 
        b.time == booking.time && 
        b.status != 'İptal Edildi');

    if (exists) {
      return false; 
    }

    final newBooking = BookingModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: booking.userId,
      userName: booking.userName,
      serviceId: booking.serviceId,
      serviceName: booking.serviceName,
      barberId: booking.barberId,
      barberName: booking.barberName,
      date: booking.date,
      time: booking.time,
      price: booking.price,
      status: booking.status,
      createdAt: booking.createdAt,
    );

    _bookings.add(newBooking);
    _bookingsController.add(_bookings);
    return true;
  }

  Stream<List<BookingModel>> getUserBookings(String userId) async* {
    yield _bookings.where((b) => b.userId == userId).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    yield* _bookingsController.stream.map((bookings) => 
      bookings.where((b) => b.userId == userId).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt))
    );
  }

  Stream<List<BookingModel>> getAllBookings() async* {
    final list = List<BookingModel>.from(_bookings);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    yield list;

    yield* _bookingsController.stream.map((bookings) {
      final list = List<BookingModel>.from(bookings);
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      final old = _bookings[index];
      _bookings[index] = BookingModel(
        id: old.id,
        userId: old.userId,
        userName: old.userName,
        serviceId: old.serviceId,
        serviceName: old.serviceName,
        barberId: old.barberId,
        barberName: old.barberName,
        date: old.date,
        time: old.time,
        price: old.price,
        status: newStatus,
        createdAt: old.createdAt,
      );
      _bookingsController.add(_bookings);
    }
  }

  Future<void> addReviewToBarber(String barberId, double rating, String comment) async {
    final index = _barbers.indexWhere((b) => b.id == barberId);
    if (index != -1) {
      final barber = _barbers[index];
      final newReview = ReviewModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userName: 'Siz',
        rating: rating,
        comment: comment,
        date: DateTime.now(),
      );
      
      final updatedReviews = List<ReviewModel>.from(barber.reviews)..add(newReview);
      
      double totalRating = updatedReviews.fold(0.0, (sum, item) => sum + item.rating);
      double newAverage = totalRating / updatedReviews.length;

      _barbers[index] = BarberModel(
        id: barber.id,
        name: barber.name,
        specialty: barber.specialty,
        imageUrl: barber.imageUrl,
        rating: newAverage,
        experienceYears: barber.experienceYears,
        workingHours: barber.workingHours,
        description: barber.description,
        reviews: updatedReviews,
      );
      _barbersController.add(_barbers);
    }
  }

  Future<void> initializeDummyData() async {
    if (_services.isEmpty) {
      _services = [
        ServiceModel(id: 's1', name: 'Saç Kesimi', duration: 30, price: 250, description: 'Modern saç kesim modelleri'),
        ServiceModel(id: 's2', name: 'Sakal Tıraşı', duration: 20, price: 150, description: 'Sakal şekillendirme ve tıraş'),
        ServiceModel(id: 's3', name: 'Saç Yıkama', duration: 15, price: 100, description: 'Fön ve şekillendirme öncesi yıkama'),
        ServiceModel(id: 's4', name: 'Cilt Bakımı', duration: 40, price: 300, description: 'Yüz maskesi ve siyah nokta temizliği'),
      ];
      _servicesController.add(_services);
    }

    if (_barbers.isEmpty) {
      _barbers = [
        BarberModel(
          id: 'b1', 
          name: 'Ahmet Usta', 
          specialty: 'Saç Kesimi Uzmanı', 
          rating: 4.8, 
          experienceYears: 10,
          workingHours: '09:00 - 18:00',
          description: '10 yıllık deneyim. Modern saç kesimlerinde usta.',
          imageUrl: 'assets/images/barber1.png',
          reviews: [
            ReviewModel(id: 'r1', userName: 'Veli G.', rating: 5, comment: 'Çok memnun kaldım.', date: DateTime.now().subtract(const Duration(days: 2))),
            ReviewModel(id: 'r2', userName: 'Kaan B.', rating: 4.5, comment: 'Hizmet hızlı ve profesyoneldi.', date: DateTime.now().subtract(const Duration(days: 5))),
          ],
        ),
        BarberModel(
          id: 'b2', 
          name: 'Mehmet Usta', 
          specialty: 'Sakal Tıraşı Uzmanı', 
          rating: 4.7, 
          experienceYears: 7,
          workingHours: '10:00 - 19:00',
          description: 'Sakal tasarımı ve bakımında bir numara.',
          imageUrl: 'assets/images/barber2.png',
          reviews: [
            ReviewModel(id: 'r3', userName: 'Can K.', rating: 5, comment: 'Tekrar tercih ederim.', date: DateTime.now().subtract(const Duration(days: 1))),
          ],
        ),
        BarberModel(
          id: 'b3', 
          name: 'Yusuf Usta', 
          specialty: 'Modern Stil Uzmanı', 
          rating: 4.9, 
          experienceYears: 12,
          workingHours: '08:00 - 17:00',
          description: 'Renk ve modern kesim uzmanı. Müşteri memnuniyeti odaklı.',
          imageUrl: 'assets/images/barber3.png',
          reviews: [
            ReviewModel(id: 'r4', userName: 'Ali V.', rating: 5, comment: 'Mükemmel işçilik.', date: DateTime.now().subtract(const Duration(days: 3))),
          ],
        ),
      ];
      _barbersController.add(_barbers);
    }
  }
}
