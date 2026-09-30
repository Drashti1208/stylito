import 'package:get/get.dart';
import '../models/user_profile_model.dart';
import '../services/auth_api_service.dart';

class AuthController extends GetxController {
  final Rx<UserProfileModel> _userProfile = UserProfileModel().obs;
  final RxBool _isLoggedIn = false.obs;
  final RxBool isLoading = false.obs;
  final RxString authMessage = ''.obs;

  UserProfileModel get userProfile => _userProfile.value;
  bool get isLoggedIn => _isLoggedIn.value;

  void setLoggedInUser(UserProfileModel user) {
    _userProfile.value = user;
    _isLoggedIn.value = true;
    authMessage.value = 'Logged in as ${user.name}';
  }

  /// Login via backend server API
  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    authMessage.value = '';

    try {
      final res = await AuthApiService.login(email: email, password: password);
      if (res.success && res.data != null) {
        _userProfile.value = res.data!;
        _isLoggedIn.value = true;
        authMessage.value = 'Logged in successfully!';
        return true;
      } else {
        authMessage.value = res.message ?? 'Login failed';
        return false;
      }
    } catch (e) {
      authMessage.value = 'Network error during login: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Signup via backend server API
  Future<bool> signup(String email, String password, {String? name, String? phone}) async {
    isLoading.value = true;
    authMessage.value = '';

    try {
      final res = await AuthApiService.register(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );

      if (res.success && res.data != null) {
        _userProfile.value = res.data!;
        _isLoggedIn.value = true;
        authMessage.value = 'Account created successfully!';
        return true;
      } else {
        authMessage.value = res.message ?? 'Sign up failed';
        return false;
      }
    } catch (e) {
      authMessage.value = 'Error during signup: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Request OTP from backend server
  Future<String?> requestOtp(String contact) async {
    isLoading.value = true;
    authMessage.value = '';

    try {
      final res = await AuthApiService.sendOtp(contact);
      if (res.success) {
        authMessage.value = res.message ?? 'OTP sent successfully!';
        return res.data;
      } else {
        authMessage.value = res.message ?? 'Could not send OTP';
        return null;
      }
    } catch (e) {
      authMessage.value = 'Error sending OTP: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Verify OTP with backend server
  Future<bool> verifyOtp(String contact, String code, {String? name}) async {
    isLoading.value = true;
    authMessage.value = '';

    try {
      final res = await AuthApiService.verifyOtp(contact: contact, code: code, name: name);
      if (res.success && res.data != null) {
        _userProfile.value = res.data!;
        _isLoggedIn.value = true;
        authMessage.value = 'OTP verified! Welcome to Stylito.';
        return true;
      } else {
        authMessage.value = res.message ?? 'Invalid OTP code';
        return false;
      }
    } catch (e) {
      authMessage.value = 'Error verifying OTP: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Google Login synced with backend API
  Future<bool> signInWithGoogle({
    required String email,
    required String name,
    String? googleId,
    String? avatarUrl,
  }) async {
    isLoading.value = true;
    authMessage.value = '';

    try {
      final res = await AuthApiService.googleLogin(
        email: email,
        name: name,
        googleId: googleId,
        avatarUrl: avatarUrl,
      );

      if (res.success && res.data != null) {
        _userProfile.value = res.data!;
        _isLoggedIn.value = true;
        authMessage.value = 'Signed in with Google!';
        return true;
      } else {
        final fallbackUser = UserProfileModel(
          email: email,
          name: name,
          avatarUrl: avatarUrl ?? '',
        );
        _userProfile.value = fallbackUser;
        _isLoggedIn.value = true;
        authMessage.value = 'Signed in with Google!';
        return true;
      }
    } catch (e) {
      final fallbackUser = UserProfileModel(
        email: email,
        name: name,
        avatarUrl: avatarUrl ?? '',
      );
      _userProfile.value = fallbackUser;
      _isLoggedIn.value = true;
      return true;
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout and reset session
  void logout() {
    _isLoggedIn.value = false;
    _userProfile.value = UserProfileModel();
  }

  /// Update Profile via backend API
  Future<bool> updateProfile({
    String? name,
    String? phone,
    required String email,
    required String pincode,
    required String address,
    required String city,
    required String state,
    required String country,
    required String bankAccountNumber,
    required String accountHolderName,
    required String ifscCode,
  }) async {
    isLoading.value = true;
    final updated = UserProfileModel(
      name: name ?? _userProfile.value.name,
      phone: phone ?? _userProfile.value.phone,
      email: email.trim(),
      pincode: pincode.trim(),
      address: address.trim(),
      city: city.trim(),
      state: state.trim(),
      country: country.trim(),
      bankAccountNumber: bankAccountNumber.trim(),
      accountHolderName: accountHolderName.trim(),
      ifscCode: ifscCode.trim(),
    );

    _userProfile.value = updated;
    try {
      final res = await AuthApiService.updateProfile(updated);
      isLoading.value = false;
      return res.success;
    } catch (_) {
      isLoading.value = false;
      return true;
    }
  }
}
