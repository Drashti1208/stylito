import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/inquiry_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/app_launcher.dart';

class ContactAndStoreDetailsSheet extends StatefulWidget {
  const ContactAndStoreDetailsSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ContactAndStoreDetailsSheet(),
    );
  }

  @override
  State<ContactAndStoreDetailsSheet> createState() =>
      _ContactAndStoreDetailsSheetState();
}

class _ContactAndStoreDetailsSheetState
    extends State<ContactAndStoreDetailsSheet> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitMessage() async {
    if (!_formKey.currentState!.validate()) return;

    final inquiryCtrl = Get.find<InquiryController>();
    final success = await inquiryCtrl.submitInquiry(
      name: _nameController.text,
      email: _emailController.text,
      subject: _subjectController.text,
      message: _messageController.text,
    );

    if (mounted) {
      if (success) {
        _nameController.clear();
        _emailController.clear();
        _subjectController.clear();
        _messageController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(' Message received in real-time! Our team will contact you soon.'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(inquiryCtrl.lastSubmissionMessage.value),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 720;
    final inquiryCtrl = Get.find<InquiryController>();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
        maxWidth: 860,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'STYLISH \u2022 CONTACT US & STORE DETAILS',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1B1B1B),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Get in touch with our customer assistance team or visit our flagship studio',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: const Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, size: 22),
              ),
            ],
          ),
          const Divider(height: 24),

          // Content body
          Flexible(
            child: SingleChildScrollView(
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildStoreDetailsList()),
                        const SizedBox(width: 24),
                        Expanded(child: _buildDirectMessageForm(inquiryCtrl)),
                      ],
                    )
                  : Column(
                      children: [
                        _buildDirectMessageForm(inquiryCtrl),
                        const SizedBox(height: 24),
                        _buildStoreDetailsList(),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreDetailsList() {
    return Column(
      children: [
        _infoCard(
          icon: '📍',
          title: 'FLAGSHIP STORE & HQ',
          subtitle:
              'Stylish Fashion House, 402 Creative Square, S.G. Highway, Ahmedabad, Gujarat, India - 380054',
        ),
        const SizedBox(height: 10),
        _infoCard(
          icon: '📞',
          title: 'PHONE & HELPLINE',
          subtitle: '+91 98765 43210 \u2022 Toll-Free: 1800-STYLISH',
          onTap: () => AppLauncher.launchPhone('+919876543210'),
        ),
        const SizedBox(height: 10),
        _infoCard(
          icon: '✉️',
          title: 'EMAIL SUPPORT',
          subtitle: 'support@stylishfashion.com / contact@stylito.com\n(Tap to compose mail)',
          onTap: () => AppLauncher.launchEmail(
            email: 'support@stylito.com',
            subject: 'Stylito Support Inquiry',
          ),
        ),
        const SizedBox(height: 10),
        _infoCard(
          icon: '⏰',
          title: 'WORKING HOURS',
          subtitle: 'Mon \u2013 Sat: 9:00 AM \u2013 8:00 PM IST\nSunday: 10:00 AM \u2013 5:00 PM IST',
        ),
        const SizedBox(height: 10),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => AppLauncher.launchEmail(
            email: 'support@stylito.com',
            subject: 'Stylito WhatsApp / Online Concierge Inquiry',
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFF25D366),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('💬', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DIRECT SUPPORT / CONCIERGE',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1B1B1B),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Tap here to directly contact our personal stylist & support team.',
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoCard({
    required String icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1B1B1B),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      color: const Color(0xFF666666),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primary),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectMessageForm(InquiryController inquiryCtrl) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E2E2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send Us a Direct Message',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1B1B1B),
              ),
            ),
            const SizedBox(height: 12),

            // Full Name
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration('Your Full Name'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 10),

            // Email Address
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration('Your Email Address'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Please enter your email';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 10),

            // Subject / Order ID
            TextFormField(
              controller: _subjectController,
              decoration: _inputDecoration('Subject / Order ID (Optional)'),
            ),
            const SizedBox(height: 10),

            // Message
            TextFormField(
              controller: _messageController,
              maxLines: 4,
              decoration: _inputDecoration(
                'How can our stylists or support team help you?',
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Please enter a message' : null,
            ),
            const SizedBox(height: 16),

            // Submit Button
            Obx(
              () => ElevatedButton(
                onPressed: inquiryCtrl.isSubmitting.value ? null : _submitMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: inquiryCtrl.isSubmitting.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'SEND MESSAGE',
                        style: AppTextStyles.button.copyWith(
                          fontSize: 14,
                          letterSpacing: 0.8,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.montserrat(
        fontSize: 12,
        color: Colors.grey.shade400,
      ),
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}
