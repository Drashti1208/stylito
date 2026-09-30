import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/auth_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

class GoogleAccountItem {
  final String name;
  final String email;
  final String? avatarUrl;
  final Color avatarColor;

  const GoogleAccountItem({
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.avatarColor,
  });
}

class GoogleAccountPickerSheet extends StatefulWidget {
  final VoidCallback? onSuccess;

  const GoogleAccountPickerSheet({super.key, this.onSuccess});

  /// Opens as bottom sheet on mobile or centered dialog on desktop/tablet
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
            child: GoogleAccountPickerSheet(onSuccess: onSuccess),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => GoogleAccountPickerSheet(onSuccess: onSuccess),
      );
    }
  }

  @override
  State<GoogleAccountPickerSheet> createState() => _GoogleAccountPickerSheetState();
}

class _GoogleAccountPickerSheetState extends State<GoogleAccountPickerSheet> {
  bool _showCustomInput = true;
  final _customEmailController = TextEditingController();
  final _customNameController = TextEditingController();

  List<GoogleAccountItem> get _accounts {
    final authController = Get.find<AuthController>();
    final user = authController.userProfile;
    if (user.email.isNotEmpty) {
      return [
        GoogleAccountItem(
          name: user.name.isNotEmpty ? user.name : user.email.split('@')[0],
          email: user.email,
          avatarColor: const Color(0xFF1E88E5),
        ),
      ];
    }
    return const [];
  }

  @override
  void initState() {
    super.initState();
    _customEmailController.addListener(_onEmailChanged);
  }

  void _onEmailChanged() {
    final email = _customEmailController.text.trim();
    if (email.contains('@') && _customNameController.text.isEmpty) {
      final handle = email.split('@').first;
      final parts = handle.split(RegExp(r'[._\-\d]+')).where((p) => p.isNotEmpty);
      if (parts.isNotEmpty) {
        final formatted = parts
            .map((p) => p[0].toUpperCase() + (p.length > 1 ? p.substring(1).toLowerCase() : ''))
            .join(' ');
        _customNameController.text = formatted;
      }
    }
  }

  @override
  void dispose() {
    _customEmailController.removeListener(_onEmailChanged);
    _customEmailController.dispose();
    _customNameController.dispose();
    super.dispose();
  }

  Future<void> _signInWithNativeGoogle() async {
    Navigator.of(context, rootNavigator: true).pop();
    final authController = Get.find<AuthController>();
    authController.isLoading.value = true;
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
        if (success) {
          Get.snackbar(
            'Google Sign-In',
            'Welcome, ${authController.userProfile.name}!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.success,
            colorText: Colors.white,
          );
          if (widget.onSuccess != null) {
            widget.onSuccess!();
          } else {
            Get.offAllNamed(AppRoutes.main);
          }
        }
      }
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
    } finally {
      authController.isLoading.value = false;
    }
  }

  Future<void> _selectAccount(GoogleAccountItem account) async {
    Navigator.of(context, rootNavigator: true).pop();

    final authController = Get.find<AuthController>();
    final success = await authController.signInWithGoogle(
      email: account.email,
      name: account.name,
      googleId: 'g_${account.email.hashCode.abs()}',
    );

    if (success) {
      Get.snackbar(
        'Google Sign-In',
        'Signed in as ${account.name} (${account.email})',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );

      if (widget.onSuccess != null) {
        widget.onSuccess!();
      } else {
        Get.offAllNamed(AppRoutes.main);
      }
    } else {
      Get.snackbar(
        'Google Sign-In',
        authController.authMessage.value.isNotEmpty
            ? authController.authMessage.value
            : 'Google Sign-In failed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> _submitCustomAccount() async {
    final email = _customEmailController.text.trim();
    final name = _customNameController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid Google email address'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final customAccount = GoogleAccountItem(
      name: name.isNotEmpty ? name : email.split('@')[0],
      email: email,
      avatarColor: const Color(0xFF5E35B1),
    );

    await _selectAccount(customAccount);
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
        top: 18,
        left: 18,
        right: 18,
        bottom: MediaQuery.of(context).viewInsets.bottom + 18,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _googleLogo(),
                  const SizedBox(width: 8),
                  Text(
                    'Sign in with Google',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF202124),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF94A3B8), size: 20),
                onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'to continue to Stylito Fashion',
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: const Color(0xFF5F6368),
            ),
          ),
          const SizedBox(height: 14),
          // 1-Tap Native Android Google Account Selector
          OutlinedButton.icon(
            onPressed: _signInWithNativeGoogle,
            icon: _googleLogo(),
            label: Text(
              'Sign In with Phone Google Account',
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F1F1F),
              ),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 46),
              side: const BorderSide(color: Color(0xFF747775)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          const SizedBox(height: 8),

          // Accounts List
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 260),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: _accounts.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: Color(0xFFF1F3F4),
                indent: 56,
              ),
              itemBuilder: (context, index) {
                final account = _accounts[index];
                return _accountTile(account);
              },
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE0E0E0)),

          // "Use another account" button / input
          if (!_showCustomInput) ...[
            InkWell(
              onTap: () {
                setState(() => _showCustomInput = true);
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F3F4),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFDADCE0)),
                      ),
                      child: const Icon(
                        Icons.person_add_alt_1_outlined,
                        color: Color(0xFF1A73E8),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Use another account',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF202124),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your Google Email',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF5F6368),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _customEmailController,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'e.g. yourname@gmail.com',
                      prefixIcon: const Icon(Icons.email_outlined, size: 20),
                      filled: true,
                      fillColor: const Color(0xFFF8F9FA),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFDADCE0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF1A73E8), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _customNameController,
                    decoration: InputDecoration(
                      hintText: 'Your Full Name (Optional)',
                      prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                      filled: true,
                      fillColor: const Color(0xFFF8F9FA),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFDADCE0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF1A73E8), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() => _showCustomInput = false);
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _submitCustomAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A73E8),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Continue'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Google Disclaimer Footer
          Text(
            'To continue, Google will share your name, email address, and profile picture with Stylito. See Stylito’s Privacy Policy and Terms of Service.',
            style: GoogleFonts.roboto(
              fontSize: 11,
              color: const Color(0xFF70757A),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountTile(GoogleAccountItem account) {
    return InkWell(
      onTap: () => _selectAccount(account),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: [
            // Circular Avatar with Letter
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: account.avatarColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  account.name.isNotEmpty ? account.name[0].toUpperCase() : 'U',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Name & Email
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.name,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF202124),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    account.email,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: const Color(0xFF5F6368),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 13, color: Color(0xFF9AA0A6)),
          ],
        ),
      ),
    );
  }

  Widget _googleLogo() {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: CustomPaint(painter: _GoogleIconPainter()),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w / 2;

    // Red segment
    final redPaint = Paint()..color = const Color(0xFFEA4335);
    final bluePaint = Paint()..color = const Color(0xFF4285F4);
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05);
    final greenPaint = Paint()..color = const Color(0xFF34A853);

    // Simplified Google 4-Color 'G' representation
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, -0.8, 1.6, true, redPaint);
    canvas.drawArc(rect, 0.8, 1.5, true, yellowPaint);
    canvas.drawArc(rect, 2.3, 1.4, true, greenPaint);
    canvas.drawArc(rect, 3.7, 1.8, true, bluePaint);

    // White inner cutout
    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.58, innerPaint);

    // Blue horizontal bar
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..strokeWidth = radius * 0.4
      ..strokeCap = StrokeCap.square;
    canvas.drawLine(Offset(center.dx, center.dy), Offset(w * 0.95, center.dy), barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
