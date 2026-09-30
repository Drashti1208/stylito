import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../models/product_model.dart';
import '../cart/shopping_bag_screen.dart';
import '../catalog/trending_products_screen.dart';
import '../product_details/product_details_screen.dart';
import '../profile/profile_screen.dart';
import '../wishlist/wishlist_screen.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/contact_and_store_details_sheet.dart';
import '../widgets/play_store_download_dialog.dart';
import '../widgets/google_account_picker_sheet.dart';
import '../widgets/phone_otp_dialog.dart';

class StylishWebsiteView extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const StylishWebsiteView({super.key, this.onNavigateTab});

  @override
  State<StylishWebsiteView> createState() => _StylishWebsiteViewState();
}

class _StylishWebsiteViewState extends State<StylishWebsiteView> {
  final TextEditingController _newsletterController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'ALL';

  @override
  void dispose() {
    _newsletterController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ShoppingBagScreen(showBackButton: true),
      ),
    );
  }

  void _openWishlist() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const WishlistScreen(),
      ),
    );
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfileScreen(showBackButton: true),
      ),
    );
  }

  void _openBottomContactDetails() {
    ContactAndStoreDetailsSheet.show(context);
  }

  void _openAccountSwitcherModal() {
    final authController = Get.find<AuthController>();
    final user = authController.userProfile;
    final userName = user.name.isNotEmpty
        ? user.name
        : (user.email.isNotEmpty ? user.email.split('@')[0] : '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                const SizedBox(height: 20),
                // Current User Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFFFFA987), Color(0xFFF87189)],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName.isNotEmpty ? user.name : 'Valued Customer',
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.email.isNotEmpty
                                  ? user.email
                                  : (user.phone.isNotEmpty ? user.phone : 'Active Stylito Member'),
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: const Color(0xFF64748B),
                              ),


                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                userName.isNotEmpty ? 'Active Session' : 'Guest Mode',
                                style: GoogleFonts.montserrat(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF166534),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'CHANGE LOGIN / SWITCH ACCOUNT',
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 12),
                // Switch Google Account
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    GoogleAccountPickerSheet.show(context);
                  },
                  icon: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'G',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF4285F4),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  label: Text(
                    'Change Google ID',
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 10),
                // Switch Phone OTP
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    PhoneOtpDialog.show(context);
                  },
                  icon: const Icon(Icons.phone_android, color: Color(0xFF0F172A), size: 20),
                  label: Text(
                    'Change Phone OTP',
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 10),
                // Manage Profile & Address
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _openProfile();
                  },
                  icon: const Icon(Icons.badge_outlined, color: Color(0xFF475569), size: 20),
                  label: Text(
                    'Manage Profile & Delivery Address',
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                if (userName.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      authController.logout();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logged out successfully!'),
                          backgroundColor: Color(0xFF1E293B),
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout, color: Color(0xFFDC2626), size: 18),
                    label: Text(
                      'Sign Out / Log Out',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFDC2626),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEE2E2),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }



  void _openCatalog([String? categoryFilter]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TrendingProductsScreen(),
      ),
    );
  }

  void _openProduct(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Get.find<CartController>();
    final wishlistProvider = Get.find<WishlistController>();
    final allProducts = ProductModel.sampleProducts;

    final displayedProducts = _selectedCategory == 'ALL'
        ? allProducts
        : allProducts.where((p) => p.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 1. GLOBAL NAVIGATION BAR (Announcement bar deleted as requested)
              _buildNavBar(cartProvider.itemCount, wishlistProvider.items.length),

              // 2. EDITORIAL HERO BANNER
              _buildHeroBanner(),

              const SizedBox(height: 56),

              // 3. SHOP BY CATEGORY SECTION
              _buildShopByCategory(),

              const SizedBox(height: 64),

              // 4. NEW ARRIVALS PRODUCT GRID
              _buildNewArrivals(displayedProducts),

              const SizedBox(height: 72),

              // 5. TRUST & VALUE PROPOSITIONS STRIP
              _buildTrustStrip(),

              const SizedBox(height: 64),

              // 6. MID-PAGE EDITORIAL PROMO BANNER (SUMMER REFRESH)
              _buildSummerRefreshBanner(),

              const SizedBox(height: 72),

              // 7. COMMUNITY GALLERY STRIP (#STYLISHSTYLE)
              _buildCommunityGallery(),

              const SizedBox(height: 64),

              // 8. STAY IN THE KNOW NEWSLETTER BAR
              _buildNewsletterStrip(),

              // 9. LUXURY DARK FOOTER
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 1. LUXURY DESKTOP / MOBILE NAVIGATION BAR
  // -------------------------------------------------------------
  Widget _buildNavBar([int cartCount = 0, int wishlistCount = 0]) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 880;
        return Container(
          height: isMobile ? 60 : 76,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
            ),
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1280),
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 32),
              child: isMobile
                  ? Row(
                      children: [
                        // Back button (if can pop)
                        if (Navigator.of(context).canPop()) ...[
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B), size: 22),
                            onPressed: () => Navigator.of(context).maybePop(),
                            tooltip: 'Back',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          ),
                          const SizedBox(width: 4),
                        ],
                        // Brand Logo (Constrained to never overlap or cause RenderFlex overflow)
                        InkWell(
                          onTap: _openBottomContactDetails,
                          borderRadius: BorderRadius.circular(8),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 110, maxHeight: 28),
                            child: Image.asset(
                              AppAssets.logo,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Wishlist Icon
                        IconButton(
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                          icon: Badge(
                            isLabelVisible: wishlistCount > 0,
                            label: Text('$wishlistCount', style: const TextStyle(fontSize: 10)),
                            backgroundColor: AppColors.primary,
                            child: const Icon(Icons.favorite_border, color: Color(0xFF1B1B1B), size: 20),
                          ),
                          onPressed: _openWishlist,
                          tooltip: 'Wishlist',
                        ),
                        // Cart Icon
                        IconButton(
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                          icon: Badge(
                            isLabelVisible: cartCount > 0,
                            label: Text('$cartCount', style: const TextStyle(fontSize: 10)),
                            backgroundColor: AppColors.primary,
                            child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF1B1B1B), size: 20),
                          ),
                          onPressed: _openCart,
                          tooltip: 'Shopping Bag',
                        ),
                        const SizedBox(width: 4),
                        // Profile Greeting or Avatar
                        Obx(() {
                          final auth = Get.find<AuthController>();
                          final user = auth.userProfile;
                          final userName = user.name.isNotEmpty
                              ? user.name
                              : (user.email.isNotEmpty ? user.email.split('@')[0] : '');

                          if (userName.isNotEmpty) {
                            return InkWell(
                              onTap: _openAccountSwitcherModal,
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF10B981),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Hi, ${userName.split(' ')[0]}',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 14,
                                      color: Color(0xFF64748B),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                              return InkWell(
                                onTap: _openAccountSwitcherModal,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [Color(0xFFFFA987), Color(0xFFF87189)],
                                    ),
                                  ),
                                  child: const Icon(Icons.person_outline, size: 18, color: Colors.white),
                                ),
                              );
                            }
                          }),
                      ],
                    )
                  : Row(
                      children: [
                        // Brand Logo on the left (Click opens bottom details / contact)
                        InkWell(
                          onTap: _openBottomContactDetails,
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            AppAssets.logo,
                            height: 36,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                          ),
                        ),

                        const Spacer(),

                        // Right side: All names (NEW IN, CLOTHING, BRAND, SALE, CONTACT) + Profile Logo
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _navLink('NEW IN', isSelected: _selectedCategory == 'ALL', onTap: () {
                                setState(() => _selectedCategory = 'ALL');
                              }),
                              _navLink('CLOTHING', onTap: () => _openCatalog()),
                              _navLink('BRAND', onTap: () => _openCatalog('brand')),
                              _navLink(
                                'SALE',
                                isSale: true,
                                onTap: () => _openCatalog('sale'),
                              ),
                              _navLink('CONTACT', onTap: _openBottomContactDetails),
                              const SizedBox(width: 14),

                              // User Greeting (when logged in, coral icon is removed) or Profile Avatar (when logged out)
                              Obx(() {
                                final auth = Get.find<AuthController>();
                                final user = auth.userProfile;
                                final userName = user.name.isNotEmpty
                                    ? user.name
                                    : (user.email.isNotEmpty ? user.email.split('@')[0] : '');

                                if (userName.isNotEmpty) {
                                  // Logged in: Hide coral icon, show interactive greeting badge
                                  return InkWell(
                                    onTap: _openAccountSwitcherModal,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: const Color(0xFFE2E8F0)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 7,
                                            height: 7,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFF10B981),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Hi, ${userName.split(' ')[0]}',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF0F172A),
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          const Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 16,
                                            color: Color(0xFF64748B),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  // Logged out: Show coral profile button
                                  return InkWell(
                                    onTap: _openAccountSwitcherModal,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      width: 36,
                                      height: 36,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [Color(0xFFFFA987), Color(0xFFF87189)],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x33F83758),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.person_outline,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _navLink(String title, {bool isSelected = false, bool isSale = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: isSelected || isSale ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 1.5,
                  color: isSale
                      ? AppColors.primary
                      : isSelected
                          ? const Color(0xFF111111)
                          : const Color(0xFF555555),
                ),
              ),
              const SizedBox(height: 3),
              Container(
                height: 2,
                width: isSelected ? 20 : 0,
                color: isSale ? AppColors.primary : const Color(0xFF111111),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 3. EDITORIAL HERO BANNER (ELEVATED STYLE. EVERYDAY YOU.)
  // -------------------------------------------------------------
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE67F82), Color(0xFFE4777C), Color(0xFFDC6D73)],
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 52),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 780;
              final content = Column(
                crossAxisAlignment: isNarrow ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      'NEW SEASON COLLECTION',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Elevated Style.\nEveryday You.',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: isNarrow ? 36 : 56,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          color: Color(0x33000000),
                          offset: Offset(0, 4),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    textAlign: isNarrow ? TextAlign.center : TextAlign.start,
                  ),
                  const SizedBox(height: 18),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Text(
                      'Timeless pieces. Modern silhouettes. Designed to elevate your everyday confidence with luxury fashion.',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.94),
                        height: 1.6,
                      ),
                      textAlign: isNarrow ? TextAlign.center : TextAlign.start,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Column(
                    crossAxisAlignment: isNarrow ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () => _openCatalog(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFF83758),
                          elevation: 6,
                          shadowColor: const Color(0x33F83758),
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'SHOP NEW ARRIVALS',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, size: 16, color: Color(0xFFF83758)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      const PlayStoreAnimatedButton(),
                    ],
                  ),
                ],
              );

              final heroImage = Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: isNarrow ? 300 : 420,
                  maxWidth: isNarrow ? double.infinity : 640,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x52A0283C),
                      blurRadius: 36,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 3 / 2,
                    child: Image.asset(
                      AppAssets.heroFashion,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              );

              if (isNarrow) {
                return Column(
                  children: [
                    heroImage,
                    const SizedBox(height: 32),
                    content,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(flex: 5, child: content),
                  const SizedBox(width: 48),
                  Expanded(flex: 6, child: heroImage),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 4. SHOP BY CATEGORY (CIRCULAR THUMBNAILS)
  // -------------------------------------------------------------
  Widget _buildShopByCategory() {
    final categories = [
      {'title': 'DRESSES', 'image': AppAssets.catWomens, 'cat': 'womens'},
      {'title': 'TOPS', 'image': AppAssets.catFashion, 'cat': 'fashion'},
      {'title': 'BOTTOMS', 'image': AppAssets.catMens, 'cat': 'mens'},
      {'title': 'BEAUTY', 'image': AppAssets.catBeauty, 'cat': 'beauty'},
      {'title': 'KIDS', 'image': AppAssets.catKids, 'cat': 'kids'},
      {'title': 'SALE', 'image': AppAssets.banner50Off, 'cat': 'sale'},
    ];

    return Container(
      constraints: const BoxConstraints(maxWidth: 1280),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Text(
            'SHOP BY CATEGORY',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.5,
              color: const Color(0xFF1B1B1B),
            ),
          ),
          const SizedBox(height: 36),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: categories.map((c) {
                final isSelected = _selectedCategory.toLowerCase() == (c['cat'] as String).toLowerCase();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCategory = c['cat'] as String;
                      });
                    },
                    borderRadius: BorderRadius.circular(60),
                    child: Column(
                      children: [
                        Container(
                          width: 105,
                          height: 105,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : const Color(0xFFE2DDD7),
                              width: isSelected ? 2.5 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              c['image'] as String,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          c['title'] as String,
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            letterSpacing: 1.5,
                            color: isSelected ? AppColors.primary : const Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 5. NEW ARRIVALS PRODUCT GRID (4-COLUMN)
  // -------------------------------------------------------------
  Widget _buildNewArrivals(List<ProductModel> products) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1280),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Text(
            'NEW ARRIVALS',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.5,
              color: const Color(0xFF1B1B1B),
            ),
          ),
          const SizedBox(height: 40),

          // 4-Column Responsive Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              int crossAxisCount = 4;
              if (width < 600) {
                crossAxisCount = 2;
              } else if (width < 960) {
                crossAxisCount = 3;
              }

              final displayList = products.take(8).toList();

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: width < 600 ? 14 : 24,
                  mainAxisSpacing: width < 600 ? 20 : 32,
                  childAspectRatio: width < 600 ? 0.58 : 0.62,
                ),
                itemBuilder: (context, index) {
                  return _buildProductTile(displayList[index]);
                },
              );
            },
          ),

          const SizedBox(height: 48),

          // VIEW ALL NEW ARRIVALS BUTTON
          OutlinedButton(
            onPressed: () => _openCatalog(),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF111111),
              side: const BorderSide(color: Color(0xFF111111), width: 1.2),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            ),
            child: Text(
              'VIEW ALL NEW ARRIVALS',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTile(ProductModel product) {
    final wishlistProvider = Get.find<WishlistController>();
    final cartProvider = Get.find<CartController>();
    final isFav = wishlistProvider.isWishlisted(product.id);

    return InkWell(
      onTap: () => _openProduct(product),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container with Heart and Discount Badge
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Image.asset(
                      product.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),

                // Top Left Discount Badge
                if (product.discountPercent > 0)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        '${product.discountPercent}% OFF',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),

                // Top Right Wishlist Heart Icon
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: () {
                      wishlistProvider.toggleWishlist(product);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: isFav ? AppColors.primary : const Color(0xFF444444),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Product Title
          Text(
            product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF222222),
            ),
          ),

          const SizedBox(height: 4),

          // Price and Original Price
          Row(
            children: [
              Text(
                '\u20B9${product.price.toStringAsFixed(0)}',
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111111),
                ),
              ),
              const SizedBox(width: 8),
              if (product.originalPrice > product.price)
                Text(
                  '\u20B9${product.originalPrice.toStringAsFixed(0)}',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: const Color(0xFF999999),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          // Color Swatch Dots (Matching the screenshot aesthetic)
          Row(
            children: [
              _colorDot(const Color(0xFFD6C8B4)),
              const SizedBox(width: 6),
              _colorDot(const Color(0xFF2B2B2B)),
              const SizedBox(width: 6),
              _colorDot(const Color(0xFFE4A4A9)),
              const Spacer(),
              // Quick Add to Bag
              InkWell(
                onTap: () {
                  cartProvider.addItem(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${product.title} to bag!'),
                      duration: const Duration(seconds: 2),
                      backgroundColor: const Color(0xFF111111),
                      action: SnackBarAction(
                        label: 'VIEW BAG',
                        textColor: AppColors.primary,
                        onPressed: _openCart,
                      ),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.add_shopping_cart, size: 16, color: Color(0xFF666666)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _colorDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 2,
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 6. TRUST & VALUE PROPOSITIONS STRIP (4 ITEMS)
  // -------------------------------------------------------------
  Widget _buildTrustStrip() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFFF9FA), // Soft subtle pink tone matching landing page
      padding: const EdgeInsets.symmetric(vertical: 36),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 900;
              final items = [
                _trustItem(
                  icon: Icons.local_shipping_outlined,
                  iconColor: const Color(0xFFF83758),
                  bgColor: const Color(0xFFFFE8EC),
                  title: 'Free Shipping',
                  subtitle: 'On all orders over \u20B9999',
                ),
                _trustItem(
                  icon: Icons.replay_outlined,
                  iconColor: const Color(0xFF2563EB),
                  bgColor: const Color(0xFFEBF3FF),
                  title: 'Easy Returns',
                  subtitle: '30 days return policy',
                ),
                _trustItem(
                  icon: Icons.lock_outline,
                  iconColor: const Color(0xFF059669),
                  bgColor: const Color(0xFFE6F9F0),
                  title: 'Secure Payment',
                  subtitle: '100% verified checkout',
                ),
                _trustItem(
                  icon: Icons.verified_outlined,
                  iconColor: const Color(0xFFD97706),
                  bgColor: const Color(0xFFFFF6E5),
                  title: 'Quality Guarantee',
                  subtitle: 'Premium materials',
                ),
              ];

              if (isNarrow) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: items.map((e) => SizedBox(width: constraints.maxWidth < 540 ? double.infinity : 240, child: e)).toList(),
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: items.map((e) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: e))).toList(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _trustItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF5EBE8)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1B1B1B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    color: const Color(0xFF777777),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 7. MID-PAGE EDITORIAL BANNER (SUMMER REFRESH)
  // -------------------------------------------------------------
  Widget _buildSummerRefreshBanner() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1280),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 780;

          final leftImage = Container(
            height: isNarrow ? 260 : 380,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.zero,
            ),
            child: Image.asset(
              AppAssets.hotSummerSale,
              width: double.infinity,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          );

          final rightContent = Container(
            height: isNarrow ? null : 380,
            padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 40),
            color: const Color(0xFFF3EEE8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'LIMITED TIME ONLY',
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.5,
                    color: const Color(0xFF888888),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Summer Refresh',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: isNarrow ? 28 : 42,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1B1B1B),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Enjoy up to 50% off selected styles.',
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: const Color(0xFF666666),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _openCatalog('sale'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111111),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child: Text(
                    'SHOP THE SALE',
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ],
            ),
          );

          if (isNarrow) {
            return Column(
              children: [
                leftImage,
                rightContent,
              ],
            );
          }

          return Row(
            children: [
              Expanded(flex: 5, child: leftImage),
              Expanded(flex: 6, child: rightContent),
            ],
          );
        },
      ),
    );
  }

  // -------------------------------------------------------------
  // 8. COMMUNITY GALLERY STRIP (#STYLISHSTYLE)
  // -------------------------------------------------------------
  Widget _buildCommunityGallery() {
    final List<String> images = [
      AppAssets.productFlareDress,
      AppAssets.productBlackWinter,
      AppAssets.shoesCrisp,
      AppAssets.heelsBanner,
      AppAssets.productMensStarry,
      AppAssets.productKurta,
    ];

    return Column(
      children: [
        Text(
          '#STYLISHSTYLE',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.5,
            color: const Color(0xFF1B1B1B),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Tag @stylish_fashion to be featured.',
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: const Color(0xFF888888),
          ),
        ),
        const SizedBox(height: 28),

        Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - (5 * 12)) / 6;
              if (itemWidth < 120) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: images.map((img) {
                      return InkWell(
                        onTap: () {
                          if (img == AppAssets.heelsBanner) {
                            Navigator.pushNamed(context, AppRoutes.flatAndHeels);
                          } else {
                            _openCatalog();
                          }
                        },
                        child: Container(
                          width: 140,
                          height: 140,
                          margin: const EdgeInsets.only(right: 12),
                          child: Image.asset(img, fit: BoxFit.cover),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }

              return Row(
                children: images.map((img) {
                  return Expanded(
                    child: InkWell(
                      onTap: () {
                        if (img == AppAssets.heelsBanner) {
                          Navigator.pushNamed(context, AppRoutes.flatAndHeels);
                        } else {
                          _openCatalog();
                        }
                      },
                      child: Container(
                        height: itemWidth,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        child: Image.asset(
                          img,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // 9. STAY IN THE KNOW NEWSLETTER STRIP
  // -------------------------------------------------------------
  Widget _buildNewsletterStrip() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF7F5F2),
      padding: const EdgeInsets.symmetric(vertical: 36),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 860;

              final leftSide = isNarrow
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.mail_outline, size: 28, color: Color(0xFF333333)),
                        const SizedBox(height: 10),
                        Text(
                          'STAY IN THE KNOW',
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.0,
                            color: const Color(0xFF1B1B1B),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Subscribe to get special offers, free giveaways, and once-in-a-lifetime deals.',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: const Color(0xFF777777),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.mail_outline, size: 28, color: Color(0xFF333333)),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'STAY IN THE KNOW',
                              style: GoogleFonts.montserrat(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0,
                                color: const Color(0xFF1B1B1B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Subscribe to get special offers, free giveaways, and once-in-a-lifetime deals.',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: const Color(0xFF777777),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );

              final rightInput = isNarrow
                  ? Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Center(
                            child: TextField(
                              controller: _newsletterController,
                              style: GoogleFonts.montserrat(fontSize: 12),
                              decoration: const InputDecoration(
                                hintText: 'Enter your email',
                                hintStyle: TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_newsletterController.text.trim().isNotEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Thank you for subscribing to Stylish!'),
                                    backgroundColor: Color(0xFF111111),
                                  ),
                                );
                                _newsletterController.clear();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            ),
                            child: Text(
                              'SUBSCRIBE',
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 260,
                          height: 44,
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Center(
                            child: TextField(
                              controller: _newsletterController,
                              style: GoogleFonts.montserrat(fontSize: 12),
                              decoration: const InputDecoration(
                                hintText: 'Enter your email',
                                hintStyle: TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_newsletterController.text.trim().isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Thank you for subscribing to Stylish!'),
                                  backgroundColor: Color(0xFF111111),
                                ),
                              );
                              _newsletterController.clear();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF111111),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            minimumSize: const Size(120, 44),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          ),
                          child: Text(
                            'SUBSCRIBE',
                            style: GoogleFonts.montserrat(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    );

              if (isNarrow) {
                return Column(
                  children: [
                    leftSide,
                    const SizedBox(height: 20),
                    rightInput,
                  ],
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  leftSide,
                  rightInput,
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 10. LUXURY DARK FOOTER
  // -------------------------------------------------------------
  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.only(top: 64, bottom: 32),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 780;

                  final brandCol = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STYLISH',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 240),
                        child: Text(
                          'Timeless style meets modern elegance. Designed for confidence in every thread.',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: const Color(0xFF888888),
                            height: 1.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          _socialIcon(Icons.camera_alt_outlined),
                          const SizedBox(width: 14),
                          _socialIcon(Icons.facebook_outlined),
                          const SizedBox(width: 14),
                          _socialIcon(Icons.share_outlined),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const PlayStoreAnimatedButton(),
                    ],
                  );

                  final cols = [
                    brandCol,
                    _footerColumn('SHOP', ['New In', 'Clothing', 'Dresses', 'Tops', 'Bottoms', 'Accessories', 'Sale']),
                    _footerColumn('CUSTOMER CARE', ['Shipping & Delivery', 'Returns', 'Size Guide', 'FAQ', 'Contact Us']),
                    _footerColumn('ABOUT', ['Our Story', 'Sustainability', 'Careers', 'Lookbook', 'Blog']),
                    _footerColumn('LEGAL', ['Terms & Conditions', 'Privacy Policy', 'Refund Policy']),
                  ];

                  if (isNarrow) {
                    return Wrap(
                      spacing: 32,
                      runSpacing: 32,
                      children: cols,
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: cols,
                  );
                },
              ),

              const SizedBox(height: 48),
              const Divider(color: Color(0xFF262626), height: 1),
              const SizedBox(height: 28),

              // Bottom row: Copyright + Payment badges
              LayoutBuilder(
                builder: (context, bConstraints) {
                  final isNarrow = bConstraints.maxWidth < 640;
                  if (isNarrow) {
                    return Column(
                      children: [
                        Text(
                          '\u00A9 2026 STYLISH. All Rights Reserved.',
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            color: const Color(0xFF777777),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            _paymentBadge('VISA'),
                            _paymentBadge('MC'),
                            _paymentBadge('AMEX'),
                            _paymentBadge('PAYPAL'),
                            _paymentBadge('UPI'),
                          ],
                        ),
                      ],
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\u00A9 2026 STYLISH. All Rights Reserved.',
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          color: const Color(0xFF777777),
                        ),
                      ),
                      Row(
                        children: [
                          _paymentBadge('VISA'),
                          const SizedBox(width: 8),
                          _paymentBadge('MC'),
                          const SizedBox(width: 8),
                          _paymentBadge('AMEX'),
                          const SizedBox(width: 8),
                          _paymentBadge('PAYPAL'),
                          const SizedBox(width: 8),
                          _paymentBadge('UPI'),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footerColumn(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: InkWell(
              onTap: () => _openCatalog(),
              child: Text(
                link,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: const Color(0xFF888888),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _socialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF444444)),
      ),
      child: Icon(icon, size: 14, color: Colors.white),
    );
  }

  Widget _paymentBadge(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Text(
        name,
        style: GoogleFonts.montserrat(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFCCCCCC),
        ),
      ),
    );
  }
}
