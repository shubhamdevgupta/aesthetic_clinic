import 'package:aesthetic_clinic/providers/authentication_provider.dart';
import 'package:aesthetic_clinic/providers/home_provider.dart';
import 'package:aesthetic_clinic/providers/locale_provider.dart';
import 'package:aesthetic_clinic/providers/profile_provider.dart';
import 'package:aesthetic_clinic/providers/service_provider.dart';
import 'package:aesthetic_clinic/services/LocalStorageService.dart';
import 'package:aesthetic_clinic/utils/AppConstants.dart';
import 'package:aesthetic_clinic/utils/AppRoutes.dart';
import 'package:aesthetic_clinic/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//flutter gen-l10n for generate language
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    return MaterialApp(
      locale: provider.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      navigatorKey: navigatorKey,
      title: 'Aesthetic Clinic',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Appcolor.mehrun),
        useMaterial3: true,
      ),
      initialRoute: AppConstants.navigateToSplashScreen,
      routes: AppRoutes.getRoutes(),
    );
  }
}
