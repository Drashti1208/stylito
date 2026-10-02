import 'package:flutter/material.dart';
import '../../views/auth/forgot_password_screen.dart';
import '../../views/auth/otp_verification_screen.dart';
import '../../views/auth/sign_in_screen.dart';
import '../../views/auth/sign_up_screen.dart';
import '../../views/cart/checkout_screen.dart';
import '../../views/cart/payment_screen.dart';
import '../../views/cart/shopping_bag_screen.dart';
import '../../views/catalog/beauty_products_screen.dart';
import '../../views/catalog/fashion_products_screen.dart';
import '../../views/catalog/flat_and_heels_screen.dart';
import '../../views/catalog/kids_products_screen.dart';
import '../../views/catalog/mens_products_screen.dart';
import '../../views/catalog/trending_products_screen.dart';
import '../../views/catalog/womens_products_screen.dart';
import '../../views/landing/contact_support_screen.dart';
import '../../views/landing/landing_page_screen.dart';
import '../../views/main_navigation_screen.dart';
import '../../views/onboarding/get_started_screen.dart';
import '../../views/onboarding/onboarding_screen.dart';
import '../../main.dart';
import '../../views/profile/profile_screen.dart';
import '../../views/splash/splash_screen.dart';

class AppRoutes {
  static const String root = '/';
  static const String splash = '/splash';
  static const String landing = '/landing';
  static const String contactSupport = '/contact-support';
  static const String onboarding = '/onboarding';
  static const String getStarted = '/get-started';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String main = '/main';
  static const String catalog = '/catalog';
  static const String flatAndHeels = '/flat-and-heels';
  static const String beauty = '/beauty';
  static const String kids = '/kids';
  static const String fashion = '/fashion';
  static const String mens = '/mens';
  static const String womens = '/womens';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String payment = '/payment';
  static const String profile = '/profile';
  static const String website = '/website';

  static Map<String, WidgetBuilder> get routes => {
        root: (context) => const AppPlatformRouter(),
        splash: (context) => const SplashScreen(),
        landing: (context) => const LandingPageScreen(),
        contactSupport: (context) => const ContactSupportScreen(),
        onboarding: (context) => const OnboardingScreen(),
        getStarted: (context) => const GetStartedScreen(),
        signIn: (context) => const SignInScreen(),
        signUp: (context) => const SignUpScreen(),
        forgotPassword: (context) => const ForgotPasswordScreen(),
        otpVerification: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return OtpVerificationScreen(
            contact: args?['contact'] as String? ?? '',
            initialOtp: args?['otp'] as String?,
          );
        },
        main: (context) => const MainNavigationScreen(),
        catalog: (context) => const TrendingProductsScreen(),
        flatAndHeels: (context) => const FlatAndHeelsScreen(),
        beauty: (context) => const BeautyProductsScreen(),
        kids: (context) => const KidsProductsScreen(),
        fashion: (context) => const FashionProductsScreen(),
        mens: (context) => const MensProductsScreen(),
        womens: (context) => const WomensProductsScreen(),
        cart: (context) => const ShoppingBagScreen(showBackButton: true),
        checkout: (context) => const CheckoutScreen(),
        payment: (context) => const PaymentScreen(),
        profile: (context) => const ProfileScreen(showBackButton: true),
        website: (context) => const LandingPageScreen(),
      };
}
