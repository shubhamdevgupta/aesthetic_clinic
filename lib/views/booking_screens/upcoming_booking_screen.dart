import 'package:aesthetic_clinic/models/appointment/booking_response.dart';
import 'package:aesthetic_clinic/providers/service_provider.dart';
import 'package:aesthetic_clinic/services/ui_state.dart';
import 'package:aesthetic_clinic/utils/Appcolor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'booking_tab_screen.dart';

class UpcomingBookingScreen extends StatefulWidget {
  const UpcomingBookingScreen({super.key});

  @override
  State<UpcomingBookingScreen> createState() => _UpcomingBookingScreenState();
}

class _UpcomingBookingScreenState extends State<UpcomingBookingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceProvider>(context, listen: false).getBookingList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceProvider>(
      builder: (context, provider, _) {
        final state = provider.bookingState;

        if (state is Loading || state is Idle) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is Error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 56, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                Text("", style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => provider.getBookingList(),
                  child: const Text('Retry'),
                )
              ],
            ),
          );
        }

        final bookings = (state as Success<BookingResponse>).response.data;
        final upcoming = bookings.where((b) => _isUpcoming(b)).toList();

        if (upcoming.isEmpty) {
          return const _EmptyBookingsView(
            title: "You Don't have any Upcoming Bookings",
            showPrimaryAction: true,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: upcoming.length,
          itemBuilder: (context, index) {
            final b = upcoming[index];
            return _BookingCard(
              isUpcoming: true,
              title: b.service.name,
              minutes: b.doctorSlot.duration,
              subtitle:b.purpose,
              dateLine:
                  _formatBookingDate(b.date) + ' with ${b.doctor.title} ${b.doctor.name}',
              bookingId: b.id,
              onPrimaryAction: () {},
              onSecondaryAction: () {},
            );
          },
        );
      },
    );
  }

  bool _isUpcoming(BookingData b) {
    // Consider status 1 as upcoming; adjust if your API differs
    try {
      final d = DateTime.tryParse(b.date);
      if (d != null) {
        return d.isAfter(DateTime.now());
      }
    } catch (_) {}
    return b.status == 1;
  }

  String _formatBookingDate(String iso) {
    final d = DateTime.tryParse(iso);
    if (d == null) return iso;
    final month = _monthShort[d.month - 1];
    final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final ampm = d.hour >= 12 ? 'PM' : 'AM';
    final minute = d.minute.toString().padLeft(2, '0');
    return '$month ${d.day}, $hour:$minute$ampm';
  }
}

const List<String> _monthShort = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

class _EmptyBookingsView extends StatelessWidget {
  final String title;
  final bool showPrimaryAction;
  final String primaryActionLabel;
  final VoidCallback? onPrimaryAction;

  const _EmptyBookingsView({
    required this.title,
    this.showPrimaryAction = false,
    this.primaryActionLabel = 'Explore Our Services',
    this.onPrimaryAction,
  });

  @override
  Widget build(BuildContext context) {
    final double imageSize = MediaQuery.of(context).size.width * 0.55;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.12),
            Center(
              child: Image.asset(
                'assets/icons/ic_skin_booking.png',
                width: imageSize,
                height: imageSize,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Text(title, textAlign: TextAlign.center, style: kEmptyTitleStyle),
            const SizedBox(height: 24),
            if (showPrimaryAction)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onPrimaryAction,
                  child: Text(
                    primaryActionLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final bool isUpcoming;
  final String title;
  final int minutes;
  final String subtitle;
  final String dateLine;
  final String bookingId;
  final VoidCallback onPrimaryAction;
  final VoidCallback onSecondaryAction;

  const _BookingCard({
    required this.isUpcoming,
    required this.title,
    required this.minutes,
    required this.subtitle,
    required this.dateLine,
    required this.bookingId,
    required this.onPrimaryAction,
    required this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$minutes Mins',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: kCardSubtitle, height: 1.4),
          ),
          const SizedBox(height: 10),
          Text(
            dateLine,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onPrimaryAction,
                  child:  Text('Reschedule',style: TextStyle(color: Appcolor.white),),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: onSecondaryAction,
                  icon: const Icon(Icons.cancel_outlined, size: 18),
                  label: const Text('Cancel Booking'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
