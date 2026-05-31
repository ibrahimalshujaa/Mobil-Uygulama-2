class ReviewModel {
  final String id;
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  ReviewModel({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> data) {
    return ReviewModel(
      id: data['id'] ?? '',
      userName: data['userName'] ?? 'Anonim',
      rating: (data['rating'] ?? 5.0).toDouble(),
      comment: data['comment'] ?? '',
      date: data['date'] != null ? data['date'].toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'date': date,
    };
  }
}

class BarberModel {
  final String id;
  final String name;
  final String specialty;
  final String imageUrl;
  final double rating;
  final int experienceYears;
  final String workingHours;
  final String description;
  final List<ReviewModel> reviews;

  BarberModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    this.rating = 5.0,
    this.experienceYears = 5,
    this.workingHours = '09:00 - 18:00',
    this.description = 'Profesyonel saç kesim ve bakım uzmanı.',
    this.reviews = const [],
  });

  factory BarberModel.fromMap(Map<String, dynamic> data) {
    var reviewList = data['reviews'] as List? ?? [];
    return BarberModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      specialty: data['specialty'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      rating: (data['rating'] ?? 5.0).toDouble(),
      experienceYears: data['experienceYears'] ?? 5,
      workingHours: data['workingHours'] ?? '09:00 - 18:00',
      description: data['description'] ?? 'Profesyonel saç kesim ve bakım uzmanı.',
      reviews: reviewList.map((r) => ReviewModel.fromMap(r)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'imageUrl': imageUrl,
      'rating': rating,
      'experienceYears': experienceYears,
      'workingHours': workingHours,
      'description': description,
      'reviews': reviews.map((r) => r.toMap()).toList(),
    };
  }
}
