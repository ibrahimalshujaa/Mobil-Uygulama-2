import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/service_model.dart';
import '../services/salon_service.dart';

class ServiceManagementScreen extends StatefulWidget {
  const ServiceManagementScreen({super.key});

  @override
  State<ServiceManagementScreen> createState() => _ServiceManagementScreenState();
}

class _ServiceManagementScreenState extends State<ServiceManagementScreen> {
  void _showAddServiceDialog(BuildContext context, [ServiceModel? existingService]) {
    final nameController = TextEditingController(text: existingService?.name ?? '');
    final durationController = TextEditingController(text: existingService != null ? existingService.duration.toString() : '');
    final priceController = TextEditingController(text: existingService != null ? existingService.price.toString() : '');
    final descController = TextEditingController(text: existingService?.description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.secondary,
        title: Text(existingService == null ? 'Yeni Hizmet Ekle' : 'Hizmeti Düzenle', style: AppTextStyles.heading2),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(nameController, 'Hizmet Adı', Icons.cut),
              const SizedBox(height: 12),
              _buildTextField(durationController, 'Süre (dk)', Icons.timer, isNumber: true),
              const SizedBox(height: 12),
              _buildTextField(priceController, 'Fiyat (₺)', Icons.attach_money, isNumber: true),
              const SizedBox(height: 12),
              _buildTextField(descController, 'Açıklama', Icons.description),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty || durationController.text.isEmpty || priceController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen zorunlu alanları doldurun.')));
                return;
              }
              final service = ServiceModel(
                id: existingService?.id ?? '',
                name: nameController.text,
                duration: int.tryParse(durationController.text) ?? 30,
                price: double.tryParse(priceController.text) ?? 0.0,
                description: descController.text,
                isActive: existingService?.isActive ?? true,
                createdAt: existingService?.createdAt ?? DateTime.now(),
              );
              
              if (existingService == null) {
                await salonService.addService(service);
              } else {
                await salonService.updateService(service);
              }
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Kaydet', style: TextStyle(color: AppColors.background)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: AppColors.textLight),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Hizmet Yönetimi', style: AppTextStyles.heading3),
        backgroundColor: AppColors.secondary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: StreamBuilder<List<ServiceModel>>(
        stream: salonService.getServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final services = snapshot.data ?? [];
          
          debugPrint('services loaded count: ${services.length}');

          if (services.isEmpty) {
            return const Center(child: Text('Henüz hizmet eklenmedi.', style: AppTextStyles.bodyLarge));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24.0),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: service.isActive ? AppColors.secondary : AppColors.secondary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.secondaryLight),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.cut, color: service.isActive ? AppColors.primary : AppColors.textMuted),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(service.name, style: AppTextStyles.bodyLarge.copyWith(
                            color: service.isActive ? AppColors.textLight : AppColors.textMuted,
                            decoration: service.isActive ? null : TextDecoration.lineThrough,
                          )),
                          const SizedBox(height: 4),
                          Text('${service.duration} dk | ${service.price} ₺', style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    Switch(
                      value: service.isActive,
                      activeColor: AppColors.primary,
                      onChanged: (val) async {
                        await salonService.updateService(service.copyWith(isActive: val));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.info),
                      onPressed: () => _showAddServiceDialog(context, service),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: AppColors.error),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppColors.secondary,
                            title: const Text('Sil', style: AppTextStyles.heading2),
                            content: const Text('Bu hizmeti silmek istediğinize emin misiniz?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('İptal')),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sil', style: TextStyle(color: AppColors.error))),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await salonService.deleteService(service.id);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddServiceDialog(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.background),
      ),
    );
  }
}
