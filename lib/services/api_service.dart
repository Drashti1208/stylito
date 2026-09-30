import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final int statusCode;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    required this.statusCode,
  });
}

class ApiService {
  static String? _authToken;

  static void setAuthToken(String? token) {
    _authToken = token;
  }

  static String? get authToken => _authToken;

  static Map<String, String> _buildHeaders(Map<String, String>? extra) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_authToken != null && _authToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    if (extra != null) {
      headers.addAll(extra);
    }
    return headers;
  }

  static Future<ApiResponse<dynamic>> get(
    String url, {
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: _buildHeaders(headers))
          .timeout(timeout);

      final decoded = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      final isSuccess = response.statusCode >= 200 && response.statusCode < 300;

      return ApiResponse(
        success: isSuccess,
        statusCode: response.statusCode,
        data: decoded,
        message: decoded is Map ? decoded['message'] as String? : null,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'Network error or server unreachable: $e',
      );
    }
  }

  static Future<ApiResponse<dynamic>> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
    Duration timeout = const Duration(seconds: 12),
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: _buildHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      final decoded = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      final isSuccess = response.statusCode >= 200 && response.statusCode < 300;

      return ApiResponse(
        success: isSuccess,
        statusCode: response.statusCode,
        data: decoded,
        message: decoded is Map ? decoded['message'] as String? : null,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'Network error: $e',
      );
    }
  }

  static Future<ApiResponse<dynamic>> put(
    String url, {
    Map<String, String>? headers,
    dynamic body,
    Duration timeout = const Duration(seconds: 12),
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse(url),
            headers: _buildHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      final decoded = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      final isSuccess = response.statusCode >= 200 && response.statusCode < 300;

      return ApiResponse(
        success: isSuccess,
        statusCode: response.statusCode,
        data: decoded,
        message: decoded is Map ? decoded['message'] as String? : null,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'Network error: $e',
      );
    }
  }
}
