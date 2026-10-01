import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/app_bindings.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'views/landing/landing_page_screen.dart';
import 'views/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StylishApp());
}

class StylishApp extends StatelessWidget {
  const StylishApp({super.key});

  /// Determines whether the runtime environment is Desktop or Web
  static bool get isWebOrDesktop {
    if (kIsWeb) return true;
    try {
      return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Stylito - Fashion at Your Fingertips',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.root,
      routes: AppRoutes.routes,
    );
  }
}

/// Automatically serves the Landing Page for Web/Desktop and
/// the Mobile Application (Splash -> Onboarding -> App) for Phones/Emulators.
class AppPlatformRouter extends StatelessWidget {
  const AppPlatformRouter({super.key});

  @override
  Widget build(BuildContext context) {
    // If Web or Desktop platform, launch the rich GetX Landing Page
    if (StylishApp.isWebOrDesktop) {
      // On wide screens or web/desktop, show the Landing Page
      final isWideScreen = MediaQuery.of(context).size.width >= 768;
      if (isWideScreen || kIsWeb) {
        return const LandingPageScreen();
      }
    }

    // Default mobile phone experience
    return const SplashScreen();
  }
}
