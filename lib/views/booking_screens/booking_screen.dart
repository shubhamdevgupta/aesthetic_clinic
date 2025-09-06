import 'package:aesthetic_clinic/views/booking_screens/booking_slot_screen.dart';
import 'package:aesthetic_clinic/views/booking_screens/past_booking_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/Appcolor.dart';
import '../profile_screens/get_help_screen.dart';


const Color kPrimaryColor = Appcolor.mehrun;
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
                    InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GetHelpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Need Help?',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
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
                    BookingSlotScreen(),
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
