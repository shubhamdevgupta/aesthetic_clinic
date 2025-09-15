import 'package:aesthetic_clinic/views/auth/send_otp_screen.dart';
import 'package:aesthetic_clinic/views/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/locale_provider.dart';
import '../../utils/Appcolor.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String selectedLanguage = 'en'; // Default selected

  @override
  Widget build(BuildContext context) {
    AppLocalizations localization = AppLocalizations.of(context)!;
    LocaleProvider localeProvider = Provider.of<LocaleProvider>(context);
    String selectedLanguage = localeProvider.locale.languageCode;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            localization.language,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          LanguageTile(
            flagAsset: 'assets/icons/en.png',
            title: 'English',
            isSelected: selectedLanguage == 'en',
            onTap: () => localeProvider.setLocale(const Locale('en')),
          ),
          LanguageTile(
            flagAsset: 'assets/icons/en.png',
            title: 'हिंदी',
            isSelected: selectedLanguage == 'hi',
            onTap: () => localeProvider.setLocale(const Locale('hi')),
          ),
          // Arabic Option
          LanguageTile(
            flagAsset: 'assets/icons/ar.png',
            title: 'العربية',
            isSelected: selectedLanguage == 'ar',
            onTap: () => localeProvider.setLocale(const Locale('ar')),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 0, 24, 56),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SendOtpScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Appcolor.mehrun,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              localization.select,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
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
              ? Icon(Icons.check_circle, color: Appcolor.mehrun)
              : Icon(Icons.radio_button_off),
          onTap: onTap,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(color: Colors.grey.shade300, thickness: 1),
        ),
      ],
    );
  }
}
