import 'package:flutter/material.dart';
import '../../utils/Appcolor.dart';

class GetHelpScreen extends StatefulWidget {
  const GetHelpScreen({super.key});

  @override
  State<GetHelpScreen> createState() => _GetHelpScreenState();
}

class _GetHelpScreenState extends State<GetHelpScreen> {
  int? expandedIndex;

  final List<Map<String, String>> faqs = [
    {
      'q': 'Do you have a parking?',
      'a': 'Yes, we provide parking facilities for our clients at the clinic.'
    },
    {
      'q': 'Can I pay with a card?',
      'a': 'Yes, we accept all major credit and debit cards for your convenience.'
    },
    {
      'q': 'Can I reschedule?',
      'a': 'Absolutely, you can reschedule your appointment with prior notice.'
    },
    {
      'q': 'Can I change doctor?',
      'a': 'Yes, you may choose or switch your doctor based on availability.'
    },
    {
      'q': 'How to do corporate bookings?',
      'a': 'For corporate bookings, please contact our clinic support team directly.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Get Help',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _HelpActionCard(
                    icon: Image.asset(
                      'assets/icons/ic_whatsapp_help.png',
                      width: 28,
                      height: 28,
                    ),
                    titleTop: 'Connect on',
                    titleBottom: 'WhatsApp',
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _HelpActionCard(
                    icon: Image.asset(
                      'assets/icons/ic_phone_help.png',
                      width: 28,
                      height: 28,
                    ),
                    titleTop: 'Connect on',
                    titleBottom: 'Call',
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
             Text(
              'FAQs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Appcolor.mehrun,
              ),
            ),
            const SizedBox(height: 8),

            // FAQ list
            Column(
              children: List.generate(faqs.length, (index) {
                final faq = faqs[index];
                final isExpanded = expandedIndex == index;

                return Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          faq['q']!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 20,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          setState(() {
                            expandedIndex = isExpanded ? null : index;
                          });
                        },
                      ),
                      if (isExpanded)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            faq['a']!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              height: 1.4,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFooterLink('Privacy Policy', () {}),
                _buildFooterLink('Terms & Conditions', () {}),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'App Version 1.0.0',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterLink(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(
          color: Appcolor.mehrun,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _HelpActionCard extends StatelessWidget {
  final Widget icon;
  final String titleTop;
  final String titleBottom;
  final VoidCallback onTap;

  const _HelpActionCard({
    required this.icon,
    required this.titleTop,
    required this.titleBottom,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 10),
            Text(
              titleTop,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            Text(
              titleBottom,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
