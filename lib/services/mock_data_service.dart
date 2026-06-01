import '../models/service_model.dart';
import '../models/barber_model.dart';

class MockDataService {
  static List<ServiceModel> services = [
    ServiceModel(id: 's1', name: 'Saç Kesimi', duration: 30, price: 250, description: 'Modern saç kesim modelleri'),
    ServiceModel(id: 's2', name: 'Sakal Tıraşı', duration: 20, price: 150, description: 'Sakal şekillendirme ve tıraş'),
    ServiceModel(id: 's3', name: 'Saç Yıkama', duration: 15, price: 100, description: 'Fön ve şekillendirme öncesi yıkama'),
    ServiceModel(id: 's4', name: 'Cilt Bakımı', duration: 40, price: 300, description: 'Yüz maskesi ve siyah nokta temizliği'),
    ServiceModel(id: 's5', name: 'Saç Boyama', duration: 90, price: 1500, description: 'Profesyonel saç boyama ve renk uygulaması'),
  ];

  static List<BarberModel> barbers = [
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
}
