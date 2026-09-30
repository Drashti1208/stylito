import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_routes.dart';
import '../widgets/google_account_picker_sheet.dart';
import '../widgets/phone_otp_dialog.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email and password'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authController = Get.find<AuthController>();
    final success = await authController.login(email, password);

    if (!mounted) return;

    if (success) {
      Get.offAllNamed(AppRoutes.main);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authController.authMessage.value.isNotEmpty
              ? authController.authMessage.value
              : 'Invalid email or password'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showGoogleSignInModal() {
    GoogleAccountPickerSheet.show(context);
  }

  void _showOtpModal() {
    PhoneOtpDialog.show(context);
  }


  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Welcome\nBack!',
                style: AppTextStyles.heading1.copyWith(
                  fontSize: 36,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 32),

              // Username / Email input
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Username or Email',
                  prefixIcon: const Icon(Icons.person_outline, size: 22),
                  filled: true,
                  fillColor: const Color(0xFFF3F3F3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFA8A8A9)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFA8A8A9)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password input
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline, size: 22),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 22,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF3F3F3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFA8A8A9)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFA8A8A9)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Forgot Password link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.forgotPassword);
                  },
                  child: Text(
                    'Forgot Password?',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Login Button with Obx loading state
              Obx(() {
                final loading = authController.isLoading.value;
                return ElevatedButton(
                  onPressed: loading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
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
                          'Login',
                          style: AppTextStyles.button.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                );
              }),
              const SizedBox(height: 16),

              // Login with Phone/Email OTP Button
              OutlinedButton.icon(
                onPressed: _showOtpModal,
                icon: const Icon(Icons.dialpad_outlined, color: AppColors.primary, size: 20),
                label: Text(
                  'Sign In with Real OTP',
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // - OR Continue with -
              Center(
                child: Text(
                  '- OR Continue with -',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.placeholder,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Social Icons (Google Sign-In wired directly)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialButton(
                    icon: Icons.g_mobiledata,
                    iconColor: Colors.redAccent,
                    onTap: _showGoogleSignInModal,
                    isLetter: true,
                    letter: 'G',
                    tooltip: 'Google Sign-In',
                  ),
                  const SizedBox(width: 16),
                  _socialButton(
                    icon: Icons.apple,
                    iconColor: Colors.black,
                    onTap: _showGoogleSignInModal,
                    tooltip: 'Apple ID',
                  ),
                  const SizedBox(width: 16),
                  _socialButton(
                    icon: Icons.phone_android,
                    iconColor: const Color(0xFF1877F2),
                    onTap: _showOtpModal,
                    tooltip: 'Instant OTP',
                  ),
                ],
              ),
              const SizedBox(height: 36),

              // Create An Account Sign Up
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.signUp);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Create An Account ',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.placeholder,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: AppTextStyles.bodyBold.copyWith(
                            color: AppColors.primary,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    bool isLetter = false,
    String letter = '',
    String tooltip = '',
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: const Color(0xFFFCF3F6),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Center(
            child: isLetter
                ? Text(
                    letter,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: iconColor,
                    ),
                  )
                : Icon(icon, color: iconColor, size: 28),
          ),
        ),
      ),
    );
  }
}
