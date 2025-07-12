import 'package:aesthetic_clinic/views/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String selectedLanguage = 'en'; // Default selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 120),

          Text('Language',style: TextStyle(fontFamily: 'Helvetica',fontSize: 24),),
          // English Option
          const SizedBox(height: 20),

          LanguageTile(
            flagAsset: 'assets/icons/en.png',
            title: 'English',
            isSelected: selectedLanguage == 'en',
            onTap: () {
              setState(() {
                selectedLanguage = 'en';
              });
            },
          ),

          // Arabic Option
          LanguageTile(
            flagAsset: 'assets/icons/ar.png',
            title: 'Arabic',
            isSelected: selectedLanguage == 'ar',
            onTap: () {
              setState(() {
                selectedLanguage = 'ar';
              });
            },
          ),

          Spacer(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                  );                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF660033),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Select',
                  style: TextStyle(fontSize: 18,color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LanguageTile extends StatelessWidget {
  final String flagAsset;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageTile({
    required this.flagAsset,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(flagAsset),
            radius: 24,
          ),
          title: Text(title, style: TextStyle(fontSize: 18)),
          trailing: isSelected
              ? Icon(Icons.check_circle, color: Color(0xFF660033))
              : Icon(Icons.radio_button_off),
          onTap: onTap,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

