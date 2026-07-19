
import 'package:caiemca_app/l10n/app_localizations.dart';
import 'package:caiemca_app/pages/auth/login_page.dart';
import 'package:caiemca_app/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moment_dart/moment_dart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  // Detectar idioma del sistema
  final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

  // Configurar Moment según idioma
  if (systemLocale.languageCode == 'es') {
    Moment.setGlobalLocalization(MomentLocalizations.es());
  } else {
    Moment.setGlobalLocalization(MomentLocalizations.enUS());
  }
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 👈 transparente
      statusBarIconBrightness: Brightness.dark, // íconos oscuros (Android)
      statusBarBrightness: Brightness.light, // íconos claros (iOS)
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: kAppName,
      locale:  WidgetsBinding.instance.platformDispatcher.locale,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
         AppLocalizations.delegate, 
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // inglés
        Locale('es'), // español
      ],
      theme: ThemeData(
        useMaterial3: false,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter',
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          titleTextStyle: TextStyle(color: kPrimaryColor),
          iconTheme: IconThemeData(color: kPrimaryColor),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: kPrimaryColor,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: kBodyTextColor,
          ),
          titleSmall: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: kPrimaryColor,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: kBodyTextColor),
          bodyMedium: TextStyle(fontSize: 14, color: kBodyTextColor),
          bodySmall: TextStyle(fontSize: 12, color: kBodyTextColor),
        ),

        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: kPrimaryColor),

          hintStyle: TextStyle(color: kBodyTextColor),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
            borderSide: BorderSide(color: kSecondaryColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
            borderSide: BorderSide(color: kSecondaryColor),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange),
      ),
      home: LoginPage(),
    );
  }
}
