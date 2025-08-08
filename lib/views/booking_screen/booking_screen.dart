import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFF660033);
const Color kUnselectedTabText = Color(0xFF9E9E9E);
const Color kCardSubtitle = Color(0xFF707070);
const double kTabHeight = 44;

const TextStyle kHeaderTitleStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700,
  color: kPrimaryColor,
);

const TextStyle kEmptyTitleStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Color(0xFF9E9E9E),
);

const TextStyle kEmptySubtitleStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: Color(0xFF9E9E9E),
);

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Bookings', style: kHeaderTitleStyle),
                    // Optional help text to match visual balance
                    Text(
                      'Need Help?',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: kTabHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kPrimaryColor.withOpacity(0.2)),
                  ),
                  child: TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: kUnselectedTabText,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
                    indicator: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: const EdgeInsets.all(4),
                    tabs: const [
                      Tab(text: 'Upcoming'),
                      Tab(text: 'Past'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Content
              const Expanded(
                child: TabBarView(
                  children: [
                    UpcomingBookingsScreen(),
                    PastBookingsScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpcomingBookingsScreen extends StatelessWidget {
  final bool hasBookings;

  const UpcomingBookingsScreen({super.key, this.hasBookings = false});

  @override
  Widget build(BuildContext context) {
    if (!hasBookings) {
      return _EmptyBookingsView(
        title: "You Don't have any Upcoming Bookings",
        showPrimaryAction: true,
        primaryActionLabel: 'Explore Our Services',
        onPrimaryAction: () {},
      );
    }

    // Placeholder for future list of upcoming bookings
    return _SingleBookingCard(
      isUpcoming: true,
      onPrimaryAction: () {},
      onSecondaryAction: () {},
    );
  }
}

class PastBookingsScreen extends StatelessWidget {
  final bool hasBookings;

  const PastBookingsScreen({super.key, this.hasBookings = false});

  @override
  Widget build(BuildContext context) {
    if (!hasBookings) {
      return _EmptyBookingsView(
        title: "You Don't have any Past Bookings",
        showPrimaryAction: false,
      );
    }

    // Placeholder for past booking card
    return _SingleBookingCard(
      isUpcoming: false,
      onPrimaryAction: () {},
      onSecondaryAction: () {},
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
            Text(
              title,
              textAlign: TextAlign.center,
              style: kEmptyTitleStyle,
            ),
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

class _SingleBookingCard extends StatelessWidget {
  final bool isUpcoming;
  final VoidCallback onPrimaryAction;
  final VoidCallback onSecondaryAction;

  const _SingleBookingCard({
    required this.isUpcoming,
    required this.onPrimaryAction,
    required this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            _BookingCard(
              isUpcoming: isUpcoming,
              onPrimaryAction: onPrimaryAction,
              onSecondaryAction: onSecondaryAction,
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final bool isUpcoming;
  final VoidCallback onPrimaryAction;
  final VoidCallback onSecondaryAction;

  const _BookingCard({
    required this.isUpcoming,
    required this.onPrimaryAction,
    required this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('30 Mins', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text('Booking ID: A292AM', style: TextStyle(color: Colors.grey[400], fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Summer Hydration Drip',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text(
            'A Little Enhancement, A Lot of Confidence\nwith Expert Injectables in Dubai',
            style: TextStyle(fontSize: 12, color: kCardSubtitle, height: 1.4),
          ),
          const SizedBox(height: 10),
          const Text(
            'Aug 6, 11AM with Dr. Loma',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kPrimaryColor),
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
                  child: Text(isUpcoming ? 'Reschedule' : 'Submit Review'),
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
                    foregroundColor: isUpcoming ? Colors.black : kPrimaryColor,
                  ),
                  onPressed: onSecondaryAction,
                  icon: Icon(isUpcoming ? Icons.cancel_outlined : Icons.refresh, size: 18),
                  label: Text(isUpcoming ? 'Cancel Booking' : 'Book Again'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
