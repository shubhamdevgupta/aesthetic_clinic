// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get hello => 'مرحبًا';

  @override
  String get select => 'اختر';

  @override
  String get language => 'اللغة';

  @override
  String get welcomeMessage => 'مرحبًا بك في تطبيقنا!';

  @override
  String get loginSignup => 'تسجيل الدخول أو التسجيل';

  @override
  String get mobileNumber => 'رقم الجوال';

  @override
  String get sendOtp => 'إرسال رمز التحقق';

  @override
  String get sendOtpMsg => 'سنرسل لك رسالة واتساب لتأكيد رقمك';

  @override
  String get verifyMsg => 'تحقق من رقم الهاتف';

  @override
  String get verifyCodeMsg => 'أدخل رمز التحقق الذي تم إرساله';

  @override
  String get resendNow => 'يمكنك إعادة الإرسال الآن';

  @override
  String get resendInTime => 'إعادة إرسال الرمز خلال 00 ثانية';

  @override
  String get whatsapp => 'واتساب';

  @override
  String get otpMsg => 'يرجى إدخال الرمز المرسل إلى واتساب الخاص بك';

  @override
  String get verify => 'تحقق';
}
