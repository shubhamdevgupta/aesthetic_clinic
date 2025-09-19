import 'package:aesthetic_clinic/models/appointment/booking_response.dart';
import 'package:aesthetic_clinic/providers/service_provider.dart';
import 'package:aesthetic_clinic/services/ui_state.dart';
import 'package:aesthetic_clinic/utils/Appcolor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../doctor/doctor_review_screen.dart';
import 'booking_tab_screen.dart';

class PastBookingsScreen extends StatefulWidget {
  const PastBookingsScreen({super.key});

  @override
  State<PastBookingsScreen> createState() => _PastBookingsScreenState();
}

class _PastBookingsScreenState extends State<PastBookingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceProvider>(context, listen: false)
          .getBookingList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Consumer<ServiceProvider>(
      builder: (context, provider, _) {
        final state = provider.bookingState;

        if (state is Loading) {
          return _ShimmerBookingList(width: width, height: height);
        }

        if (state is Error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: width * 0.15, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                Text("", style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => provider.getBookingList(context),
                  child: const Text('Retry'),
                )
              ],
            ),
          );
        }

        final bookings = (state as Success<BookingResponse>).response.data;
        final past = bookings.where((b) => _isPast(b)).toList();

        if (past.isEmpty) {
          return const _EmptyBookingsView(
            title: "You Don't have any Past Bookings",
            showPrimaryAction: true,
          );
        }

        return RefreshIndicator(
          onRefresh: ()async{
           await provider.getBookingList(context,forceRefresh: true);
          },
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.04, vertical: height * 0.015),
            itemCount: past.length,
            itemBuilder: (context, index) {
              final b = past[index];
              return _BookingCard(
                isUpcoming: false,
                title: b.service.name,
                minutes: b.doctorSlot.duration,
                subtitle: b.purpose,
                dateLine:
                '${_formatBookingDate(b.date)} ${b.doctorSlot.startTime} with ${b.doctor.title} ${b.doctor.name}',
                bookingId: b.id,
                onPrimaryAction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorReviewScreen(
                        doctorId: b.doctorId, // just pass id
                      ),
                    ),
                  );
                },
                onSecondaryAction: () {
                  print("Book Again Clicked");
                },
              );
            },
          ),
        );
      },
    );
  }

  bool _isPast(BookingData b) {
    try {
      final d = DateTime.tryParse(b.date);
      if (d != null) {
        return d.isBefore(DateTime.now());
      }
    } catch (_) {}
    return b.status != 1;
  }

  List<String> _monthShort = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  String _formatBookingDate(String iso) {
    final d = DateTime.tryParse(iso);
    if (d == null) return iso;
    final month = _monthShort[d.month - 1];
    return '$month ${d.day}';
  }
}

class _ShimmerBookingList extends StatelessWidget {
  final double width;
  final double height;

  const _ShimmerBookingList({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding:
      EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.015),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: height * 0.015),
            padding: EdgeInsets.all(width * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            height: height * 0.18,
          ),
        );
      },
    );
  }
}

class _EmptyBookingsView extends StatelessWidget {
  final String title;
  final bool showPrimaryAction;
  final String primaryActionLabel;
  final VoidCallback? onPrimaryAction;

  const _EmptyBookingsView({
    required this.title,
    this.showPrimaryAction = false,
    this.primaryActionLabel = '',
    this.onPrimaryAction,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final double imageSize = width * 0.55;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: Column(
          children: [
            SizedBox(height: height * 0.12),
            Center(
              child: Image.asset(
                'assets/icons/ic_skin_booking.png',
                width: imageSize,
                height: imageSize,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: height * 0.02),
            Text(title, textAlign: TextAlign.center, style: kEmptyTitleStyle),
            SizedBox(height: height * 0.03),
            if (showPrimaryAction)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: kPrimaryColor,
                    padding: EdgeInsets.symmetric(vertical: height * 0.018),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onPrimaryAction,
                  child: const Text(
                    'Explore Our Services',
                    style: TextStyle(
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: height * 0.015),
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
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
            style: TextStyle(color: Colors.grey[600], fontSize: width * 0.03),
          ),
          SizedBox(height: height * 0.008),
          Text(
            title,
            style:
            TextStyle(fontSize: width * 0.045, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: height * 0.006),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: width * 0.032,
              color: kCardSubtitle,
              height: 1.4,
            ),
          ),
          SizedBox(height: height * 0.012),
          Text(
            dateLine,
            style: TextStyle(
              fontSize: width * 0.034,
              fontWeight: FontWeight.w700,
              color: kPrimaryColor,
            ),
          ),
          SizedBox(height: height * 0.02),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: kPrimaryColor,
                    padding: EdgeInsets.symmetric(vertical: height * 0.016),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onPrimaryAction,
                  child: Text(
                    isUpcoming ? 'Reschedule' : 'Submit Review',
                    style: TextStyle(color: Appcolor.white),
                  ),
                ),
              ),
              SizedBox(width: width * 0.03),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[300]!),
                    padding: EdgeInsets.symmetric(vertical: height * 0.016),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    foregroundColor:
                    isUpcoming ? Colors.black : kPrimaryColor,
                  ),
                  onPressed: onSecondaryAction,
                  icon: Icon(
                    isUpcoming ? Icons.cancel_outlined : Icons.refresh,
                    size: width * 0.045,
                  ),
                  label: Text(
                      isUpcoming ? 'Cancel Booking' : 'Book Again',
                      style: TextStyle(fontSize: width * 0.032)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
