import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/service_model.dart';
import 'confirmation_screen.dart';

class BookingScreen extends StatefulWidget {
  final ServiceModel selectedService;

  const BookingScreen({
    super.key,
    required this.selectedService,
  });

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedTime;

  final List<String> _timeSlots = [
    '09:00', '10:00', '11:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00'
  ];

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final firstDay = DateTime.utc(today.year, today.month, today.day);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Uygun Saat Seç', style: AppTextStyles.heading3),
        backgroundColor: AppColors.secondary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              color: AppColors.secondary,
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.cut, color: AppColors.primary, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.selectedService.name, style: AppTextStyles.heading2),
                        const SizedBox(height: 4),
                        Text('${widget.selectedService.duration} dk • ${widget.selectedService.price} ₺', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text('Tarih Seçimi', style: AppTextStyles.heading2),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.secondaryLight),
                ),
                child: TableCalendar(
                  firstDay: firstDay,
                  lastDay: DateTime.now().add(const Duration(days: 30)),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    if (selectedDay.isBefore(firstDay)) return;
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      _selectedTime = null;
                    });
                  },
                  calendarStyle: const CalendarStyle(
                    defaultTextStyle: TextStyle(color: AppColors.textLight),
                    weekendTextStyle: TextStyle(color: AppColors.textLight),
                    selectedDecoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(color: AppColors.secondaryLight, shape: BoxShape.circle),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(color: AppColors.textLight, fontSize: 16, fontWeight: FontWeight.bold),
                    leftChevronIcon: Icon(Icons.chevron_left, color: AppColors.primary),
                    rightChevronIcon: Icon(Icons.chevron_right, color: AppColors.primary),
                  ),
                ),
              ),
            ),
            if (_selectedDay != null) ...[
              const SizedBox(height: 32),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text('Saat Seçimi', style: AppTextStyles.heading2),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _timeSlots.length,
                  itemBuilder: (context, index) {
                    final time = _timeSlots[index];
                    final isSelected = _selectedTime == time;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTime = time;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.secondary,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isSelected ? AppColors.primary : AppColors.secondaryLight),
                        ),
                        child: Text(
                          time,
                          style: TextStyle(
                            color: isSelected ? AppColors.background : AppColors.textLight,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        color: AppColors.background,
        child: ElevatedButton(
          onPressed: () {
            if (_selectedDay == null || _selectedTime == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lütfen tarih ve saat seçiniz.'),
                  backgroundColor: AppColors.error,
                ),
              );
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConfirmationScreen(
                  selectedService: widget.selectedService,
                  selectedDate: _selectedDay!,
                  selectedTime: _selectedTime!,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text('Devam Et', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.background)),
        ),
      ),
    );
  }
}
