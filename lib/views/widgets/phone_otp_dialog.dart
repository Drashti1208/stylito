import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/auth_controller.dart';
import '../../core/constants/app_colors.dart';

class PhoneOtpDialog extends StatefulWidget {
  final VoidCallback? onSuccess;

  const PhoneOtpDialog({super.key, this.onSuccess});

  static void show(BuildContext context, {VoidCallback? onSuccess}) {
    final isDesktop = MediaQuery.of(context).size.width > 700;

    if (isDesktop) {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            child: PhoneOtpDialog(onSuccess: onSuccess),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => PhoneOtpDialog(onSuccess: onSuccess),
      );
    }
  }

  @override
  State<PhoneOtpDialog> createState() => _PhoneOtpDialogState();
}

class _PhoneOtpDialogState extends State<PhoneOtpDialog> {
  // Step: 0 = Enter Phone, 1 = Enter OTP, 2 = Complete Profile Details
  int _currentStep = 0;

  final _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  // Profile Details Controllers (Step 2)
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();

  String _activeContact = '';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneChanged);
  }

  void _onPhoneChanged() {
    final raw = _phoneController.text;
    String digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('91') && digits.length > 10) {
      digits = digits.substring(2);
    }
    if (digits.startsWith('0')) {
      digits = digits.substring(1);
    }
    if (digits.length > 10) {
      digits = digits.substring(0, 10);
    }
    if (raw != digits && digits.isNotEmpty) {
      _phoneController.value = TextEditingValue(
        text: digits,
        selection: TextSelection.collapsed(offset: digits.length),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneChanged);
    _phoneController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _showTopAlert({
    required String title,
    required String message,
    required bool isSuccess,
  }) {
    Get.rawSnackbar(
      titleText: Text(
        title,
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w800,
          color: Colors.white,
          fontSize: 13.5,
        ),
      ),
      messageText: Text(
        message,
        style: GoogleFonts.montserrat(
          color: Colors.white70,
          fontSize: 12,
        ),
      ),
      icon: Icon(
        isSuccess ? Icons.check_circle_outline : Icons.error_outline,
        color: isSuccess ? const Color(0xFF4ADE80) : const Color(0xFFF87171),
        size: 22,
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF1E1E24),
      margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // STEP 1: Send OTP
  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      _showTopAlert(
        title: 'Invalid Phone Number',
        message: 'Please enter a valid 10-digit mobile number.',
        isSuccess: false,
      );
      return;
    }

    setState(() => _isProcessing = true);
    final authController = Get.find<AuthController>();
    final serverOtp = await authController.requestOtp(phone);
    if (!mounted) return;
    setState(() {
      _isProcessing = false;
      _currentStep = 1;
      _activeContact = phone;
    });

    if (serverOtp != null && serverOtp.length == 6) {
      for (int i = 0; i < 6; i++) {
        _otpControllers[i].text = serverOtp[i];
      }
    }

    _showTopAlert(
      title: 'OTP Notification',
      message: serverOtp != null
          ? 'OTP code for +91 $phone is: $serverOtp'
          : 'Verification code sent to +91 $phone via SMS.',
      isSuccess: true,
    );
  }

  // STEP 2: Verify OTP -> Go to Step 3 (Fill Details Container)
  Future<void> _verifyOtp() async {
    final code = _otpControllers.map((c) => c.text.trim()).join();
    if (code.length != 6) {
      _showTopAlert(
        title: 'Incomplete OTP',
        message: 'Please enter the complete 6-digit OTP code.',
        isSuccess: false,
      );
      return;
    }

    setState(() => _isProcessing = true);
    final authController = Get.find<AuthController>();
    final success = await authController.verifyOtp(_activeContact, code);
    if (!mounted) return;
    setState(() => _isProcessing = false);

    if (success) {
      final user = authController.userProfile;
      _nameController.text = user.name.isNotEmpty && !user.name.contains('Customer') ? user.name : '';
      _emailController.text = user.email.isNotEmpty && !user.email.contains('@stylitocustomer.com') ? user.email : '';
      _cityController.text = user.city;

      // Transition smoothly to Complete Profile details container
      setState(() {
        _currentStep = 2;
      });

      _showTopAlert(
        title: 'OTP Verified Successfully',
        message: 'Please complete your profile details to finish setup.',
        isSuccess: true,
      );
    } else {
      _showTopAlert(
        title: 'Verification Failed',
        message: authController.authMessage.value.isNotEmpty
            ? authController.authMessage.value
            : 'Invalid OTP code. Please try again.',
        isSuccess: false,
      );
    }
  }

  // STEP 3: Save Profile Details and Finish
  Future<void> _saveProfileAndContinue() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final city = _cityController.text.trim();

    if (name.isEmpty) {
      _showTopAlert(
        title: 'Name Required',
        message: 'Please enter your full name.',
        isSuccess: false,
      );
      return;
    }

    if (email.isEmpty || !email.contains('@')) {
      _showTopAlert(
        title: 'Valid Email Required',
        message: 'Please enter your valid Gmail / Email address.',
        isSuccess: false,
      );
      return;
    }

    setState(() => _isProcessing = true);
    final authController = Get.find<AuthController>();
    await authController.updateProfile(
      name: name,
      email: email,
      phone: _activeContact,
      city: city,
      pincode: authController.userProfile.pincode,
      address: authController.userProfile.address,
      state: authController.userProfile.state,
      country: authController.userProfile.country.isNotEmpty ? authController.userProfile.country : 'India',
      bankAccountNumber: authController.userProfile.bankAccountNumber,
      accountHolderName: authController.userProfile.accountHolderName,
      ifscCode: authController.userProfile.ifscCode,
    );

    if (!mounted) return;
    setState(() => _isProcessing = false);

    Navigator.of(context, rootNavigator: true).pop();
    _showTopAlert(
      title: 'Welcome to Stylito!',
      message: 'Profile saved! You are now logged in as $name.',
      isSuccess: true,
    );

    if (widget.onSuccess != null) {
      widget.onSuccess!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 22,
        left: 22,
        right: 22,
        bottom: MediaQuery.of(context).viewInsets.bottom + 22,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _currentStep == 2
                      ? Icons.person_add_alt_1_outlined
                      : (_currentStep == 1 ? Icons.lock_clock_outlined : Icons.phone_android),
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentStep == 2
                          ? 'Complete Your Profile'
                          : (_currentStep == 1 ? 'Verify Phone OTP' : 'Login with Phone'),
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      _currentStep == 2
                          ? 'Fill details for your web shopping session'
                          : (_currentStep == 1
                              ? 'Code sent to +91 $_activeContact'
                              : 'Enter your 10-digit mobile number'),
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF94A3B8), size: 20),
                onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Step 0: Phone Number
          if (_currentStep == 0) ...[
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(
                prefixIcon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    border: Border(right: BorderSide(color: Color(0xFFCBD5E1))),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '🇮🇳 +91',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
                hintText: '10-digit number',
                hintStyle: GoogleFonts.montserrat(fontSize: 13, color: const Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _isProcessing ? null : _sendOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      'Get Verification Code',
                      style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
            ),
          ]

          // Step 1: 6-Digit OTP Box
          else if (_currentStep == 1) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) => _otpPinBox(index)),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isProcessing ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      'Verify OTP & Continue',
                      style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() => _currentStep = 0);
                },
                child: Text(
                  'Change Phone Number',
                  style: GoogleFonts.montserrat(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ]

          // Step 2: Fill Details Container (Full Name, Gmail, City)
          else if (_currentStep == 2) ...[
            // Full Name Input
            Text(
              'Full Name',
              style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person_outline, size: 18, color: Color(0xFF94A3B8)),
                hintText: 'e.g. Priya Sharma',
                hintStyle: GoogleFonts.montserrat(fontSize: 12.5, color: const Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
              ),
            ),
            const SizedBox(height: 12),

            // Email / Gmail Input
            Text(
              'Gmail / Email Address',
              style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.mail_outline, size: 18, color: Color(0xFF94A3B8)),
                hintText: 'you@gmail.com',
                hintStyle: GoogleFonts.montserrat(fontSize: 12.5, color: const Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
              ),
            ),
            const SizedBox(height: 12),

            // City Input
            Text(
              'City / State',
              style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_city_outlined, size: 18, color: Color(0xFF94A3B8)),
                hintText: 'e.g. Ahmedabad, Gujarat',
                hintStyle: GoogleFonts.montserrat(fontSize: 12.5, color: const Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
              ),
            ),
            const SizedBox(height: 18),

            ElevatedButton(
              onPressed: _isProcessing ? null : _saveProfileAndContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      'Save & Start Shopping',
                      style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _otpPinBox(int index) {
    return SizedBox(
      width: 46,
      height: 52,
      child: TextFormField(
        controller: _otpControllers[index],
        focusNode: _otpFocusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF1E293B)),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 5) {
              _otpFocusNodes[index + 1].requestFocus();
            } else {
              _otpFocusNodes[index].unfocus();
              _verifyOtp();
            }
          } else {
            if (index > 0) {
              _otpFocusNodes[index - 1].requestFocus();
            }
          }
        },
      ),
    );
  }
}
