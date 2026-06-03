import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/service_model.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;

  const ServiceCard({super.key, required this.service, required this.onTap});

  IconData _getIconForService(String name) {
    if (name.toLowerCase().contains('kesim')) return Icons.content_cut;
    if (name.toLowerCase().contains('sakal')) return Icons.face;
    if (name.toLowerCase().contains('yıkama')) return Icons.water_drop;
    if (name.toLowerCase().contains('bakım')) return Icons.spa;
    if (name.toLowerCase().contains('boya')) return Icons.color_lens;
    if (name.toLowerCase().contains('tam')) return Icons.star;
    return Icons.design_services;
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) return '$minutes dk';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) return '$hours sa';
    return '$hours sa $mins dk';
  }

  @override
  Widget build(BuildContext context) {
    final bool isBundle = service.subServices != null && service.subServices!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isBundle
                  ? AppColors.primary.withValues(alpha: 0.25)
                  : Colors.black.withValues(alpha: 0.2),
              blurRadius: isBundle ? 16 : 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isBundle ? AppColors.primary : AppColors.secondaryLight,
            width: isBundle ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            // Main row
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconForService(service.name),
                      color: AppColors.background,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(service.name, style: AppTextStyles.heading3),
                            if (isBundle) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                                ),
                                child: const Text(
                                  'PAKET',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.schedule, size: 14, color: AppColors.textMuted),
                            const SizedBox(width: 4),
                            Text(
                              _formatDuration(service.duration),
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                        if (service.description.trim().isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            service.description.trim(),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${service.price.toInt()} TL',
                        style: AppTextStyles.heading3.copyWith(color: AppColors.primary),
                      ),
                      const SizedBox(height: 4),
                      Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primary),
                    ],
                  ),
                ],
              ),
            ),

            // Sub-services row (only for bundle)
            if (isBundle) ...[
              Divider(
                height: 1,
                color: AppColors.primary.withValues(alpha: 0.2),
                indent: 16,
                endIndent: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, size: 13, color: AppColors.primary.withValues(alpha: 0.7)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        service.subServices!.join('  •  '),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
