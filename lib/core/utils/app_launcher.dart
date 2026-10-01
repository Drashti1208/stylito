import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class AppLauncher {
  /// Open user's default email client
  static Future<bool> launchEmail({
    String email = 'support@stylito.com',
    String subject = 'Stylito Support Inquiry',
    String body = '',
  }) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
        if (body.isNotEmpty) 'body': body,
      },
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        return await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback for web / platforms where canLaunchUrl is restricted
        return await launchUrl(emailUri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      debugPrint('Error launching email client: $e');
      return false;
    }
  }

  /// Open external URL in browser
  static Future<bool> launchWebUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
    return false;
  }

  /// Call phone number
  static Future<bool> launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching phone: $e');
    }
    return false;
  }
}
