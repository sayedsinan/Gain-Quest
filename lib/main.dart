import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gain_quest/firebase_options.dart';
import 'package:gain_quest/presentation/screens/auth/login_page.dart';
import 'package:gain_quest/presentation/screens/splash/splash_screen.dart';
import 'package:get/get.dart';
import 'package:gain_quest/core/theme/app_theme.dart';
import 'package:gain_quest/presentation/controllers/auth_controller.dart';
import 'package:gain_quest/presentation/controllers/theme_controller.dart';
import 'package:gain_quest/presentation/screens/onboarding/onboarding_screen.dart';

import 'package:gain_quest/presentation/screens/home/main_navigation.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:gain_quest/data/sources/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    // webRecaptchaSiteKey: 'your-site-key', // only for web
    androidProvider: AndroidProvider.playIntegrity, // or safetyNet
    appleProvider: AppleProvider.deviceCheck,
  );

  Get.put(FirebaseService());
  Get.put(ThemeController());
  Get.put(AuthController());
 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sales Bets',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: Get.find<ThemeController>().themeMode,
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/onboarding', page: () => const OnboardingScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/home', page: () => MainNavigation()),
      ],
    );
  }
}

