import 'package:flutter/material.dart';

import '../../utils/Appcolor.dart';

class GetHelpScreen extends StatelessWidget {
  const GetHelpScreen({super.key});

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
                      'assets/icons/ic_whatsapp.png',
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
                    icon: const Icon(
                      Icons.phone_outlined,
                      size: 28,
                      color: Appcolor.mehrun,
                    ),
                    titleTop: 'Connect on',
                    titleBottom: 'Call',
                    onTap: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'FAQs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            _buildFaqItem(context, 'Do you have a parking?'),
            _buildFaqItem(context, 'Can I pay with a card?'),
            _buildFaqItem(context, 'Can I reschedule?'),
            _buildFaqItem(context, 'Can I change doctor?'),
            _buildFaqItem(context, 'How to do corporate bookings?'),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Widget _buildFaqItem(BuildContext context, String question) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {},
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
          decoration: TextDecoration.underline,
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
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color:  Appcolor.mehrun.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: icon,
            ),
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


