import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../widgets/google_account_picker_sheet.dart';
import '../widgets/phone_otp_dialog.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  void _signInWithGoogleDirect() {
    GoogleAccountPickerSheet.show(context, onSuccess: () {
      Navigator.pushReplacementNamed(context, AppRoutes.main);
    });
  }

  void _showPhoneOtpModal() {
    PhoneOtpDialog.show(context, onSuccess: () {
      Navigator.pushReplacementNamed(context, AppRoutes.main);
    });
  }

  Widget _googleLogo() {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Text(
        'G',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: Color(0xFF4285F4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            AppAssets.getStartedBg,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2C3E50), Color(0xFF000000)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              );
            },
          ),

          // Gradient overlay for contrast
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.15),
                  Colors.black.withValues(alpha: 0.55),
                  Colors.black.withValues(alpha: 0.90),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.15, 0.50, 0.95],
              ),
            ),
          ),

          // Content centered in the middle
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'You want\nAuthentic, here\nyou go!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Find it here, buy it now with real-time checkout!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFE2E8F0),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Option 1: Continue with Google (Light clean button)
                    ElevatedButton(
                      onPressed: _signInWithGoogleDirect,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1E293B),
                        minimumSize: const Size(double.infinity, 50),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _googleLogo(),
                          const SizedBox(width: 10),
                          Text(
                            'Continue with Google',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Option 2: Continue with Phone (Light, clean modern button)
                    ElevatedButton(
                      onPressed: _showPhoneOtpModal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.94),
                        foregroundColor: const Color(0xFF1E293B),
                        minimumSize: const Size(double.infinity, 50),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.phone_android_rounded, color: AppColors.primary, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'Continue with Phone Number',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Option 3: Primary Get Started / Browse Store
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, AppRoutes.main);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Get Started (Browse Store)',
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Existing User Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Existing User? ',
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFFCBD5E1),
                            fontSize: 13,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.signIn);
                          },
                          child: Text(
                            'Sign In with Email',
                            style: GoogleFonts.montserrat(
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
          ),
        ],
      ),
    );
  }
}
