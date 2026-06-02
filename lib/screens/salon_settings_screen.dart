import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../services/salon_service.dart';

class SalonSettingsScreen extends StatefulWidget {
  const SalonSettingsScreen({super.key});

  @override
  State<SalonSettingsScreen> createState() => _SalonSettingsScreenState();
}

class _SalonSettingsScreenState extends State<SalonSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _hoursController;
  late TextEditingController _aboutController;
  late TextEditingController _instagramController;
  late TextEditingController _whatsappController;

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _hoursController = TextEditingController();
    _aboutController = TextEditingController();
    _instagramController = TextEditingController();
    _whatsappController = TextEditingController();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final data = await salonService.getSalonSettings();
    setState(() {
      _nameController.text = data['salonName'] ?? '';
      _phoneController.text = data['phone'] ?? '';
      _addressController.text = data['address'] ?? '';
      _hoursController.text = data['workingHours'] ?? '';
      _aboutController.text = data['about'] ?? '';
      _instagramController.text = data['instagram'] ?? '';
      _whatsappController.text = data['whatsapp'] ?? '';
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    
    try {
      await salonService.updateSalonSettings({
        'salonName': _nameController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'workingHours': _hoursController.text,
        'about': _aboutController.text,
        'instagram': _instagramController.text,
        'whatsapp': _whatsappController.text,
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ayarlar başarıyla kaydedildi.'), backgroundColor: AppColors.success),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ayarlar kaydedilirken hata oluştu.'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Salon Ayarları', style: AppTextStyles.heading3),
        backgroundColor: AppColors.secondary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(_nameController, 'Salon Adı', Icons.store),
                    const SizedBox(height: 16),
                    _buildTextField(_phoneController, 'Telefon Numarası', Icons.phone),
                    const SizedBox(height: 16),
                    _buildTextField(_addressController, 'Adres', Icons.location_on, maxLines: 2),
                    const SizedBox(height: 16),
                    _buildTextField(_hoursController, 'Çalışma Saatleri', Icons.access_time),
                    const SizedBox(height: 16),
                    _buildTextField(_aboutController, 'Hakkımızda', Icons.info_outline, maxLines: 3),
                    const SizedBox(height: 16),
                    _buildTextField(_instagramController, 'Instagram (Opsiyonel)', Icons.camera_alt),
                    const SizedBox(height: 16),
                    _buildTextField(_whatsappController, 'WhatsApp (Opsiyonel)', Icons.chat),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveSettings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _isSaving
                            ? const CircularProgressIndicator(color: AppColors.background)
                            : const Text('Ayarları Kaydet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.background)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: AppColors.textLight),
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (label.contains('Opsiyonel')) return null;
          return 'Bu alan zorunludur.';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textMuted),
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _hoursController.dispose();
    _aboutController.dispose();
    _instagramController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }
}
