import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../services/review_service.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Müşteri Değerlendirmeleri',
          style: AppTextStyles.heading3,
        ),
        backgroundColor: AppColors.secondary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: reviewService.getReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          final reviews = snapshot.data ?? [];

          if (reviews.isEmpty) {
            return const Center(
              child: Text(
                'Henüz değerlendirme yok.',
                style: AppTextStyles.bodyLarge,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24.0),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final data = reviews[index].data() as Map<String, dynamic>;
              final rating = (data['rating'] ?? 5.0).toDouble();
              final date = data['createdAt'] != null
                  ? DateTime.tryParse(data['createdAt'].toString())
                  : DateTime.now();
              final dateStr = date != null
                  ? "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}"
                  : "";

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.secondaryLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['userName'] ?? 'Müşteri',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (starIndex) => Icon(
                              starIndex < rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['serviceName'] ?? 'Hizmet',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          dateStr,
                          style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                    if (data['comment'] != null &&
                        data['comment'].toString().isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(data['comment'], style: AppTextStyles.bodyMedium),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
