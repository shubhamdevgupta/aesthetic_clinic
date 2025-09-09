import 'package:aesthetic_clinic/models/appointment/appointment_slots.dart';
import 'package:aesthetic_clinic/providers/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/ui_state.dart';
import '../../utils/Appcolor.dart';

class BookingSlotScreen extends StatefulWidget {
  final String serviceId;

  BookingSlotScreen({Key? key, required this.serviceId}) : super(key: key);

  @override
  State<BookingSlotScreen> createState() => _BookingSlotScreenState();
}

class _BookingSlotScreenState extends State<BookingSlotScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<ServiceProvider>(
        context,
        listen: false,
      ).getAppointmentSlots(widget.serviceId),
    );
  }

  int selectedDoctorIndex = 0; // Default to first doctor
  DateTime selectedDate = DateTime.now();
  Slot? selectedSlot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Book Your Slot"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<ServiceProvider>(
        builder: (context, provider, child) {

          final appointmentSlotsState = provider.appointmentSlotsState;

          // 🔹 Show loader for Idle & Loading (for either state)
          if (appointmentSlotsState is Idle ||
              appointmentSlotsState is Loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if(appointmentSlotsState is Success<AppointmentSlots>){
            final appointmentSlot = appointmentSlotsState.response.data;

            if (appointmentSlot.isEmpty) {
              return const Center(child: Text('No doctors available'));
            }

            final int doctorIndex = selectedDoctorIndex < appointmentSlot.length ? selectedDoctorIndex : 0;
            final selectedSchedule = appointmentSlot[doctorIndex];

            // Build available dates set for the selected doctor in current month
            final Set<DateTime> availableDates = selectedSchedule.dates
                .map((d) => _parseYmd(d.date))
                .where((dt) => dt != null)
                .map((dt) => DateTime(dt!.year, dt.month, dt.day))
                .where((dt) => dt.month == selectedDate.month && dt.year == selectedDate.year)
                .toSet();

            // Slots for the currently selected date
            final String selectedDateStr = _toYyyyMmDd(selectedDate);
            final slotsForDay = selectedSchedule.dates
                .where((d) => d.date == selectedDateStr)
                .map((d) => d.slots)
                .expand((e) => e)
                .toList();

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Doctor Selection Section
                        const Text(
                          'Which Professional Do You Prefer?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Horizontal Doctor List
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: appointmentSlot.length,
                            itemBuilder: (context, index) {
                              final isSelected = selectedDoctorIndex == index;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedDoctorIndex = index;
                                    selectedSlot = null; // Reset time selection
                                  });
                                },
                                child: Container(
                                  width: 100,
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Appcolor.mehrun
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor: isSelected
                                            ? Colors.white.withOpacity(0.3)
                                            : Colors.grey[200],
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                          size: 30,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        appointmentSlot[index].doctor.name
                                            .split(' ')
                                            .take(2)
                                            .join(' '),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: List.generate(5, (starIndex) {
                                          return Icon(
                                            Icons.star,
                                            size: 8,
                                            color: isSelected
                                                ? Colors.white
                                                : const Color(0xFFFFD700),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Calendar Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: _previousMonth,
                                  icon: const Icon(
                                    Icons.chevron_left,
                                    color: Appcolor.mehrun,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _nextMonth,
                                  icon: const Icon(
                                    Icons.chevron_right,
                                    color: Appcolor.mehrun,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Calendar Grid
                        _buildCalendar(availableDates),

                        const SizedBox(height: 32),

                        // Available Slots Section
                        const Text(
                          'Available Slots',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Time Slots Grid
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 2.5,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: slotsForDay.length,
                          itemBuilder: (context, index) {
                            final slot = slotsForDay[index];
                            final isSelected = selectedSlot?.id == slot.id;
                            final isAvailable = slot.appointments.isEmpty;

                            return GestureDetector(
                              onTap: isAvailable
                                  ? () {
                                setState(() {
                                  selectedSlot = slot;
                                });
                              }
                                  : null,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: !isAvailable
                                      ? Colors.grey[200]
                                      : isSelected
                                      ? Appcolor.mehrun
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? Appcolor.mehrun
                                        : Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    _formatTime(slot.startTime),
                                    style: TextStyle(
                                      color: !isAvailable
                                          ? Colors.grey[400]
                                          : isSelected
                                          ? Colors.white
                                          : Appcolor.mehrun,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),

                // Bottom Section with booking info and buttons
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      if (selectedSlot != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Proceed with ',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${_getMonthName(selectedDate.month).substring(0, 3)} ${selectedDate.day}, ${_formatTime(selectedSlot!.startTime)}',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text(
                                ' with ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                selectedSchedule.doctor.name
                                    .split(' ')
                                    .take(2)
                                    .join(' '),
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _handleAddMoreServices,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Appcolor.mehrun),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                'Add More Services',
                                style: TextStyle(
                                  color: Appcolor.mehrun,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: selectedSlot != null
                                  ? _handleProceedBooking
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Appcolor.mehrun,
                                disabledBackgroundColor: Colors.grey[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: Consumer<ServiceProvider>(
                                builder: (context, provider, _) {
                                  if (provider.appointmentSlotsState is Success<AppointmentSlots>) {
                                    final data = (provider.appointmentSlotsState as Success<AppointmentSlots>).response.data;
                                    final int idx = selectedDoctorIndex < data.length ? selectedDoctorIndex : 0;
                                    return Text(
                                      _formatPrice(_derivePrice(data[idx])),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());

        },
      ),
    );
  }

  Widget _buildCalendar(Set<DateTime> availableDates) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDayOfMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    );
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday % 7;

    return Column(
      children: [
        // Weekday headers
        Row(
          children: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT']
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),

        const SizedBox(height: 12),

        // Calendar days
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: 42,
          // 6 weeks
          itemBuilder: (context, index) {
            final dayNumber = index - startWeekday + 1;

            if (dayNumber < 1 || dayNumber > daysInMonth) {
              return const SizedBox(); // Empty cell
            }

            final date = DateTime(
              selectedDate.year,
              selectedDate.month,
              dayNumber,
            );
            final isToday =
                date.day == now.day &&
                date.month == now.month &&
                date.year == now.year;
            final isSelected =
                date.day == selectedDate.day &&
                date.month == selectedDate.month &&
                date.year == selectedDate.year;
            final isPast = date.isBefore(
              DateTime(now.year, now.month, now.day),
            );
            final isAvailableDate = availableDates.contains(DateTime(date.year, date.month, date.day));

            return GestureDetector(
              onTap: (!isPast && isAvailableDate)
                  ? () {
                      setState(() {
                        selectedDate = date;
                        selectedSlot = null; // Reset time selection
                      });
                    }
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? Appcolor.mehrun
                      : isToday
                      ? Appcolor.mehrun.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isToday && !isSelected
                      ? Border.all(color: Appcolor.mehrun, width: 1)
                      : null,
                ),
                child: Center(
                  child: Text(
                    '$dayNumber',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected || isToday
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isPast || !isAvailableDate
                          ? Colors.grey[400]
                          : isSelected
                          ? Colors.white
                          : isToday
                          ? Appcolor.mehrun
                          : Colors.black87,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  void _previousMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, 1);
      selectedSlot = null;
    });
  }

  void _nextMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, 1);
      selectedSlot = null;
    });
  }

  void _handleAddMoreServices() {
    // Handle add more services logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add More Services clicked'),
        backgroundColor: Appcolor.mehrun,
      ),
    );
  }

  void _handleProceedBooking() {
    if (selectedSlot == null) return;

    // Handle booking logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Booking Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<ServiceProvider>(
              builder: (context, provider, _) {
                if (provider.appointmentSlotsState is Success<AppointmentSlots>) {
                  final data = (provider.appointmentSlotsState as Success<AppointmentSlots>).response.data;
                  final int index = selectedDoctorIndex < data.length ? selectedDoctorIndex : 0;
                  final name = data.isNotEmpty ? data[index].doctor.name : '';
                  return Text('Doctor: $name');
                }
                return const SizedBox.shrink();
              },
            ),
            Text(
              'Date: ${_getMonthName(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year}',
            ),
            Text('Time: ${_formatTime(selectedSlot!.startTime)}'),
            Consumer<ServiceProvider>(
              builder: (context, provider, _) {
                if (provider.appointmentSlotsState is Success<AppointmentSlots>) {
                  final data = (provider.appointmentSlotsState as Success<AppointmentSlots>).response.data;
                  final int index = selectedDoctorIndex < data.length ? selectedDoctorIndex : 0;
                  final price = _derivePrice(data[index]);
                  return Text('Amount: ${_formatPrice(price)}');
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking confirmed!'),
                  backgroundColor: Appcolor.mehrun,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Appcolor.mehrun),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Helpers
  String _toYyyyMmDd(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    return '${date.year}-$mm-$dd';
  }

  DateTime? _parseYmd(String date) {
    try {
      return DateTime.parse(date);
    } catch (_) {
      return null;
    }
  }

  String _formatTime(String time) {
    final parts = time.split(':');
    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    }
    return time;
  }

  String _formatPrice(int price) {
    return 'AED ${price.toString()}';
  }

  int _derivePrice(DoctorSchedule schedule) {
    if (schedule.services.isEmpty) return 0;
    try {
      final s = schedule.services.firstWhere((s) => s.id == widget.serviceId);
      return s.price;
    } catch (_) {
      return schedule.services.first.price;
    }
  }
}
