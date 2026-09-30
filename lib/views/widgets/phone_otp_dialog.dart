import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/auth_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

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
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  bool _isOtpSent = false;
  String? _sentOtpCode;
  String _activeContact = '';

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
    if (digits.length == 10 && _nameController.text.isEmpty) {
      final authController = Get.find<AuthController>();
      final user = authController.userProfile;
      if (user.phone.contains(digits) && user.name.isNotEmpty) {
        _nameController.text = user.name;
      }
    }
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneChanged);
    _phoneController.dispose();
    _nameController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> _sendOtp([String? presetPhone, String? presetName]) async {
    final phone = (presetPhone ?? _phoneController.text).trim();
    if (phone.isEmpty || phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authController = Get.find<AuthController>();
    final serverOtp = await authController.requestOtp(phone);
    if (!mounted) return;
    setState(() {
      _isOtpSent = true;
      _activeContact = phone;
      _sentOtpCode = serverOtp;
      if (presetName != null) _nameController.text = presetName;
    });

    if (serverOtp != null && serverOtp.length == 6) {
      for (int i = 0; i < 6; i++) {
        _otpControllers[i].text = serverOtp[i];
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(serverOtp != null
            ? 'OTP sent to +91 $phone: $serverOtp'
            : 'OTP sent to +91 $phone! Check Messages.'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _verifyOtp() async {
    final code = _otpControllers.map((c) => c.text.trim()).join();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter complete 6-digit OTP code'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authController = Get.find<AuthController>();
    final userName = _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : null;

    final success = await authController.verifyOtp(
      _activeContact,
      code,
      name: userName,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(Get.context ?? context).showSnackBar(
        SnackBar(
          content: Text('Welcome! Successfully logged in with $_activeContact'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

      if (widget.onSuccess != null) {
        widget.onSuccess!();
      } else {
        Get.offAllNamed(AppRoutes.main);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authController.authMessage.value.isNotEmpty
              ? authController.authMessage.value
              : 'Invalid OTP code. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.phone_android, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isOtpSent ? 'Verify Phone OTP' : 'Login with Phone',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      _isOtpSent
                          ? 'Code sent to $_activeContact'
                          : 'Enter your 10-digit mobile number',
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
          const SizedBox(height: 14),

          if (!_isOtpSent) ...[
            // Optional User Name Input
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person_outline, size: 18, color: Color(0xFF64748B)),
                hintText: 'Your Name (Optional)',
                hintStyle: GoogleFonts.montserrat(fontSize: 13, color: const Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Mobile number input with +91 prefix
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 14),

            ElevatedButton(
              onPressed: () => _sendOtp(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'Get Verification Code',
                style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ] else ...[
            // 6-digit PIN input view
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) => _otpPinBox(index)),
            ),
            const SizedBox(height: 14),

            if (_sentOtpCode != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF86EFAC)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt, color: Color(0xFF16A34A), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Test OTP: $_sentOtpCode',
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFF15803D),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 18),

            ElevatedButton(
              onPressed: _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'Verify & Open App',
                style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() => _isOtpSent = false);
                },
                child: const Text('Change Phone Number'),
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
        style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w700),
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
