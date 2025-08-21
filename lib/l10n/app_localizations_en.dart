// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello => 'Hello';

  @override
  String get select => 'Select';

  @override
  String get language => 'Language';

  @override
  String get welcomeMessage => 'Welcome to our app!';

  @override
  String get loginSignup => 'Login or Signup';

  @override
  String get mobileNumber => 'Mobile Number';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get sendOtpMsg => 'We\'ll whatsapp you to confirm your number';

  @override
  String get verifyMsg => 'Verify phone number';

  @override
  String get verifyCodeMsg => 'Enter Verification code that was send to';

  @override
  String get resendNow => 'You can resend now';

  @override
  String get resendInTime => 'Resend code in 00';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get otpMsg => 'Please enter the one-time code sent to your WhatsApp';

  @override
  String get verify => 'Verify';
}
