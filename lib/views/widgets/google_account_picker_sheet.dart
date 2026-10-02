import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../controllers/auth_controller.dart';
import '../../core/constants/app_colors.dart';

class GoogleAccountPickerSheet extends StatefulWidget {
  final VoidCallback? onSuccess;

  const GoogleAccountPickerSheet({super.key, this.onSuccess});

  /// Opens as centered dialog on desktop/web or bottom sheet on mobile
  static void show(BuildContext context, {VoidCallback? onSuccess}) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    if (isDesktop) {
      showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.55),
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 390),
            child: GoogleAccountPickerSheet(onSuccess: onSuccess),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => Container(
          constraints: const BoxConstraints(maxWidth: 420),
          child: GoogleAccountPickerSheet(onSuccess: onSuccess),
        ),
      );
    }
  }

  @override
  State<GoogleAccountPickerSheet> createState() => _GoogleAccountPickerSheetState();
}

class _GoogleAccountPickerSheetState extends State<GoogleAccountPickerSheet> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
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

  Future<void> _handleNext() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _showTopAlert(
        title: 'Invalid Email',
        message: 'Please enter a valid email address.',
        isSuccess: false,
      );
      return;
    }

    setState(() => _isLoading = true);
    final authController = Get.find<AuthController>();
    final handle = email.split('@').first;
    final parts = handle.split(RegExp(r'[._\-\d]+')).where((p) => p.isNotEmpty);
    final formattedName = parts.isNotEmpty
        ? parts.map((p) => p[0].toUpperCase() + (p.length > 1 ? p.substring(1).toLowerCase() : '')).join(' ')
        : handle;

    final success = await authController.signInWithGoogle(
      email: email,
      name: formattedName,
      googleId: 'email_${email.hashCode.abs()}',
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context, rootNavigator: true).pop();
      _showTopAlert(
        title: 'Signed In',
        message: 'Welcome back, $formattedName!',
        isSuccess: true,
      );
      if (widget.onSuccess != null) {
        widget.onSuccess!();
      }
    } else {
      _showTopAlert(
        title: 'Sign In Failed',
        message: authController.authMessage.value.isNotEmpty
            ? authController.authMessage.value
            : 'Could not sign in with this email.',
        isSuccess: false,
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    final authController = Get.find<AuthController>();

    try {
      final googleSignIn = GoogleSignIn();
      final account = await googleSignIn.signIn();
      if (account != null) {
        final success = await authController.signInWithGoogle(
          email: account.email,
          name: account.displayName ?? account.email.split('@')[0],
          googleId: account.id,
          avatarUrl: account.photoUrl,
        );

        if (!mounted) return;
        setState(() => _isLoading = false);

        if (success) {
          Navigator.of(context, rootNavigator: true).pop();
          _showTopAlert(
            title: 'Google Sign-In',
            message: 'Welcome, ${authController.userProfile.name}!',
            isSuccess: true,
          );
          if (widget.onSuccess != null) {
            widget.onSuccess!();
          }
        } else {
          _showTopAlert(
            title: 'Google Sign-In Failed',
            message: 'Could not complete Google Sign-In.',
            isSuccess: false,
          );
        }
      } else {
        if (!mounted) return;
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      // Fallback: If native Google SignIn popup is blocked on browser, prompt user email
      _showTopAlert(
        title: 'Google Sign-In',
        message: 'Please enter your Gmail above to continue.',
        isSuccess: false,
      );
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
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Close Row
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () => Navigator.of(context, rootNavigator: true).pop(),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.close, size: 20, color: Color(0xFF94A3B8)),
              ),
            ),
          ),

          // 1. Title Typography (Matching Image 3)
          Center(
            child: Text(
              'Sign In to Your Account',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 2. Email Address Label
          Text(
            'Email Address',
            style: GoogleFonts.montserrat(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),

          // 3. Email Input Field (Matching Image 3)
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Enter Your Email',
              hintStyle: GoogleFonts.montserrat(
                fontSize: 13.5,
                color: const Color(0xFF94A3B8),
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
            onSubmitted: (_) => _handleNext(),
          ),
          const SizedBox(height: 18),

          // 4. Next Button (Stylito Landing Page Primary Color - Image 3)
          ElevatedButton(
            onPressed: _isLoading ? null : _handleNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Text(
                    'Next',
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          const SizedBox(height: 18),

          // 5. "or" Divider (Matching Image 3)
          Row(
            children: [
              const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  'or',
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: const Color(0xFF94A3B8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
            ],
          ),
          const SizedBox(height: 18),

          // 6. Sign In with Google Pill Button (Matching Image 3)
          OutlinedButton(
            onPressed: _isLoading ? null : _handleGoogleSignIn,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/google_logo.png',
                  height: 20,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.g_mobiledata,
                    color: Color(0xFFEA4335),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Sign in with Google',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
