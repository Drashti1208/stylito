import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_routes.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String contact;
  final String? initialOtp;

  const OtpVerificationScreen({
    super.key,
    required this.contact,
    this.initialOtp,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _resendCountdown = 60;
  Timer? _timer;
  String? _currentTestOtp;

  @override
  void initState() {
    super.initState();
    _currentTestOtp = widget.initialOtp;
    _startCountdown();

    if (widget.initialOtp != null && widget.initialOtp!.length == 6) {
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = widget.initialOtp![i];
      }
    }
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _resendCountdown = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _enteredCode =>
      _controllers.map((c) => c.text.trim()).join();

  Future<void> _verifyOtp() async {
    final code = _enteredCode;
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
    final success = await authController.verifyOtp(widget.contact, code);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authController.authMessage.value.isNotEmpty
              ? authController.authMessage.value
              : 'OTP Verified Successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Get.offAllNamed(AppRoutes.main);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authController.authMessage.value.isNotEmpty
              ? authController.authMessage.value
              : 'Invalid or expired OTP'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _resendOtp() async {
    if (_resendCountdown > 0) return;

    final authController = Get.find<AuthController>();
    final newOtp = await authController.requestOtp(widget.contact);

    if (!mounted) return;

    if (newOtp != null) {
      setState(() {
        _currentTestOtp = newOtp;
        for (final c in _controllers) {
          c.clear();
        }
      });
      _startCountdown();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New OTP sent: $newOtp'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authController.authMessage.value.isNotEmpty
              ? authController.authMessage.value
              : 'Failed to send OTP'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _autofillTestOtp() {
    if (_currentTestOtp != null && _currentTestOtp!.length == 6) {
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = _currentTestOtp![i];
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('OTP Verification'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  size: 42,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Verification Code',
                style: AppTextStyles.heading2.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 8),
              Text(
                'We have sent the 6-digit verification code to',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.placeholder,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                widget.contact,
                style: AppTextStyles.bodyBold.copyWith(
                  color: AppColors.textDark,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),

              // 6 PIN boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => _otpBox(index)),
              ),
              const SizedBox(height: 16),

              // Quick autofill pill if OTP is present
              if (_currentTestOtp != null)
                GestureDetector(
                  onTap: _autofillTestOtp,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF86EFAC)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bolt, color: Color(0xFF16A34A), size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Test OTP: $_currentTestOtp (Tap to Fill)',
                          style: AppTextStyles.caption.copyWith(
                            color: const Color(0xFF15803D),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 32),

              // Verify button
              Obx(() {
                final loading = authController.isLoading.value;
                return ElevatedButton(
                  onPressed: loading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
                  ),
                  child: loading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Verify Code',
                          style: AppTextStyles.button.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                );
              }),
              const SizedBox(height: 24),

              // Resend timer or button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.placeholder,
                      fontSize: 13,
                    ),
                  ),
                  if (_resendCountdown > 0)
                    Text(
                      'Resend in ${_resendCountdown}s',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: _resendOtp,
                      child: Text(
                        'Resend OTP',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _otpBox(int index) {
    return SizedBox(
      width: 46,
      height: 56,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: AppTextStyles.heading2.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 5) {
              _focusNodes[index + 1].requestFocus();
            } else {
              _focusNodes[index].unfocus();
              _verifyOtp();
            }
          } else {
            if (index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          }
        },
      ),
    );
  }
}
