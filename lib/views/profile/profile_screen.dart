import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  final bool showBackButton;

  const ProfileScreen({super.key, this.showBackButton = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _pincodeController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _countryController;
  late TextEditingController _bankAccountController;
  late TextEditingController _accountHolderController;
  late TextEditingController _ifscController;

  @override
  void initState() {
    super.initState();
    final profile = Get.find<AuthController>().userProfile;
    _nameController = TextEditingController(text: profile.name);
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(text: profile.phone);
    _pincodeController = TextEditingController(text: profile.pincode);
    _addressController = TextEditingController(text: profile.address);
    _cityController = TextEditingController(text: profile.city);
    _stateController = TextEditingController(text: profile.state);
    _countryController = TextEditingController(
      text: profile.country.isNotEmpty ? profile.country : 'India',
    );
    _bankAccountController = TextEditingController(text: profile.bankAccountNumber);
    _accountHolderController = TextEditingController(text: profile.accountHolderName);
    _ifscController = TextEditingController(text: profile.ifscCode);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _pincodeController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _bankAccountController.dispose();
    _accountHolderController.dispose();
    _ifscController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final authController = Get.find<AuthController>();
    final success = await authController.updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      pincode: _pincodeController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      country: _countryController.text.trim(),
      bankAccountNumber: _bankAccountController.text.trim(),
      accountHolderName: _accountHolderController.text.trim(),
      ifscCode: _ifscController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Get.rawSnackbar(
        titleText: Text(
          'Profile Saved',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 13.5),
        ),
        messageText: Text(
          'Profile & Address saved successfully to SQLite database!',
          style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12),
        ),
        icon: const Icon(Icons.check_circle_outline, color: Color(0xFF4ADE80), size: 22),
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
    } else {
      Get.rawSnackbar(
        titleText: Text(
          'Update Failed',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 13.5),
        ),
        messageText: Text(
          'Failed to update profile details. Please try again.',
          style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12),
        ),
        icon: const Icon(Icons.error_outline, color: Color(0xFFF87171), size: 22),
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
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: Text(
          'My Profile & Address',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E1E24),
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF1E1E24)),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFFE5E7EB),
            height: 1,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Centered Profile Header Avatar Card
                Obx(() {
                  final user = authController.userProfile;
                  final displayName = user.name.isNotEmpty
                      ? user.name
                      : (user.email.isNotEmpty ? user.email.split('@')[0] : 'Customer');

                  return Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primary.withValues(alpha: 0.25), width: 3),
                                image: const DecorationImage(
                                  image: AssetImage(AppAssets.userAvatar),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          displayName,
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E1E24),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email.isNotEmpty ? user.email : 'No email added',
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF6B7280),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFBFDBFE)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified, size: 13, color: Color(0xFF2563EB)),
                              const SizedBox(width: 5),
                              Text(
                                'Active Customer',
                                style: GoogleFonts.montserrat(
                                  color: const Color(0xFF2563EB),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 20),

                // 2. Personal Details Section
                _sectionCard(
                  title: 'Personal Details',
                  icon: Icons.person_outline,
                  children: [
                    _inputField(
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      controller: _nameController,
                      prefixIcon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: 14),
                    _inputField(
                      label: 'Email Address',
                      hint: 'Enter your email address',
                      controller: _emailController,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),
                    _inputField(
                      label: 'Mobile / Phone Number',
                      hint: 'Enter mobile number for order updates',
                      controller: _phoneController,
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 3. Shipping & Delivery Address Section
                _sectionCard(
                  title: 'Shipping & Delivery Address',
                  icon: Icons.location_on_outlined,
                  children: [
                    _inputField(
                      label: 'House / Flat / Street Address',
                      hint: 'Enter complete street address',
                      controller: _addressController,
                      prefixIcon: Icons.home_outlined,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _inputField(
                            label: 'City',
                            hint: 'e.g. Mumbai',
                            controller: _cityController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _inputField(
                            label: 'State',
                            hint: 'e.g. Maharashtra',
                            controller: _stateController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _inputField(
                            label: 'Pincode / Zip',
                            hint: 'e.g. 400001',
                            controller: _pincodeController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _inputField(
                            label: 'Country',
                            hint: 'e.g. India',
                            controller: _countryController,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 4. Bank Details Section
                _sectionCard(
                  title: 'Bank Details (For Instant Refund)',
                  icon: Icons.account_balance_outlined,
                  children: [
                    _inputField(
                      label: 'Bank Account Number',
                      hint: 'Enter account number',
                      controller: _bankAccountController,
                      prefixIcon: Icons.credit_card,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 14),
                    _inputField(
                      label: "Account Holder's Name",
                      hint: 'Name as registered with bank',
                      controller: _accountHolderController,
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 14),
                    _inputField(
                      label: 'IFSC / Branch Code',
                      hint: 'e.g. HDFC0001234',
                      controller: _ifscController,
                      prefixIcon: Icons.domain,
                    ),
                  ],
                ),
                const SizedBox(height: 26),

                // 5. Save Button
                Obx(() {
                  final loading = authController.isLoading.value;
                  return ElevatedButton(
                    onPressed: loading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      shadowColor: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    child: loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle_outline, color: Colors.white, size: 19),
                              const SizedBox(width: 8),
                              Text(
                                'Save Profile & Address',
                                style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                  );
                }),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E1E24),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _inputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    IconData? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            color: const Color(0xFF374151),
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.montserrat(
            fontSize: 13.5,
            color: const Color(0xFF1F2937),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.montserrat(
              color: const Color(0xFF9CA3AF),
              fontSize: 13,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 18, color: const Color(0xFF6B7280))
                : null,
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
            ),
          ),
        ),
      ],
    );
  }
}
