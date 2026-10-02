import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/inquiry_controller.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_launcher.dart';

class ContactSupportScreen extends StatefulWidget {
  final String? initialSection;

  const ContactSupportScreen({super.key, this.initialSection});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    Get.rawSnackbar(
      titleText: Text(
        'Copied to Clipboard',
        style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 13),
      ),
      messageText: Text(
        '$label ($text) has been copied.',
        style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12),
      ),
      icon: const Icon(Icons.check_circle_outline, color: Color(0xFF4ADE80), size: 20),
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF1E1E24),
      margin: const EdgeInsets.only(top: 16, left: 20, right: 20),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  void _submitInquiry() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final inquiryCtrl = Get.find<InquiryController>();

      inquiryCtrl
          .submitInquiry(
        name: name,
        email: email,
        subject: _subjectController.text.trim(),
        message: _messageController.text.trim(),
      )
          .then((success) {
        if (success) {
          _nameController.clear();
          _emailController.clear();
          _subjectController.clear();
          _messageController.clear();

          Get.rawSnackbar(
            titleText: Text(
              'Your Message Has Been Sent!',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 13.5),
            ),
            messageText: Text(
              'Thank you, $name! Our support team will respond within 2 hours.',
              style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12),
            ),
            icon: const Icon(Icons.check_circle_outline, color: Color(0xFF4ADE80), size: 22),
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFF1E1E24),
            margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
            borderRadius: 12,
            duration: const Duration(seconds: 4),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Styled Light Banner matching storefront
            _buildHeroBanner(),

            // Main Content Area
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1140),
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 32 : 16,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button Row
                    _buildBackToWebsiteButton(context),
                    const SizedBox(height: 20),

                    // Contact Channels Grid
                    _buildContactChannels(isDesktop),
                    const SizedBox(height: 32),

                    // Two-Column Section: Inquiry Form + FAQ
                    if (isDesktop)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 6, child: _buildSupportInquiryCard()),
                          const SizedBox(width: 24),
                          Expanded(flex: 5, child: _buildFAQSection()),
                        ],
                      )
                    else ...[
                      _buildSupportInquiryCard(),
                      const SizedBox(height: 24),
                      _buildFAQSection(),
                    ],

                    const SizedBox(height: 32),

                    // Bottom Navigation Strip
                    _buildBottomActionStrip(context),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: Color(0xFFF7D8DE)),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 16, color: AppColors.textDark),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppAssets.appLogoMark,
            height: 24,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.support_agent, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 10),
          Text(
            'Stylito Support & Help Center',
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.storefront, size: 16, color: AppColors.primary),
            label: Text(
              'Back to Website',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
                color: AppColors.primary,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFFFF0F2),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Color(0xFFF7D8DE)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFF5F7), Color(0xFFFAFAFA)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(
          bottom: BorderSide(color: Color(0xFFF7D8DE), width: 1),
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF7D8DE)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.headset_mic_outlined, size: 13, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      '24/7 CUSTOMER SUPPORT & HELP DESK',
                      style: GoogleFonts.montserrat(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'How Can We Help You Today?',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Get quick assistance with your orders, deliveries, returns, exchanges, sizing, and payments.',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 13.5,
                  color: AppColors.textMuted,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackToWebsiteButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFF7D8DE)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_back, size: 15, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              'Back to Website / Home',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactChannels(bool isDesktop) {
    final cards = [
      _channelCard(
        icon: Icons.email_outlined,
        badge: '24/7 Priority Mail',
        title: 'Email Support',
        val: 'support@stylito.com',
        details: 'Send queries regarding orders, billing, refunds, and feedback. Average response: < 2 hours.',
        actionLabel: 'Send Email',
        onAction: () => AppLauncher.launchEmail(email: 'support@stylito.com', subject: 'Stylito Customer Support Inquiry'),
        onCopy: () => _copyToClipboard('support@stylito.com', 'Email Address'),
      ),
      _channelCard(
        icon: Icons.phone_outlined,
        badge: 'Mon - Sat: 9 AM - 8 PM IST',
        title: 'Call Support Helpline',
        val: '+91 98765 43210',
        details: 'Direct toll-free telephonic assistance in English, Hindi, and Gujarati with dedicated style advisors.',
        actionLabel: 'Call Now',
        onAction: () => AppLauncher.launchPhone('+919876543210'),
        onCopy: () => _copyToClipboard('+919876543210', 'Phone Number'),
      ),
      _channelCard(
        icon: Icons.chat_bubble_outline,
        badge: 'Instant Real-time Chat',
        title: 'WhatsApp Support',
        val: '+91 98765 43210',
        details: 'Fastest response for real-time delivery updates, order address modifications, and instant return pickups.',
        actionLabel: 'Chat on WhatsApp',
        onAction: () => AppLauncher.launchWebUrl('https://wa.me/919876543210'),
        onCopy: () => _copyToClipboard('+919876543210', 'WhatsApp Number'),
      ),
      _channelCard(
        icon: Icons.location_on_outlined,
        badge: 'Corporate Office',
        title: 'Stylito Headquarters',
        val: 'Surat, Gujarat, India',
        details: 'Stylito Technologies Inc., 4th Floor, Fashion Hub, Ring Road, Surat, Gujarat - 395007.',
        actionLabel: 'Copy Address',
        onAction: () => _copyToClipboard('Fashion Hub, Stylito Towers, Ring Road, Surat, Gujarat, 395007', 'Office Address'),
        onCopy: null,
      ),
    ];

    if (isDesktop) {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        childAspectRatio: 1.85,
        children: cards,
      );
    } else {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 14), child: c)).toList(),
      );
    }
  }

  Widget _channelCard({
    required IconData icon,
    required String badge,
    required String title,
    required String val,
    required String details,
    required String actionLabel,
    required VoidCallback onAction,
    VoidCallback? onCopy,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF7D8DE)),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFF7D8DE)),
                      ),
                      child: Text(
                        badge,
                        style: GoogleFonts.montserrat(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SelectableText(
            val,
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          Text(
            details,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              fontSize: 11.5,
              color: AppColors.textMuted,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    actionLabel,
                    style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              if (onCopy != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy, size: 15, color: AppColors.textMuted),
                  tooltip: 'Copy',
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF0F2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Color(0xFFF7D8DE)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSupportInquiryCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF7D8DE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.send_outlined, color: AppColors.primary, size: 18),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send Direct Support Message',
                      style: GoogleFonts.montserrat(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'We usually reply within 2 hours',
                      style: GoogleFonts.montserrat(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    style: GoogleFonts.montserrat(fontSize: 12.5),
                    decoration: InputDecoration(
                      labelText: 'Your Name *',
                      labelStyle: GoogleFonts.montserrat(fontSize: 11.5, color: AppColors.textMuted),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFF7D8DE)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFF7D8DE)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _emailController,
                    style: GoogleFonts.montserrat(fontSize: 12.5),
                    decoration: InputDecoration(
                      labelText: 'Your Email *',
                      labelStyle: GoogleFonts.montserrat(fontSize: 11.5, color: AppColors.textMuted),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFF7D8DE)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFF7D8DE)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                    ),
                    validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _subjectController,
              style: GoogleFonts.montserrat(fontSize: 12.5),
              decoration: InputDecoration(
                labelText: 'Inquiry Subject / Order ID *',
                labelStyle: GoogleFonts.montserrat(fontSize: 11.5, color: AppColors.textMuted),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFF7D8DE)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFF7D8DE)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Enter subject' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _messageController,
              maxLines: 4,
              style: GoogleFonts.montserrat(fontSize: 12.5),
              decoration: InputDecoration(
                labelText: 'How can our team help you? *',
                labelStyle: GoogleFonts.montserrat(fontSize: 11.5, color: AppColors.textMuted),
                alignLabelWithHint: true,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFF7D8DE)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFF7D8DE)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
              validator: (v) => v == null || v.length < 5 ? 'Message must be at least 5 characters' : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _submitInquiry,
              icon: const Icon(Icons.send, size: 15),
              label: Text(
                'Submit Inquiry',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    final faqs = [
      {
        'q': 'How do I track my Stylito order delivery?',
        'a': 'You will receive an instant tracking link via SMS & email as soon as your package is dispatched from our fulfillment center.',
      },
      {
        'q': 'What is Stylito\'s return and exchange policy?',
        'a': 'We offer a hassle-free 7-day doorstep return and instant size exchange policy on all authentic apparel and footwear.',
      },
      {
        'q': 'How are refunds credited to my account?',
        'a': 'Refunds are automatically processed back to your original payment method (Bank account, UPI, Card) within 24-48 hours.',
      },
      {
        'q': 'Are online payments secure on Stylito?',
        'a': 'Yes, all transactions are 256-bit SSL encrypted and processed through RBI-authorized payment gateways.',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF7D8DE)),
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
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.help_outline, color: AppColors.primary, size: 19),
              ),
              const SizedBox(width: 12),
              Text(
                'Frequently Asked Questions',
                style: GoogleFonts.montserrat(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...faqs.map(
            (faq) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5F7),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFF7D8DE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 14, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          faq['q']!,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    faq['a']!,
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionStrip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF7D8DE)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ready to resume shopping?',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  'Explore 50,000+ handpicked authentic trends on the Stylito storefront.',
                  style: GoogleFonts.montserrat(fontSize: 11.5, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.storefront, size: 16),
            label: Text(
              'Back to Website',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
