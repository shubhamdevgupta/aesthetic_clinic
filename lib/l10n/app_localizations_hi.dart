// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get hello => 'नमस्ते';

  @override
  String get select => 'चुनें';

  @override
  String get language => 'भाषा';

  @override
  String get welcomeMessage => 'हमारे ऐप में आपका स्वागत है!';

  @override
  String get loginSignup => 'लॉगिन या साइन अप करें';

  @override
  String get mobileNumber => 'मोबाइल नंबर';

  @override
  String get sendOtp => 'ओटीपी भेजें';

  @override
  String get sendOtpMsg => 'हम आपके नंबर की पुष्टि के लिए व्हाट्सएप संदेश भेजेंगे';

  @override
  String get verifyMsg => 'फोन नंबर सत्यापित करें';

  @override
  String get verifyCodeMsg => 'उस सत्यापन कोड को दर्ज करें जो भेजा गया था';

  @override
  String get resendNow => 'अब पुनः भेजें';

  @override
  String get resendInTime => '00 में कोड पुनः भेजें';

  @override
  String get whatsapp => 'व्हाट्सएप';

  @override
  String get otpMsg => 'कृपया व्हाट्सएप पर भेजा गया एक बार का कोड दर्ज करें';

  @override
  String get verify => 'सत्यापित करें';
}
