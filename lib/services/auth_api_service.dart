import '../core/constants/api_constants.dart';
import '../models/user_profile_model.dart';
import 'api_service.dart';

class AuthApiService {
  static Future<ApiResponse<UserProfileModel>> register({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) async {
    final response = await ApiService.post(
      ApiConstants.authRegister,
      body: {
        'email': email.trim(),
        'password': password,
        'name': name ?? email.split('@')[0],
        'phone': phone ?? '',
      },
    );

    if (response.success && response.data != null) {
      final token = response.data['token'] as String?;
      if (token != null) {
        ApiService.setAuthToken(token);
      }
      final userData = response.data['user'] as Map<String, dynamic>?;
      final profile = _parseUser(userData, email);
      return ApiResponse(
        success: true,
        statusCode: response.statusCode,
        message: response.message,
        data: profile,
      );
    }

    return ApiResponse(
      success: false,
      statusCode: response.statusCode,
      message: response.message ?? 'Registration failed',
      data: null,
    );
  }

  static Future<ApiResponse<UserProfileModel>> login({
    required String email,
    required String password,
  }) async {
    final response = await ApiService.post(
      ApiConstants.authLogin,
      body: {
        'email': email.trim(),
        'password': password,
      },
    );

    if (response.success && response.data != null) {
      final token = response.data['token'] as String?;
      if (token != null) {
        ApiService.setAuthToken(token);
      }
      final userData = response.data['user'] as Map<String, dynamic>?;
      final profile = _parseUser(userData, email);
      return ApiResponse(
        success: true,
        statusCode: response.statusCode,
        message: response.message,
        data: profile,
      );
    }

    return ApiResponse(
      success: false,
      statusCode: response.statusCode,
      message: response.message ?? 'Login failed',
      data: null,
    );
  }

  // Real OTP generation without Firebase
  static Future<ApiResponse<String>> sendOtp(String contact) async {
    final response = await ApiService.post(
      ApiConstants.authSendOtp,
      body: {'contact': contact.trim()},
    );

    final otpCode = response.data is Map ? response.data['otp']?.toString() : null;

    return ApiResponse(
      success: response.success,
      statusCode: response.statusCode,
      message: response.message ?? 'OTP sent',
      data: otpCode,
    );
  }

  // Real OTP verification without Firebase
  static Future<ApiResponse<UserProfileModel>> verifyOtp({
    required String contact,
    required String code,
    String? name,
  }) async {
    final response = await ApiService.post(
      ApiConstants.authVerifyOtp,
      body: {
        'contact': contact.trim(),
        'code': code.trim(),
        'name': name,
      },
    );

    if (response.success && response.data != null) {
      final token = response.data['token'] as String?;
      if (token != null) {
        ApiService.setAuthToken(token);
      }
      final userData = response.data['user'] as Map<String, dynamic>?;
      final profile = _parseUser(userData, contact);
      return ApiResponse(
        success: true,
        statusCode: response.statusCode,
        message: response.message ?? 'OTP verified successfully.',
        data: profile,
      );
    }

    return ApiResponse(
      success: false,
      statusCode: response.statusCode,
      message: response.message ?? 'Invalid OTP code.',
      data: null,
    );
  }

  // Google Login without Firebase
  static Future<ApiResponse<UserProfileModel>> googleLogin({
    required String email,
    required String name,
    String? googleId,
    String? avatarUrl,
  }) async {
    final response = await ApiService.post(
      ApiConstants.authGoogle,
      body: {
        'email': email.trim(),
        'name': name.trim(),
        'google_id': googleId ?? '',
        'avatar_url': avatarUrl ?? '',
      },
    );

    if (response.success && response.data != null) {
      final token = response.data['token'] as String?;
      if (token != null) {
        ApiService.setAuthToken(token);
      }
      final userData = response.data['user'] as Map<String, dynamic>?;
      final profile = _parseUser(userData, email);
      return ApiResponse(
        success: true,
        statusCode: response.statusCode,
        message: response.message ?? 'Google Sign-In successful.',
        data: profile,
      );
    }

    return ApiResponse(
      success: false,
      statusCode: response.statusCode,
      message: response.message ?? 'Google Sign-In failed.',
      data: null,
    );
  }

  static Future<ApiResponse<UserProfileModel>> updateProfile(UserProfileModel profile) async {
    final response = await ApiService.put(
      ApiConstants.authProfile,
      body: {
        'name': profile.name,
        'phone': profile.phone,
        'pincode': profile.pincode,
        'address': profile.address,
        'city': profile.city,
        'state': profile.state,
        'country': profile.country,
        'bank_account_number': profile.bankAccountNumber,
        'account_holder_name': profile.accountHolderName,
        'ifsc_code': profile.ifscCode,
      },
    );

    if (response.success && response.data != null) {
      final userData = response.data['user'] as Map<String, dynamic>?;
      return ApiResponse(
        success: true,
        statusCode: response.statusCode,
        message: response.message,
        data: _parseUser(userData, profile.email),
      );
    }

    return ApiResponse(
      success: false,
      statusCode: response.statusCode,
      message: response.message,
      data: null,
    );
  }

  static UserProfileModel _parseUser(Map<String, dynamic>? json, String fallbackEmail) {
    if (json == null) return UserProfileModel(email: fallbackEmail);
    return UserProfileModel(
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? fallbackEmail,
      phone: json['phone']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      country: json['country']?.toString() ?? 'India',
      bankAccountNumber: json['bank_account_number']?.toString() ?? '',
      accountHolderName: json['account_holder_name']?.toString() ?? '',
      ifscCode: json['ifsc_code']?.toString() ?? '',
    );
  }
}
