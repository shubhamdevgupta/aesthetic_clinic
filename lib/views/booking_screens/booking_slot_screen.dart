import 'package:flutter/material.dart';

import '../../utils/Appcolor.dart';

class BookingSlotScreen extends StatefulWidget {
  const BookingSlotScreen({super.key});

  @override
  State<BookingSlotScreen> createState() => _BookingSlotScreenState();
}

class _BookingSlotScreenState extends State<BookingSlotScreen> {
  int selectedDoctorIndex = 1; // Default selected (middle doctor)
  DateTime selectedDate = DateTime.now();
  String? selectedTimeSlot;

  final List<Map<String, dynamic>> doctors = [
    {
      'name': 'Dr. Loma Zaher Aldeen',
      'rating': 4.5,
      'image': 'assets/images/doctor1.jpg', // Replace with your asset path
    },
    {
      'name': 'Dr. Loma Zaher Aldeen',
      'rating': 4.8,
      'image': 'assets/images/doctor2.jpg', // Replace with your asset path
    },
    {
      'name': 'Dr. Loma Zaher Aldeen',
      'rating': 4.7,
      'image': 'assets/images/doctor3.jpg', // Replace with your asset path
    },
    {
      'name': 'Dr. Sarah Ahmed',
      'rating': 4.9,
      'image': 'assets/images/doctor4.jpg', // Replace with your asset path
    },
  ];

  final List<String> timeSlots = [
    '10:00', '11:00', '12:00',
    '13:00', '14:00', '15:00'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                      itemCount: doctors.length,
                      itemBuilder: (context, index) {
                        final isSelected = selectedDoctorIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDoctorIndex = index;
                              selectedTimeSlot = null; // Reset time selection
                            });
                          },
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected ?  Appcolor.mehrun : Colors.grey[100],
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
                                  doctors[index]['name'].toString().split(' ').take(2).join(' '),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white : Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(5, (starIndex) {
                                    return Icon(
                                      Icons.star,
                                      size: 8,
                                      color: isSelected ? Colors.white : const Color(0xFFFFD700),
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
                            icon: const Icon(Icons.chevron_left, color: Appcolor.mehrun),
                          ),
                          IconButton(
                            onPressed: _nextMonth,
                            icon: const Icon(Icons.chevron_right, color: Appcolor.mehrun),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Calendar Grid
                  _buildCalendar(),

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
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: timeSlots.length,
                    itemBuilder: (context, index) {
                      final timeSlot = timeSlots[index];
                      final isSelected = selectedTimeSlot == timeSlot;
                      final isAvailable = index != 1 ; // Mock availability

                      return GestureDetector(
                        onTap: isAvailable ? () {
                          setState(() {
                            selectedTimeSlot = timeSlot;
                          });
                        } : null,
                        child: Container(
                          decoration: BoxDecoration(
                            color: !isAvailable
                                ? Colors.grey[200]
                                : isSelected
                                ?  Appcolor.mehrun
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ?  Appcolor.mehrun : Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              timeSlot,
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
                if (selectedTimeSlot != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                          '${_getMonthName(selectedDate.month).substring(0, 3)} ${selectedDate.day}, ${selectedTimeSlot}',
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
                          doctors[selectedDoctorIndex]['name'].toString().split(' ').take(2).join(' '),
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
                        onPressed: selectedTimeSlot != null ? _handleProceedBooking : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  Appcolor.mehrun,
                          disabledBackgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'AED 599.00',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDayOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday % 7;

    return Column(
      children: [
        // Weekday headers
        Row(
          children: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT']
              .map((day) => Expanded(
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
          ))
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
          itemCount: 42, // 6 weeks
          itemBuilder: (context, index) {
            final dayNumber = index - startWeekday + 1;

            if (dayNumber < 1 || dayNumber > daysInMonth) {
              return const SizedBox(); // Empty cell
            }

            final date = DateTime(selectedDate.year, selectedDate.month, dayNumber);
            final isToday = date.day == now.day &&
                date.month == now.month &&
                date.year == now.year;
            final isSelected = date.day == selectedDate.day &&
                date.month == selectedDate.month &&
                date.year == selectedDate.year;
            final isPast = date.isBefore(DateTime(now.year, now.month, now.day));

            return GestureDetector(
              onTap: !isPast ? () {
                setState(() {
                  selectedDate = date;
                  selectedTimeSlot = null; // Reset time selection
                });
              } : null,
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ?  Appcolor.mehrun
                      : isToday
                      ?  Appcolor.mehrun.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isToday && !isSelected
                      ? Border.all(color:  Appcolor.mehrun, width: 1)
                      : null,
                ),
                child: Center(
                  child: Text(
                    '$dayNumber',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected || isToday ? FontWeight.w600 : FontWeight.w500,
                      color: isPast
                          ? Colors.grey[400]
                          : isSelected
                          ? Colors.white
                          : isToday
                          ?  Appcolor.mehrun
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
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  void _previousMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, 1);
      selectedTimeSlot = null;
    });
  }

  void _nextMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, 1);
      selectedTimeSlot = null;
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
    if (selectedTimeSlot == null) return;

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
            Text('Doctor: ${doctors[selectedDoctorIndex]['name']}'),
            Text('Date: ${_getMonthName(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year}'),
            Text('Time: $selectedTimeSlot'),
            const Text('Amount: AED 599.00'),
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
            style: ElevatedButton.styleFrom(
              backgroundColor:  Appcolor.mehrun,
            ),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}