import 'package:get/get.dart';
import '../models/user_profile_model.dart';
import '../services/auth_api_service.dart';
import '../services/hive_storage_service.dart';

class AuthController extends GetxController {
  final Rx<UserProfileModel> _userProfile = UserProfileModel().obs;
  final RxBool _isLoggedIn = false.obs;
  final RxBool isLoading = false.obs;
  final RxString authMessage = ''.obs;

  UserProfileModel get userProfile => _userProfile.value;
  bool get isLoggedIn => _isLoggedIn.value;

  @override
  void onInit() {
    super.onInit();
    _loadUserFromHive();
  }

  /// Automatically restore session from Hive on app startup
  void _loadUserFromHive() {
    final cachedUser = HiveStorageService.getCurrentUser();
    if (cachedUser != null && HiveStorageService.isUserLoggedIn()) {
      _userProfile.value = cachedUser;
      _isLoggedIn.value = true;
    }
  }

  void _syncInBackground(Future<dynamic> Function() task) {
    task().then((_) {}).catchError((_) {});
  }

  void setLoggedInUser(UserProfileModel user) {
    _userProfile.value = user;
    _isLoggedIn.value = true;
    authMessage.value = 'Logged in as ${user.name}';
    HiveStorageService.saveCurrentUser(user);
  }

  /// Login with Hive database storage
  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    authMessage.value = '';

    try {
      // 1. Check Hive local database
      final localRes = await HiveStorageService.loginUser(email: email, password: password);
      if (localRes['success'] == true && localRes['data'] != null) {
        _userProfile.value = localRes['data'] as UserProfileModel;
        _isLoggedIn.value = true;
        authMessage.value = 'Logged in successfully!';
        // Sync with API in background if online
        _syncInBackground(() => AuthApiService.login(email: email, password: password));
        return true;
      }

      // 2. Fallback to API if not in Hive
      final res = await AuthApiService.login(email: email, password: password);
      if (res.success && res.data != null) {
        _userProfile.value = res.data!;
        _isLoggedIn.value = true;
        await HiveStorageService.saveCurrentUser(res.data!);
        authMessage.value = 'Logged in successfully!';
        return true;
      } else {
        authMessage.value = localRes['message'] ?? res.message ?? 'Login failed';
        return false;
      }
    } catch (e) {
      // Offline fallback
      final localRes = await HiveStorageService.loginUser(email: email, password: password);
      if (localRes['success'] == true && localRes['data'] != null) {
        _userProfile.value = localRes['data'] as UserProfileModel;
        _isLoggedIn.value = true;
        authMessage.value = 'Logged in successfully!';
        return true;
      }
      authMessage.value = localRes['message'] ?? 'Network error during login: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Signup with Hive database storage
  Future<bool> signup(String email, String password, {String? name, String? phone}) async {
    isLoading.value = true;
    authMessage.value = '';

    try {
      final localRes = await HiveStorageService.registerUser(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );

      if (localRes['success'] == true && localRes['data'] != null) {
        final user = localRes['data'] as UserProfileModel;
        _userProfile.value = user;
        _isLoggedIn.value = true;
        authMessage.value = 'Account created successfully!';
        // Sync with API in background
        _syncInBackground(() => AuthApiService.register(
              email: email,
              password: password,
              name: name,
              phone: phone,
            ));
        return true;
      } else {
        authMessage.value = localRes['message'] ?? 'Sign up failed';
        return false;
      }
    } catch (e) {
      authMessage.value = 'Error during signup: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Generate & store OTP locally in Hive
  Future<String?> requestOtp(String contact) async {
    isLoading.value = true;
    authMessage.value = '';

    try {
      final otp = await HiveStorageService.generateAndSaveOtp(contact);
      authMessage.value = 'OTP sent successfully!';
      _syncInBackground(() => AuthApiService.sendOtp(contact));
      return otp;
    } catch (e) {
      authMessage.value = 'Error sending OTP: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Verify OTP directly from Hive
  Future<bool> verifyOtp(String contact, String code, {String? name}) async {
    isLoading.value = true;
    authMessage.value = '';

    try {
      final res = await HiveStorageService.verifyOtp(contact: contact, code: code, name: name);
      if (res['success'] == true && res['data'] != null) {
        _userProfile.value = res['data'] as UserProfileModel;
        _isLoggedIn.value = true;
        authMessage.value = 'OTP verified! Welcome to Stylito.';
        _syncInBackground(() => AuthApiService.verifyOtp(contact: contact, code: code, name: name));
        return true;
      } else {
        authMessage.value = res['message'] ?? 'Invalid OTP code';
        return false;
      }
    } catch (e) {
      authMessage.value = 'Error verifying OTP: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Google Login via Hive
  Future<bool> signInWithGoogle({
    required String email,
    required String name,
    String? googleId,
    String? avatarUrl,
  }) async {
    isLoading.value = true;
    authMessage.value = '';

    try {
      final user = await HiveStorageService.saveOrUpdateGoogleUser(
        email: email,
        name: name,
        googleId: googleId,
        avatarUrl: avatarUrl,
      );

      _userProfile.value = user;
      _isLoggedIn.value = true;
      authMessage.value = 'Signed in with Google!';
      _syncInBackground(() => AuthApiService.googleLogin(
            email: email,
            name: name,
            googleId: googleId,
            avatarUrl: avatarUrl,
          ));
      return true;
    } catch (e) {
      authMessage.value = 'Error during Google Sign-In: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout and clear Hive session
  void logout() {
    _isLoggedIn.value = false;
    _userProfile.value = UserProfileModel();
    HiveStorageService.clearCurrentUser();
  }

  /// Update Profile in Hive
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
    await HiveStorageService.updateUserProfile(updated);
    _syncInBackground(() => AuthApiService.updateProfile(updated));
    isLoading.value = false;
    return true;
  }
}
