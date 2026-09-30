import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class ApiConstants {
  // Configurable base URL
  static String? _customBaseUrl;

  static void setBaseUrl(String url) {
    _customBaseUrl = url;
  }

  static String get baseUrl {
    if (_customBaseUrl != null && _customBaseUrl!.isNotEmpty) {
      return _customBaseUrl!;
    }
    // On web or desktop, localhost is directly accessible
    if (kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return 'http://localhost:5000/api';
    }
    // On Android Emulator, 10.0.2.2 maps to host localhost
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000/api';
    }
    // Default fallback (e.g. iOS simulator)
    return 'http://localhost:5000/api';
  }

  // Auth endpoints
  static String get authRegister => '$baseUrl/auth/register';
  static String get authLogin => '$baseUrl/auth/login';
  static String get authProfile => '$baseUrl/auth/profile';
  static String get authSendOtp => '$baseUrl/auth/send-otp';
  static String get authVerifyOtp => '$baseUrl/auth/verify-otp';
  static String get authGoogle => '$baseUrl/auth/google';

  // Product endpoints
  static String get products => '$baseUrl/products';
  static String get productDeals => '$baseUrl/products/deals';
  static String get productTrending => '$baseUrl/products/trending';
  static String productCategory(String slug) => '$baseUrl/products/category/$slug';
  static String productDetails(String id) => '$baseUrl/products/$id';

  // Categories
  static String get categories => '$baseUrl/categories';

  // Orders
  static String get orders => '$baseUrl/orders';

  // Customer Inquiries / Direct Messages
  static String get inquiries => '$baseUrl/inquiries';
  static String get inquiriesStream => '$baseUrl/inquiries/stream';
}
