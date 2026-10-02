import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/inquiry_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_launcher.dart';
import '../../models/product_model.dart';
import '../profile/profile_screen.dart';
import '../widgets/google_account_picker_sheet.dart';
import '../widgets/phone_otp_dialog.dart';
import '../widgets/play_store_download_dialog.dart';
import '../widgets/app_image.dart';
import '../widgets/stylish_logo.dart';

class LandingPageScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const LandingPageScreen({super.key, this.onNavigateTab});

  @override
  State<LandingPageScreen> createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends State<LandingPageScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _inquiryNameController = TextEditingController();
  final TextEditingController _inquiryEmailController = TextEditingController();
  final TextEditingController _inquirySubjectController = TextEditingController();
  final TextEditingController _inquiryMessageController = TextEditingController();
  final _inquiryFormKey = GlobalKey<FormState>();

  final ScrollController _mainScrollController = ScrollController();
  final GlobalKey _newArrivalsKey = GlobalKey();
  final GlobalKey _categoryKey = GlobalKey();
  final GlobalKey _promoSaleKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  String _selectedCategory = 'ALL';
  String _activeNavTab = 'NEW IN';
  String _activeCarouselButton = 'left';
  int _currentHeroBannerIndex = 0;
  final PageController _heroPageController = PageController();
  final ScrollController _newArrivalsScrollController = ScrollController();

  final List<Map<String, dynamic>> _heroBanners = [
    {
      'eyebrow': 'NEW SEASON COLLECTION',
      'title': 'Elevated Style.\nEveryday You.',
      'subtitle': 'Timeless pieces. Modern silhouettes. Designed to elevate your everyday.',
      'buttonText': 'SHOP NEW ARRIVALS',
      'category': 'ALL',
      'image': 'assets/images/hero_flatlay_pink_accessories_hd.jpg',
      'fallbackGradient': [Color(0xFFF9A8B6), Color(0xFFF83758)],
    },
    {
      'eyebrow': 'SEASON SALE - FLAT 50% OFF',
      'title': 'Style Unleashed.\nSummer Essentials.',
      'subtitle': 'Explore curated designer cuts, premium cottons & lightweight layers.',
      'buttonText': 'EXPLORE SALE',
      'category': 'fashion',
      'image': 'assets/images/hero_flatlay_pink_outfit_hd.jpg',
      'fallbackGradient': [Color(0xFFFFA987), Color(0xFFF87189)],
    },
    {
      'eyebrow': 'URBAN ACTIVEWEAR',
      'title': 'Streetwear &\nPerformance Sneakers.',
      'subtitle': 'Engineered comfort meets trendsetting cuts for everyday living.',
      'buttonText': 'VIEW MENSWEAR',
      'category': 'mens',
      'image': 'assets/images/hero_fashion.png',
      'fallbackGradient': [Color(0xFF38BDF8), Color(0xFF2563EB)],
    },
    {
      'eyebrow': 'EXCLUSIVE FOOTWEAR',
      'title': 'Luxury Stilettos &\nDesigner Flats.',
      'subtitle': 'Crafted with premium Italian finishes for maximum elegance.',
      'buttonText': 'VIEW FOOTWEAR',
      'category': 'flat-and-heels',
      'image': 'assets/images/heels_banner.png',
      'fallbackGradient': [Color(0xFFA855F7), Color(0xFFEC4899)],
    },
  ];

  // 6 Categories matching reference image 1, 2 and 3
  final List<Map<String, String>> _categories = [
    {
      'name': 'DRESSES',
      'slug': 'Dresses',
      'image': 'assets/images/product_flare_dress.png',
    },
    {
      'name': 'TOPS',
      'slug': 'Tops',
      'image': 'assets/images/product_denim_dress.png',
    },
    {
      'name': 'BOTTOMS',
      'slug': 'Bottoms',
      'image': 'assets/images/cat_womens.png',
    },
    {
      'name': 'ACCESSORIES',
      'slug': 'Accessories',
      'image': 'assets/images/product_camera.png',
    },
    {
      'name': 'OUTERWEAR',
      'slug': 'Outerwear',
      'image': 'assets/images/product_nike_shop.png',
    },
    {
      'name': 'SALE',
      'slug': 'Sale',
      'image': 'assets/images/cat_mens.png',
    },
  ];

  // Exact 8 Products from original HTML Landing Page (Matching Image 1 & 2)
  final List<ProductModel> _landingProducts = [
    const ProductModel(
      id: 'prod-black-dress',
      title: 'Black Dress',
      subtitle: 'Solid Black Dress for Women, Sexy Chain Shorts Ladi...',
      description: 'Solid Black Dress for Women, Sexy Chain Shorts Ladies Evening Gown with premium stretch fabric and timeless silhouette.',
      price: 2000.0,
      originalPrice: 3500.0,
      discountPercent: 43,
      rating: 4.5,
      reviewCount: 523456,
      imageUrl: 'assets/images/product_black_dress.png',
      category: 'Dresses',
      isNewArrival: true,
    ),
    const ProductModel(
      id: 'prod-pink-embroidered',
      title: 'Pink Embroidered Maxi',
      subtitle: 'EARTHEN Rose Pink Embroidered Tiered Max...',
      description: 'EARTHEN Rose Pink Embroidered Tiered Maxi Dress crafted with handcrafted gold embroidery and lightweight chiffon flow.',
      price: 1900.0,
      originalPrice: 2800.0,
      discountPercent: 32,
      rating: 4.5,
      reviewCount: 45678,
      imageUrl: 'assets/images/product_pink_dress.png',
      category: 'Dresses',
      isNewArrival: true,
    ),
    const ProductModel(
      id: 'prod-flare-dress',
      title: 'Flare Dress',
      subtitle: 'Antheaa Black & Rust Orange Floral Print Tiered Midi F...',
      description: 'Antheaa Black & Rust Orange Floral Print Tiered Midi Flare Dress featuring a flattering smocked waist and breathable weave.',
      price: 1990.0,
      originalPrice: 2999.0,
      discountPercent: 33,
      rating: 4.5,
      reviewCount: 335566,
      imageUrl: 'assets/images/product_flare_dress.png',
      category: 'Dresses',
      isNewArrival: true,
    ),
    const ProductModel(
      id: 'prod-denim-dress',
      title: 'Denim Dress',
      subtitle: 'Blue cotton denim dress',
      description: 'Premium light-wash blue cotton denim shorts dress with an elasticized smocked waist, front buttons, and durable breathable finish.',
      price: 1499.0,
      originalPrice: 2499.0,
      discountPercent: 40,
      rating: 4.6,
      reviewCount: 89120,
      imageUrl: 'assets/images/product_denim_dress.png',
      category: 'Dresses',
      isNewArrival: true,
    ),
    const ProductModel(
      id: 'prod-mens-starry',
      title: '100% Cotton Fabric',
      subtitle: 'Mens Starry Sky Printed Shirt 100% Cotton Fabric',
      description: 'Mens Starry Sky Printed Shirt 100% Cotton Fabric designed for all-day breathability and relaxed streetwear elegance.',
      price: 399.0,
      originalPrice: 799.0,
      discountPercent: 50,
      rating: 4.5,
      reviewCount: 152344,
      imageUrl: 'assets/images/product_mens_starry.png',
      category: 'Tops',
      isNewArrival: true,
    ),
    const ProductModel(
      id: 'prod-black-winter',
      title: 'Black Winter Overcoat',
      subtitle: 'Autumn And Winter Casual cotton-padded jacket...',
      description: 'Autumn And Winter Casual cotton-padded jacket with warm fleece lining, multi-pocket utility design, and thermal hood.',
      price: 2499.0,
      originalPrice: 4999.0,
      discountPercent: 50,
      rating: 4.7,
      reviewCount: 68900,
      imageUrl: 'assets/images/product_black_winter.png',
      category: 'Outerwear',
      isNewArrival: true,
    ),
    const ProductModel(
      id: 'prod-leather-jacket',
      title: 'Leather Biker Jacket',
      subtitle: 'Premium Slim-Fit Faux Leather Jacket with Metal Zips',
      description: 'Premium Slim-Fit Faux Leather Jacket with Metal Zips, asymmetric front closure, and tailored structured fit.',
      price: 2999.0,
      originalPrice: 5999.0,
      discountPercent: 50,
      rating: 4.8,
      reviewCount: 112400,
      imageUrl: 'assets/images/product_leather_jacket.png',
      category: 'Outerwear',
      isNewArrival: true,
    ),
    const ProductModel(
      id: 'prod-hrx-sneakers',
      title: 'HRX Sports Sneakers',
      subtitle: 'Court-ready lightweight sneakers designed for active running',
      description: 'Court-ready lightweight sneakers designed for active running with high-traction rubber outsole and cushioned foam midsole.',
      price: 2499.0,
      originalPrice: 4999.0,
      discountPercent: 50,
      rating: 4.8,
      reviewCount: 344567,
      imageUrl: 'assets/images/product_hrx.png',
      category: 'Accessories',
      isNewArrival: true,
    ),
  ];

  List<ProductModel> get _currentProducts {
    final prodCtrl = Get.find<ProductController>();
    List<ProductModel> baseList = _landingProducts;
    if (prodCtrl.allProducts.isNotEmpty) {
      baseList = [
        ..._landingProducts,
        ...prodCtrl.allProducts.where((p) => !_landingProducts.any((lp) => lp.id == p.id)),
      ];
    }

    if (_selectedCategory.toUpperCase() == 'ALL') {
      return baseList;
    }
    if (_selectedCategory.toUpperCase() == 'SALE') {
      return baseList.where((p) => p.discountPercent >= 35).toList();
    }
    final catLower = _selectedCategory.toLowerCase();
    final filtered = baseList.where((p) {
      final pCat = p.category.toLowerCase();
      final pTitle = p.title.toLowerCase();
      return pCat.contains(catLower) || pTitle.contains(catLower);
    }).toList();

    return filtered.isNotEmpty ? filtered : baseList;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _inquiryNameController.dispose();
    _inquiryEmailController.dispose();
    _inquirySubjectController.dispose();
    _inquiryMessageController.dispose();
    _heroPageController.dispose();
    _newArrivalsScrollController.dispose();
    _mainScrollController.dispose();
    super.dispose();
  }

  void _scrollToKey(GlobalKey key, {String? navTab}) {
    if (navTab != null) {
      setState(() => _activeNavTab = navTab);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyContext = key.currentContext;
      if (keyContext != null) {
        Scrollable.ensureVisible(
          keyContext,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
          alignment: 0.05,
        );
      }
    });
  }

  void _openCart() {
    _SideCartDrawer.show(context);
  }

  void _openWishlist() {
    _SideWishlistDrawer.show(context);
  }

  void _openAuthDialog() {
    final auth = Get.find<AuthController>();
    if (auth.isLoggedIn) {
      _showUserMenu();
      return;
    }
    _StylishAuthModal.show(context);
  }

  void _showUserMenu() {
    final auth = Get.find<AuthController>();
    final user = auth.userProfile;
    final name = user.name.isNotEmpty ? user.name : 'aliya';
    final email = user.email.isNotEmpty ? user.email : 'aliya@gmail.com';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'A';

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'User Menu',
      barrierColor: Colors.black.withValues(alpha: 0.2),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (ctx, anim1, anim2) {
        return Align(
          alignment: Alignment.topRight,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 310,
              margin: const EdgeInsets.only(top: 64, right: 28),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top User Info (Matching Image 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFFF87189),
                            child: Text(
                              initial,
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  name,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  email,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    color: const Color(0xFF64748B),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),

                    // Menu items
                    _buildUserMenuItem(
                      icon: Icons.person_outline,
                      title: 'My Profile',
                      onTap: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(showBackButton: true),
                          ),
                        );
                      },
                    ),
                    _buildUserMenuItem(
                      icon: Icons.favorite_outline,
                      title: 'Wishlist',
                      onTap: () {
                        Navigator.pop(ctx);
                        _SideWishlistDrawer.show(context);
                      },
                    ),
                    _buildUserMenuItem(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Shopping Bag',
                      onTap: () {
                        Navigator.pop(ctx);
                        _SideCartDrawer.show(context);
                      },
                    ),
                    _buildUserMenuItem(
                      icon: Icons.headset_mic_outlined,
                      title: 'Contact Support',
                      onTap: () {
                        Navigator.pop(ctx);
                        _scrollToKey(_contactKey, navTab: 'CONTACT');
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    _buildUserMenuItem(
                      icon: Icons.logout,
                      title: 'Sign Out',
                      isDestructive: true,
                      onTap: () {
                        Navigator.pop(ctx);
                        auth.logout();
                        Get.rawSnackbar(
                          titleText: Text(
                            'Signed Out',
                            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13.5),
                          ),
                          messageText: Text(
                            'You have been logged out successfully.',
                            style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12),
                          ),
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: const Color(0xFF1E1E24),
                          margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
                          borderRadius: 12,
                        );
                      },
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic)),
            alignment: Alignment.topRight,
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildUserMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 19,
              color: isDestructive ? const Color(0xFFEF4444) : AppColors.primary,
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDestructive ? const Color(0xFFEF4444) : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitInquiry() {
    if (_inquiryFormKey.currentState?.validate() ?? false) {
      final name = _inquiryNameController.text.trim();
      final email = _inquiryEmailController.text.trim();
      final inquiryCtrl = Get.find<InquiryController>();

      inquiryCtrl.submitInquiry(
        name: name,
        email: email,
        subject: _inquirySubjectController.text.trim(),
        message: _inquiryMessageController.text.trim(),
      ).then((success) {
        if (success) {
          _inquiryNameController.clear();
          _inquiryEmailController.clear();
          _inquirySubjectController.clear();
          _inquiryMessageController.clear();

          Get.rawSnackbar(
            titleText: Text(
              'Your Message Has Been Sent!',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 13.5),
            ),
            messageText: Text(
              'Thank you, $name! Your message has been sent successfully.',
              style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12),
            ),
            icon: const Icon(Icons.check_circle_outline, color: Color(0xFF4ADE80), size: 22),
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFF1E1E24),
            margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
            borderRadius: 12,
            duration: const Duration(seconds: 4),
            boxShadows: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          );
        } else {
          Get.rawSnackbar(
            titleText: Text(
              'Failed to Send Message',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 13.5),
            ),
            messageText: Text(
              inquiryCtrl.lastSubmissionMessage.value.isNotEmpty
                  ? inquiryCtrl.lastSubmissionMessage.value
                  : 'Could not send your message. Please check your connection.',
              style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12),
            ),
            icon: const Icon(Icons.error_outline, color: Color(0xFFF87171), size: 22),
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFF1E1E24),
            margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
            borderRadius: 12,
            duration: const Duration(seconds: 3),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SingleChildScrollView(
        controller: _mainScrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTopAnnouncementBar(),
            _buildNavbar(screenWidth),
            _buildEditorialHeroBanner(screenWidth),
            KeyedSubtree(key: _categoryKey, child: _buildCategorySelector(screenWidth)),
            KeyedSubtree(key: _newArrivalsKey, child: _buildFeaturedProducts(screenWidth)),
            _buildTrustStrip(screenWidth),
            KeyedSubtree(key: _promoSaleKey, child: _buildPromoSplitBanner(screenWidth)),
            KeyedSubtree(key: _contactKey, child: _buildContactSection(screenWidth)),
            _buildLuxuryFooter(screenWidth),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 1. TOP ANNOUNCEMENT BAR
  // ==========================================
  Widget _buildTopAnnouncementBar() {
    return Container(
      color: const Color(0xFF1E1E24),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_fire_department, size: 15, color: Color(0xFFFFA987)),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'SPECIAL OFFER: Flat 40% OFF on all new collections | Express 1-Hour Delivery',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: () => AppLauncher.launchEmail(
                  email: 'support@stylito.com',
                  subject: 'Inquiry from Stylish Website',
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.email_outlined, size: 14, color: Color(0xFFFFA987)),
                    const SizedBox(width: 4),
                    Text(
                      'support@stylito.com',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: const Color(0xFFFFA987),
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 2. MINIMAL LUXURY NAVBAR (MATCHING REFERENCE IMAGE 2)
  // ==========================================
  Widget _buildNavbar(double screenWidth) {
    final cartCtrl = Get.find<CartController>();
    final wishCtrl = Get.find<WishlistController>();
    final authCtrl = Get.find<AuthController>();

    final isCompact = screenWidth < 768;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1.2)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 900 ? 36 : 16,
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Stylish Logo
          const StylishLogo(height: 36),

          // Right: Clean Navigation Links + User Profile Pill (Exact to Reference Image 2)
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _CleanNavLink(
                    title: 'NEW IN',
                    isActive: _activeNavTab == 'NEW IN',
                    onTap: () {
                      _scrollToKey(_newArrivalsKey, navTab: 'NEW IN');
                    },
                  ),
                  _CleanNavLink(
                    title: 'CLOTHING',
                    isActive: _activeNavTab == 'CLOTHING',
                    onTap: () {
                      _scrollToKey(_categoryKey, navTab: 'CLOTHING');
                      _scrollToCategory('womens');
                    },
                  ),
                  _CleanNavLink(
                    title: 'SALE',
                    isActive: _activeNavTab == 'SALE',
                    onTap: () {
                      _scrollToKey(_promoSaleKey, navTab: 'SALE');
                      _scrollToCategory('ALL');
                    },
                  ),
                  _CleanNavLink(
                    title: 'CONTACT',
                    isActive: _activeNavTab == 'CONTACT',
                    onTap: () {
                      _scrollToKey(_contactKey, navTab: 'CONTACT');
                    },
                  ),

                  SizedBox(width: isCompact ? 8 : 16),

                  // Wishlist Icon
                  Obx(() => Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.favorite_border, size: 21, color: AppColors.textDark),
                        tooltip: 'Wishlist',
                        onPressed: _openWishlist,
                      ),
                      if (wishCtrl.items.isNotEmpty)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
                            child: Text(
                              '${wishCtrl.items.length}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  )),

                  SizedBox(width: isCompact ? 6 : 10),

                  // Cart Icon
                  Obx(() => Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.shopping_bag_outlined, size: 21, color: AppColors.textDark),
                        tooltip: 'Cart',
                        onPressed: _openCart,
                      ),
                      if (cartCtrl.items.isNotEmpty)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
                            child: Text(
                              '${cartCtrl.itemCount}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  )),

                  SizedBox(width: isCompact ? 10 : 16),

                  // User Profile Pill / Login (Exact to Reference Image 2)
                  Obx(() {
                    if (authCtrl.isLoggedIn) {
                      final name = authCtrl.userProfile.name.isNotEmpty
                          ? authCtrl.userProfile.name
                          : 'Drashtihingol';
                      final initial = name.isNotEmpty ? name[0].toUpperCase() : 'D';

                      return InkWell(
                        onTap: _showUserMenu,
                        borderRadius: BorderRadius.circular(22),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: const Color(0xFFF87189),
                                child: Text(
                                  initial,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                name,
                                style: GoogleFonts.montserrat(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textDark),
                            ],
                          ),
                        ),
                      );
                    }

                    return InkWell(
                      onTap: _openAuthDialog,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFA987), Color(0xFFF87189)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.person_outline, size: 15, color: Colors.white),
                            const SizedBox(width: 6),
                            Text(
                              'LOGIN',
                              style: GoogleFonts.montserrat(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToCategory(String slug) {
    setState(() {
      _selectedCategory = slug;
      _activeNavTab = 'NEW IN';
    });
    _scrollToKey(_newArrivalsKey, navTab: 'NEW IN');
  }

  // ==========================================
  // 3. EDITORIAL HERO BANNER (FULL-WIDTH EDGE-TO-EDGE)
  // ==========================================
  Widget _buildEditorialHeroBanner(double screenWidth) {
    final heroHeight = screenWidth > 900 ? 520.0 : (screenWidth > 600 ? 440.0 : 360.0);

    return SizedBox(
      width: double.infinity,
      height: heroHeight,
      child: Stack(
        children: [
          // Banner Slider (Full-width edge-to-edge, no side gaps)
          PageView.builder(
            controller: _heroPageController,
            itemCount: _heroBanners.length,
            onPageChanged: (idx) {
              setState(() => _currentHeroBannerIndex = idx);
            },
            itemBuilder: (context, index) {
              final banner = _heroBanners[index];
              return _buildHeroSlide(banner, screenWidth, heroHeight);
            },
          ),

          // Bottom Indicator Dots
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_heroBanners.length, (idx) {
                final isSelected = _currentHeroBannerIndex == idx;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isSelected ? 24 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSlide(Map<String, dynamic> banner, double screenWidth, double heroHeight) {
    final imagePath = banner['image'] as String;
    final fallbackGradient = banner['fallbackGradient'] as List<Color>;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Bright Flatlay Background (Soft Pink Luxury Lifestyle)
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: fallbackGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
          ),
        ),

        // Gentle light-vignette overlay so typography is crystal clear without darkening the background
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.9,
              colors: [
                Colors.black.withValues(alpha: 0.22),
                Colors.black.withValues(alpha: 0.08),
              ],
            ),
          ),
        ),

        // Center Editorial Content (Matching Reference Image 2)
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Glassmorphic Capsule Eyebrow
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFB42D4B).withValues(alpha: 0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      banner['eyebrow'],
                      style: GoogleFonts.montserrat(
                        fontSize: screenWidth > 600 ? 11 : 9.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Hero Title (Crisp Luxury Playfair Serif)
                  Text(
                    banner['title'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: screenWidth > 900 ? 44 : (screenWidth > 600 ? 34 : 26),
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.15,
                      letterSpacing: -0.5,
                      shadows: [
                        Shadow(
                          color: const Color(0xFFB4284B).withValues(alpha: 0.45),
                          blurRadius: 20,
                          offset: const Offset(0, 3),
                        ),
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Hero Subtitle
                  Text(
                    banner['subtitle'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: screenWidth > 600 ? 14 : 11.5,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.95),
                      height: 1.45,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Action Buttons Row (White Pill + Google Play Button)
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 14,
                    runSpacing: 10,
                    children: [
                      // White Pill Button
                      ElevatedButton(
                        onPressed: () {
                          _scrollToCategory(banner['category']);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          minimumSize: const Size(0, 44),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          elevation: 6,
                          shadowColor: Colors.black.withValues(alpha: 0.2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              banner['buttonText'],
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward, size: 15, color: AppColors.primary),
                          ],
                        ),
                      ),

                      // Google Play Button
                      InkWell(
                        onTap: () => PlayStoreDownloadDialog.show(context),
                        borderRadius: BorderRadius.circular(28),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFA987), Color(0xFFF87189)],
                            ),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF87189).withValues(alpha: 0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22),
                              const SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'GET IT ON',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text(
                                    'Google Play',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
    );
  }

  // ==========================================
  // 4. SHOP BY CATEGORY (MATCHING REFERENCE IMAGE 1)
  // ==========================================
  Widget _buildCategorySelector(double screenWidth) {
    final circleSize = screenWidth > 600 ? 104.0 : 86.0;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1380),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Clean Category Heading
              Text(
                'SHOP BY CATEGORY',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3.5,
                  color: const Color(0xFF8C6D58),
                ),
              ),
              const SizedBox(height: 28),

              // 6 Category Circular Avatars
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory.toLowerCase() == cat['slug']!.toLowerCase();

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? 22 : 12),
                      child: _CategoryCircleItem(
                        cat: cat,
                        isSelected: isSelected,
                        circleSize: circleSize,
                        onTap: () => _onCategorySelected(cat['name']!, cat['slug']!),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCategorySelected(String name, String slug) {
    setState(() {
      if (_selectedCategory.toLowerCase() == slug.toLowerCase()) {
        _selectedCategory = 'ALL';
      } else {
        _selectedCategory = slug;
      }
      _activeNavTab = 'NEW IN';
    });
    _scrollToKey(_newArrivalsKey, navTab: 'NEW IN');
  }

  // ==========================================
  // 5. NEW ARRIVALS (HORIZONTAL SLIDING CAROUSEL WITH CONTROLS)
  // ==========================================
  Widget _buildFeaturedProducts(double screenWidth) {
    final products = _currentProducts;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1380),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header: Title on Left + Navigation Buttons on Right (Matching Image 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'NEW ARRIVALS',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: AppColors.textDark,
                    ),
                  ),
                  Row(
                    children: [
                      _buildCarouselNavButton(
                        icon: Icons.chevron_left,
                        isActive: _activeCarouselButton == 'left',
                        onTap: () {
                          setState(() => _activeCarouselButton = 'left');
                          _scrollProducts(false);
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildCarouselNavButton(
                        icon: Icons.chevron_right,
                        isActive: _activeCarouselButton == 'right',
                        onTap: () {
                          setState(() => _activeCarouselButton = 'right');
                          _scrollProducts(true);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Horizontal Sliding Product Track
              SizedBox(
                height: 440,
                child: ListView.separated(
                  controller: _newArrivalsScrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  itemCount: products.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 20),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _ProductHoverCard(
                      key: ValueKey(product.id),
                      product: product,
                      onTap: () => _openProductQuickViewModal(product),
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),
              // View All Products Button
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = 'ALL';
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.textDark, width: 1.5),
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    'VIEW ALL PRODUCTS',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openProductQuickViewModal(ProductModel product) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (ctx) => _ProductQuickViewDialog(product: product),
    );
  }

  void _scrollProducts(bool forward) {
    if (!_newArrivalsScrollController.hasClients) return;
    final currentOffset = _newArrivalsScrollController.offset;
    final maxOffset = _newArrivalsScrollController.position.maxScrollExtent;
    final targetOffset = forward
        ? (currentOffset + 320.0).clamp(0.0, maxOffset)
        : (currentOffset - 320.0).clamp(0.0, maxOffset);

    _newArrivalsScrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  Widget _buildCarouselNavButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return _CarouselNavIconButton(
      icon: icon,
      isActive: isActive,
      onTap: onTap,
    );
  }

  // ==========================================
  // 6. VALUE PROPOSITIONS & TRUST STRIP
  // ==========================================
  Widget _buildTrustStrip(double screenWidth) {
    final List<Map<String, dynamic>> items = [
      {
        'icon': Icons.local_shipping_outlined,
        'title': 'Free Shipping',
        'subtitle': 'On all orders over ₹999',
      },
      {
        'icon': Icons.cached_outlined,
        'title': 'Easy Returns',
        'subtitle': '30 days return policy',
      },
      {
        'icon': Icons.verified_user_outlined,
        'title': 'Secure Payment',
        'subtitle': '100% verified checkout',
      },
      {
        'icon': Icons.workspace_premium_outlined,
        'title': 'Quality Guarantee',
        'subtitle': 'Premium certified fabrics',
      },
    ];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1380),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = screenWidth > 900;
              final isMedium = screenWidth > 600;

              if (isWide) {
                return Row(
                  children: items.map((item) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF7D8DE)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.pink.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(item['icon'] as IconData, color: AppColors.primary, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item['title'] as String,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item['subtitle'] as String,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 11.5,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else if (isMedium) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.8,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF7D8DE)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(item['icon'] as IconData, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item['title'] as String,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['subtitle'] as String,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Column(
                  children: items.map((item) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF7D8DE)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(item['icon'] as IconData, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item['title'] as String,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['subtitle'] as String,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 7. PROMOTIONAL SPLIT BANNER (SUMMER REFRESH)
  // ==========================================
  Widget _buildPromoSplitBanner(double screenWidth) {
    final isWide = screenWidth > 768;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1380),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: const Color(0xFFFFF0F2),
            border: Border.all(color: const Color(0xFFF7D8DE)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: isWide
                ? Row(
                    children: [
                      // Left Visual Image
                      Expanded(
                        flex: 5,
                        child: SizedBox(
                          height: 380,
                          child: Image.asset(
                            'assets/images/hot_summer_sale.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: const Color(0xFFFDE8EC),
                              child: const Center(
                                child: Icon(Icons.shopping_bag, size: 64, color: AppColors.primary),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Right Content Card
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFFF7D8DE)),
                                ),
                                child: Text(
                                  'LIMITED TIME ONLY',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.5,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                'Summer Refresh',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Enjoy up to 30% off selected styles across dresses, lightweight tops, and summer accessories.',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: AppColors.textMuted,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 26),
                              ElevatedButton(
                                onPressed: () {
                                  _scrollToCategory('womens');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(0, 46),
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                                  elevation: 2,
                                ),
                                child: Text(
                                  'SHOP THE SALE',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 240,
                        width: double.infinity,
                        child: Image.asset(
                          'assets/images/hot_summer_sale.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: const Color(0xFFFDE8EC),
                            child: const Center(
                              child: Icon(Icons.shopping_bag, size: 48, color: AppColors.primary),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFF7D8DE)),
                              ),
                              child: Text(
                                'LIMITED TIME ONLY',
                                style: GoogleFonts.montserrat(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Summer Refresh',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Enjoy up to 30% off selected styles.',
                              style: GoogleFonts.montserrat(
                                fontSize: 13,
                                color: AppColors.textMuted,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                _scrollToCategory('womens');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(0, 44),
                                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                              ),
                              child: Text(
                                'SHOP THE SALE',
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 10. GET IN TOUCH / CONTACT FORM SECTION
  // ==========================================
  Widget _buildContactSection(double screenWidth) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'HAVE QUESTIONS?',
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.0,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Get in Touch with Stylish Support',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 24),
              screenWidth > 850
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 4, child: _buildContactCards()),
                        const SizedBox(width: 32),
                        Expanded(flex: 6, child: _buildInquiryForm()),
                      ],
                    )
                  : Column(
                      children: [
                        _buildContactCards(),
                        const SizedBox(height: 24),
                        _buildInquiryForm(),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCards() {
    return Column(
      children: [
        _buildInfoTile(
          Icons.email_outlined,
          'Email Us',
          'support@stylito.com',
          'Direct mail support 24/7',
          () => AppLauncher.launchEmail(
            email: 'support@stylito.com',
            subject: 'Customer Inquiry',
          ),
        ),
        const SizedBox(height: 14),
        _buildInfoTile(
          Icons.phone_outlined,
          'Call Support',
          '+91 98765 43210',
          'Mon - Sat: 9:00 AM - 8:00 PM IST',
          () => AppLauncher.launchPhone('+919876543210'),
        ),
        const SizedBox(height: 14),
        _buildInfoTile(
          Icons.location_on_outlined,
          'Headquarters',
          'Surat, Gujarat, India',
          'Fashion Hub, Stylito Towers, 395007',
          null,
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String val, String subtitle, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF7D8DE)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
                    ),
                  ),
                  Text(
                    val,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildInquiryForm() {
    final inquiryCtrl = Get.find<InquiryController>();

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF7D8DE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _inquiryFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Send us a Direct Message',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _inquiryNameController,
                    decoration: InputDecoration(
                      labelText: 'Your Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Please enter name' : null,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: TextFormField(
                    controller: _inquiryEmailController,
                    decoration: InputDecoration(
                      labelText: 'Your Email',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _inquirySubjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Please enter subject' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _inquiryMessageController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'How can we help you?',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (v) => v == null || v.length < 5 ? 'Message is too short' : null,
            ),
            const SizedBox(height: 20),
            Obx(() => ElevatedButton.icon(
              onPressed: inquiryCtrl.isSubmitting.value ? null : _submitInquiry,
              icon: inquiryCtrl.isSubmitting.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.send, size: 18),
              label: Text(
                inquiryCtrl.isSubmitting.value ? 'Sending...' : 'Send Message',
                style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 48),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            )),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 11. LUXURY FOOTER
  // ==========================================
  Widget _buildLuxuryFooter(double screenWidth) {
    return Container(
      color: const Color(0xFF16161A),
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              screenWidth > 768
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(flex: 4, child: _buildFooterBrandCol()),
                        Expanded(flex: 2, child: _buildFooterCol('SHOP', ['New In', 'Clothing', 'Dresses', 'Menswear', 'Beauty', 'Sale'])),
                        Expanded(flex: 2, child: _buildFooterCol('CUSTOMER CARE', ['Shipping & Delivery', 'Returns Policy', 'Size Guide', 'FAQ', 'Contact Us'])),
                        Expanded(flex: 2, child: _buildFooterCol('ABOUT', ['Our Story', 'Sustainability', 'Careers', 'Lookbook', 'Press'])),
                        Expanded(flex: 2, child: _buildFooterCol('LEGAL', ['Terms & Conditions', 'Privacy Policy', 'Refund Policy'])),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFooterBrandCol(),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 32,
                          runSpacing: 24,
                          children: [
                            _buildFooterCol('SHOP', ['New In', 'Clothing', 'Dresses', 'Menswear', 'Beauty', 'Sale']),
                            _buildFooterCol('CUSTOMER CARE', ['Shipping & Delivery', 'Returns Policy', 'Size Guide', 'FAQ']),
                            _buildFooterCol('LEGAL', ['Terms & Conditions', 'Privacy Policy']),
                          ],
                        ),
                      ],
                    ),

              const SizedBox(height: 40),
              const Divider(color: Color(0xFF2A2A32)),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '© 2026 Stylish. All Rights Reserved.',
                    style: GoogleFonts.montserrat(fontSize: 12, color: Colors.white54),
                  ),
                  Row(
                    children: ['VISA', 'MC', 'AMEX', 'PAYPAL', 'APPLE PAY'].map((badge) {
                      return Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF24242C),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          badge,
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterBrandCol() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StylishLogo(height: 34),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Text(
            'Timeless style meets modern elegance. Designed to elevate your everyday presence with luxury fabrics.',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: Colors.white60,
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            _buildSocialIcon(Icons.camera_alt, 'Instagram'),
            _buildSocialIcon(Icons.facebook, 'Facebook'),
            _buildSocialIcon(Icons.share, 'Pinterest'),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String tip) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFF24242C),
        borderRadius: BorderRadius.circular(18),
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: Colors.white70),
        tooltip: tip,
        onPressed: () {},
      ),
    );
  }

  Widget _buildFooterCol(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ...links.map((link) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: InkWell(
            onTap: () {},
            child: Text(
              link,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.white60,
              ),
            ),
          ),
        )),
      ],
    );
  }
}

class _ProductHoverCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const _ProductHoverCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  State<_ProductHoverCard> createState() => _ProductHoverCardState();
}

class _ProductHoverCardState extends State<_ProductHoverCard> {
  bool _isHovered = false;
  bool _isBtnHovered = false;

  @override
  Widget build(BuildContext context) {
    final wishCtrl = Get.find<WishlistController>();
    final cartCtrl = Get.find<CartController>();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isBtnHovered = false;
      }),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: 270,
        transform: _isHovered ? Matrix4.translationValues(0, -8, 0) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? AppColors.primary : const Color(0xFFF1F5F9),
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            if (_isHovered) ...[
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.22),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] else ...[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ],
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Image Container with Wishlist & Quick Add
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Container(
                      height: 255,
                      width: 270,
                      color: const Color(0xFFF8F9FA),
                      child: AnimatedScale(
                        scale: _isHovered ? 1.05 : 1.0,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                        child: AppImage(
                          path: widget.product.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // Wishlist Button (Top Right)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Obx(() {
                      final isFav = wishCtrl.isWishlisted(widget.product.id);
                      return InkWell(
                        onTap: () => wishCtrl.toggleWishlist(widget.product),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.92),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? AppColors.primary : AppColors.textDark,
                            size: 18,
                          ),
                        ),
                      );
                    }),
                  ),

                  // Quick Add Bar (Exact to Card 1 in Image 1: dark bar with white text)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedOpacity(
                      opacity: _isHovered ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 250),
                      child: _isHovered
                          ? MouseRegion(
                              onEnter: (_) => setState(() => _isBtnHovered = true),
                              onExit: (_) => setState(() => _isBtnHovered = false),
                              child: InkWell(
                                onTap: () {
                                  cartCtrl.addItem(widget.product);
                                  Get.rawSnackbar(
                                    titleText: Text(
                                      'Added to Bag',
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    messageText: Text(
                                      '${widget.product.title} added to your bag.',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white.withValues(alpha: 0.9),
                                        fontSize: 12.5,
                                      ),
                                    ),
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: const Color(0xFF1E1E24),
                                    margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                    borderRadius: 14,
                                    icon: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF22C55E).withValues(alpha: 0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.check_circle_outline, color: Color(0xFF22C55E), size: 22),
                                    ),
                                    duration: const Duration(seconds: 2),
                                    boxShadows: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.25),
                                        blurRadius: 18,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  );
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _isBtnHovered
                                        ? AppColors.primary
                                        : const Color(0xFF212121).withValues(alpha: 0.95),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.shopping_bag_outlined, size: 14, color: Colors.white),
                                        const SizedBox(width: 6),
                                        Text(
                                          'QUICK ADD TO BAG',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),

              // Product Info Area
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: GoogleFonts.montserrat(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: _isHovered ? AppColors.primary : AppColors.textDark,
                      ),
                      child: Text(
                        widget.product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.product.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        fontSize: 11.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Rating Row
                    Row(
                      children: [
                        const Text(
                          '★★★★★',
                          style: TextStyle(
                            color: Color(0xFFFFB800),
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.product.rating}',
                          style: GoogleFonts.montserrat(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${widget.product.reviewCount})',
                          style: GoogleFonts.montserrat(
                            fontSize: 10.5,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Price Row
                    Row(
                      children: [
                        Text(
                          '₹${widget.product.price.toInt()}',
                          style: GoogleFonts.montserrat(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (widget.product.originalPrice > widget.product.price) ...[
                          Text(
                            '₹${widget.product.originalPrice.toInt()}',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: AppColors.textLight,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.product.discountPercent}% OFF',
                            style: GoogleFonts.montserrat(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CleanNavLink extends StatefulWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _CleanNavLink({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_CleanNavLink> createState() => _CleanNavLinkState();
}

class _CleanNavLinkState extends State<_CleanNavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final showPink = widget.isActive || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: widget.isActive ? FontWeight.w700 : (_isHovered ? FontWeight.w600 : FontWeight.w500),
                  letterSpacing: 0.8,
                  color: showPink ? AppColors.primary : AppColors.textDark,
                ),
                child: Text(widget.title),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                height: 2.5,
                width: widget.isActive ? 22 : (_isHovered ? 14 : 0),
                decoration: BoxDecoration(
                  color: showPink ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarouselNavIconButton extends StatefulWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _CarouselNavIconButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_CarouselNavIconButton> createState() => _CarouselNavIconButtonState();
}

class _CarouselNavIconButtonState extends State<_CarouselNavIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isHighlighted = widget.isActive || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.08 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isHighlighted ? AppColors.primary : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isHighlighted ? AppColors.primary : const Color(0xFFE2E8F0),
                width: 1.2,
              ),
              boxShadow: [
                if (isHighlighted)
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  )
                else
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Icon(
              widget.icon,
              color: isHighlighted ? Colors.white : AppColors.textDark,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _StylishAuthModal extends StatefulWidget {
  const _StylishAuthModal();

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (ctx) => const Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: _StylishAuthModal(),
      ),
    );
  }

  @override
  State<_StylishAuthModal> createState() => _StylishAuthModalState();
}

class _StylishAuthModalState extends State<_StylishAuthModal> {
  int _tabIndex = 0; // 0 = Sign In, 1 = Sign Up
  bool _rememberMe = true;
  bool _obscureSignInPass = true;
  bool _obscureSignUpPass = true;

  final _signInEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();
  final _signUpNameController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _signUpPhoneController = TextEditingController();
  final _signUpPasswordController = TextEditingController();

  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    _signUpNameController.dispose();
    _signUpEmailController.dispose();
    _signUpPhoneController.dispose();
    _signUpPasswordController.dispose();
    super.dispose();
  }

  void _handleSignIn() async {
    if (_signInFormKey.currentState?.validate() ?? false) {
      final auth = Get.find<AuthController>();
      final email = _signInEmailController.text.trim();
      final pass = _signInPasswordController.text.trim();
      final success = await auth.login(email, pass);
      if (success) {
        if (mounted) Navigator.pop(context);
        Get.rawSnackbar(
          titleText: Text(
            'Welcome Back!',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13.5),
          ),
          messageText: Text(
            'Logged in as ${auth.userProfile.name.isNotEmpty ? auth.userProfile.name : email}',
            style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12),
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF1E1E24),
          margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.rawSnackbar(
          titleText: Text(
            'Login Failed',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 13.5),
          ),
          messageText: Text(
            auth.authMessage.value.isNotEmpty ? auth.authMessage.value : 'Invalid credentials. Please try again.',
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
  }

  void _handleSignUp() async {
    if (_signUpFormKey.currentState?.validate() ?? false) {
      final auth = Get.find<AuthController>();
      final name = _signUpNameController.text.trim();
      final email = _signUpEmailController.text.trim();
      final phone = _signUpPhoneController.text.trim();
      final pass = _signUpPasswordController.text.trim();
      final success = await auth.signup(email, pass, name: name, phone: phone);
      if (success) {
        if (mounted) Navigator.pop(context);
        Get.rawSnackbar(
          titleText: Text(
            'Account Created!',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 13.5),
          ),
          messageText: Text(
            'Welcome to Stylito, $name!',
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
            'Registration Failed',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 13.5),
          ),
          messageText: Text(
            auth.authMessage.value.isNotEmpty ? auth.authMessage.value : 'Please check your details and try again.',
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
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Center(
      child: Container(
        width: 440,
        constraints: const BoxConstraints(maxHeight: 740),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 4),

                  // 1. Top Avatar Icon (Matching Image 1 & 2)
                  Center(
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF0F3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _tabIndex == 0 ? Icons.person_outline_rounded : Icons.person_add_alt_1_outlined,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 2. Title Typography
                  Text(
                    _tabIndex == 0 ? 'Welcome to Stylito' : 'Create Account',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // 3. Subtitle
                  Text(
                    _tabIndex == 0
                        ? 'Sign in to sync your bag, wishlist & orders'
                        : 'Join Stylito for member perks & fast checkout',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 4. Segmented Tab Switcher (Sign In / Sign Up)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _tabIndex = 0),
                            borderRadius: BorderRadius.circular(9),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              decoration: BoxDecoration(
                                color: _tabIndex == 0 ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: _tabIndex == 0
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.06),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  'Sign In',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: _tabIndex == 0 ? AppColors.primary : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _tabIndex = 1),
                            borderRadius: BorderRadius.circular(9),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              decoration: BoxDecoration(
                                color: _tabIndex == 1 ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: _tabIndex == 1
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.06),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  'Sign Up',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: _tabIndex == 1 ? AppColors.primary : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 5. Dual-Side Animated Sliding Form
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      final isSignIn = child.key == const ValueKey('signin_form');
                      final offsetTween = Tween<Offset>(
                        begin: isSignIn ? const Offset(-0.15, 0) : const Offset(0.15, 0),
                        end: Offset.zero,
                      );
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: offsetTween.animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _tabIndex == 0 ? _buildSignInForm(auth) : _buildSignUpForm(auth),
                  ),

                  const SizedBox(height: 16),

                  // 6. OR CONTINUE WITH Divider
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'OR CONTINUE WITH',
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 7. Social Buttons Row (Google & Phone OTP)
                  Row(
                    children: [
                      // Google Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            GoogleAccountPickerSheet.show(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/google_logo.png',
                                height: 18,
                                errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.g_mobiledata,
                                  color: Color(0xFFEA4335),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Google',
                                style: GoogleFonts.montserrat(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Phone OTP Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            PhoneOtpDialog.show(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.phone_android, size: 16, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Phone OTP',
                                style: GoogleFonts.montserrat(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Top-Right Close Button
            Positioned(
              top: 14,
              right: 14,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 16, color: Color(0xFF64748B)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // SIGN IN FORM (MATCHING IMAGE 1)
  // ==========================================
  Widget _buildSignInForm(AuthController auth) {
    return Form(
      key: const ValueKey('signin_form'),
      child: Form(
        key: _signInFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email Address
            Text(
              'Email Address',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _signInEmailController,
              decoration: InputDecoration(
                hintText: 'you@example.com',
                hintStyle: GoogleFonts.montserrat(fontSize: 12.5, color: const Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.mail_outline, size: 18, color: Color(0xFF94A3B8)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Enter your email' : null,
            ),
            const SizedBox(height: 14),

            // Password & Forgot? Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Password',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.rawSnackbar(
                      titleText: Text(
                        'Password Reset',
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
                      ),
                      messageText: Text(
                        'Password reset link sent if account exists.',
                        style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12),
                      ),
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: const Color(0xFF1E1E24),
                      margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
                      borderRadius: 12,
                    );
                  },
                  child: Text(
                    'Forgot?',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _signInPasswordController,
              obscureText: _obscureSignInPass,
              decoration: InputDecoration(
                hintText: 'Enter password',
                hintStyle: GoogleFonts.montserrat(fontSize: 12.5, color: const Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.lock_outline, size: 18, color: Color(0xFF94A3B8)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureSignInPass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 18,
                    color: const Color(0xFF94A3B8),
                  ),
                  onPressed: () => setState(() => _obscureSignInPass = !_obscureSignInPass),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Enter your password' : null,
            ),
            const SizedBox(height: 12),

            // Remember Me Row
            Row(
              children: [
                InkWell(
                  onTap: () => setState(() => _rememberMe = !_rememberMe),
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: _rememberMe ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _rememberMe ? AppColors.primary : const Color(0xFFCBD5E1),
                      ),
                    ),
                    child: _rememberMe
                        ? const Icon(Icons.check, size: 13, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Remember me',
                  style: GoogleFonts.montserrat(
                    fontSize: 12.5,
                    color: const Color(0xFF475569),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Gradient Sign In Button (Matching Image 1)
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFA08C), Color(0xFFF85D83)],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF85D83).withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: auth.isLoading.value ? null : _handleSignIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: auth.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        'Sign In',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 14),

            // Switch to Sign Up Prompt
            Center(
              child: InkWell(
                onTap: () => setState(() => _tabIndex = 1),
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: GoogleFonts.montserrat(fontSize: 12, color: const Color(0xFF64748B)),
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // SIGN UP FORM (MATCHING IMAGE 2)
  // ==========================================
  Widget _buildSignUpForm(AuthController auth) {
    return Form(
      key: const ValueKey('signup_form'),
      child: Form(
        key: _signUpFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Name
            Text(
              'Full Name',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _signUpNameController,
              decoration: InputDecoration(
                hintText: 'e.g. Priya Sharma',
                hintStyle: GoogleFonts.montserrat(fontSize: 12.5, color: const Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.person_outline, size: 18, color: Color(0xFF94A3B8)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Enter your full name' : null,
            ),
            const SizedBox(height: 12),

            // Email Address
            Text(
              'Email Address',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _signUpEmailController,
              decoration: InputDecoration(
                hintText: 'you@example.com',
                hintStyle: GoogleFonts.montserrat(fontSize: 12.5, color: const Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.mail_outline, size: 18, color: Color(0xFF94A3B8)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              validator: (v) => v == null || !v.contains('@') ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: 12),

            // Phone Number (optional)
            Text(
              'Phone Number (optional)',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _signUpPhoneController,
              decoration: InputDecoration(
                hintText: '+91 98765 43210',
                hintStyle: GoogleFonts.montserrat(fontSize: 12.5, color: const Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.phone_outlined, size: 18, color: Color(0xFF94A3B8)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),

            // Create Password
            Text(
              'Create Password',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _signUpPasswordController,
              obscureText: _obscureSignUpPass,
              decoration: InputDecoration(
                hintText: 'At least 6 characters',
                hintStyle: GoogleFonts.montserrat(fontSize: 12.5, color: const Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.lock_outline, size: 18, color: Color(0xFF94A3B8)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureSignUpPass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 18,
                    color: const Color(0xFF94A3B8),
                  ),
                  onPressed: () => setState(() => _obscureSignUpPass = !_obscureSignUpPass),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              validator: (v) => v == null || v.length < 6 ? 'Password must be at least 6 characters' : null,
            ),
            const SizedBox(height: 16),

            // Gradient Create Account Button (Matching Image 2)
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFA08C), Color(0xFFF85D83)],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF85D83).withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: auth.isLoading.value ? null : _handleSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: auth.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        'Create Account',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 14),

            // Switch to Sign In Prompt
            Center(
              child: InkWell(
                onTap: () => setState(() => _tabIndex = 0),
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: GoogleFonts.montserrat(fontSize: 12, color: const Color(0xFF64748B)),
                    children: [
                      TextSpan(
                        text: 'Sign In',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// PRODUCT QUICK VIEW MODAL DIALOG (MATCHING IMAGE 2)
// ==========================================
class _ProductQuickViewDialog extends StatefulWidget {
  final ProductModel product;

  const _ProductQuickViewDialog({required this.product});

  @override
  State<_ProductQuickViewDialog> createState() => _ProductQuickViewDialogState();
}

class _ProductQuickViewDialogState extends State<_ProductQuickViewDialog> {
  String _selectedSize = 'XS';
  final List<String> _sizes = ['XS', 'S', 'M', 'L'];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 768;
    final cartCtrl = Get.find<CartController>();
    final wishCtrl = Get.find<WishlistController>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: isMobile ? 24 : 32,
      ),
      elevation: 0,
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 820,
            maxHeight: isMobile ? screenHeight * 0.85 : 530,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: isMobile
                    ? SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                height: 260,
                                width: double.infinity,
                                color: const Color(0xFFF8F9FA),
                                child: AppImage(
                                  path: widget.product.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildDetailsContent(cartCtrl, wishCtrl),
                          ],
                        ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Left Product Image
                          Expanded(
                            flex: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                color: const Color(0xFFF8F9FA),
                                child: AppImage(
                                  path: widget.product.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Right Details Column
                          Expanded(
                            flex: 6,
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: _buildDetailsContent(cartCtrl, wishCtrl),
                            ),
                          ),
                        ],
                      ),
              ),

              // Close Button (Top Right)
              Positioned(
                top: 14,
                right: 14,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.close, size: 16, color: Color(0xFF64748B)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsContent(CartController cartCtrl, WishlistController wishCtrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Category
        Text(
          widget.product.category.toUpperCase(),
          style: GoogleFonts.montserrat(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),

        // Title
        Text(
          widget.product.title,
          style: GoogleFonts.montserrat(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 3),

        // Subtitle
        Text(
          widget.product.subtitle,
          style: GoogleFonts.montserrat(
            fontSize: 12.5,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 10),

        // Rating Row
        Row(
          children: [
            const Text(
              '★★★★★',
              style: TextStyle(
                color: Color(0xFFFFB800),
                fontSize: 13,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${widget.product.rating}',
              style: GoogleFonts.montserrat(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${widget.product.reviewCount} ratings)',
              style: GoogleFonts.montserrat(
                fontSize: 11.5,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Thin Soft Divider
        Container(height: 1, color: const Color(0xFFF1F5F9)),
        const SizedBox(height: 12),

        // Price Row
        Row(
          children: [
            Text(
              '₹${widget.product.price.toInt()}',
              style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(width: 10),
            if (widget.product.originalPrice > widget.product.price) ...[
              Text(
                '₹${widget.product.originalPrice.toInt()}',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: const Color(0xFF94A3B8),
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${widget.product.discountPercent}% OFF',
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),

        // Size Selector
        Text(
          'SELECT SIZE',
          style: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),

        Row(
          children: _sizes.map((size) {
            final isSelected = _selectedSize == size;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => setState(() => _selectedSize = size),
                borderRadius: BorderRadius.circular(6),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 38,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : const Color(0xFFCBD5E1),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      size,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : AppColors.textDark,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),

        // Description Box with Pink Left Stripe (Matching Image 2)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFDF8F9),
            borderRadius: BorderRadius.circular(8),
            border: const Border(
              left: BorderSide(color: AppColors.primary, width: 3.5),
            ),
          ),
          child: Text(
            widget.product.description.isNotEmpty
                ? widget.product.description
                : widget.product.subtitle,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: const Color(0xFF475569),
              height: 1.45,
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Action Buttons Row (ADD TO BAG + BUY NOW + WISHLIST)
        Row(
          children: [
            // ADD TO BAG
            Expanded(
              flex: 5,
              child: ElevatedButton(
                onPressed: () {
                  cartCtrl.addItem(widget.product, size: _selectedSize);
                  Get.rawSnackbar(
                    titleText: Text(
                      'Added to Bag',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    messageText: Text(
                      '${widget.product.title} (Size: $_selectedSize) added to your bag.',
                      style: GoogleFonts.montserrat(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12.5,
                      ),
                    ),
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: const Color(0xFF1E1E24),
                    margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    borderRadius: 14,
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle_outline, color: Color(0xFF22C55E), size: 22),
                    ),
                    duration: const Duration(seconds: 2),
                    boxShadows: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF212121),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Text(
                  'ADD TO BAG',
                  style: GoogleFonts.montserrat(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // BUY NOW
            Expanded(
              flex: 5,
              child: ElevatedButton(
                onPressed: () {
                  cartCtrl.addItem(widget.product, size: _selectedSize);
                  Navigator.of(context).pop();
                  _SideCartDrawer.show(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 4,
                  shadowColor: AppColors.primary.withValues(alpha: 0.4),
                ),
                child: Text(
                  'BUY NOW',
                  style: GoogleFonts.montserrat(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Wishlist Heart Icon
            Obx(() {
              final isFav = wishCtrl.isWishlisted(widget.product.id);
              return InkWell(
                onTap: () => wishCtrl.toggleWishlist(widget.product),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? AppColors.primary : const Color(0xFF64748B),
                    size: 20,
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}

// ==========================================
// CATEGORY CIRCULAR ITEM WITH HOVER LIFT & ZOOM (MATCHING IMAGE 1)
// ==========================================
class _CategoryCircleItem extends StatefulWidget {
  final Map<String, String> cat;
  final bool isSelected;
  final double circleSize;
  final VoidCallback onTap;

  const _CategoryCircleItem({
    required this.cat,
    required this.isSelected,
    required this.circleSize,
    required this.onTap,
  });

  @override
  State<_CategoryCircleItem> createState() => _CategoryCircleItemState();
}

class _CategoryCircleItemState extends State<_CategoryCircleItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final showPink = widget.isSelected || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circular Image Container with active pink border & glow animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                width: widget.circleSize,
                height: widget.circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFF0F2),
                  border: Border.all(
                    color: showPink ? AppColors.primary : const Color(0xFFF7D8DE),
                    width: showPink ? 3.0 : 1.5,
                  ),
                  boxShadow: [
                    if (showPink)
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        blurRadius: 22,
                        spreadRadius: 3,
                        offset: const Offset(0, 6),
                      )
                    else
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                  ],
                ),
                child: ClipOval(
                  child: AnimatedScale(
                    scale: _isHovered ? 1.15 : (widget.isSelected ? 1.05 : 1.0),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    child: Image.asset(
                      widget.cat['image']!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.checkroom, color: AppColors.primary, size: 32),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Category Name
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: showPink ? FontWeight.w800 : FontWeight.w700,
                  letterSpacing: 1.5,
                  color: showPink ? AppColors.primary : AppColors.textDark,
                ),
                child: Text(widget.cat['name']!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// RIGHT-SIDE SLIDE-OVER SHOPPING BAG DRAWER (MATCHING IMAGE 3)
// ==========================================
class _SideCartDrawer extends StatelessWidget {
  const _SideCartDrawer();

  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Shopping Bag',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, anim1, anim2) {
        return const _SideCartDrawer();
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        final curved = CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final cartCtrl = Get.find<CartController>();

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: isMobile ? screenWidth * 0.94 : 390,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 30,
                offset: const Offset(-6, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Top Header (SHOPPING BAG (X) + Close Button)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFFDE8EC), width: 1.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Text(
                      'SHOPPING BAG (${cartCtrl.itemCount})',
                      style: GoogleFonts.montserrat(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        color: AppColors.textDark,
                      ),
                    )),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.close, size: 20, color: Color(0xFF64748B)),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Scrollable Cart Items List
              Expanded(
                child: Obx(() {
                  if (cartCtrl.items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_bag_outlined, size: 54, color: Colors.grey[300]),
                          const SizedBox(height: 14),
                          Text(
                            'Your shopping bag is empty',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Explore our collections to add items.',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                    itemCount: cartCtrl.items.length,
                    separatorBuilder: (context, index) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 14),
                      height: 1,
                      color: const Color(0xFFFDE8EC),
                    ),
                    itemBuilder: (context, index) {
                      final item = cartCtrl.items[index];

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              width: 76,
                              height: 76,
                              color: const Color(0xFFF8F9FA),
                              child: AppImage(
                                path: item.product.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Product Info & Quantity Stepper
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.title,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '₹${item.product.price.toStringAsFixed(2)}',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Quantity Stepper Box (Exact to Image 3)
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: const Color(0xFFF7D8DE),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Minus Button
                                      InkWell(
                                        onTap: () => cartCtrl.updateQuantity(index, item.quantity - 1),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          child: Text(
                                            '-',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Quantity Text
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        child: Text(
                                          '${item.quantity}',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.textDark,
                                          ),
                                        ),
                                      ),
                                      // Plus Button
                                      InkWell(
                                        onTap: () => cartCtrl.updateQuantity(index, item.quantity + 1),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          child: Text(
                                            '+',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Remove Item (x) Button
                          InkWell(
                            onTap: () => cartCtrl.items.removeAt(index),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.close, size: 16, color: Color(0xFF94A3B8)),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
              ),

              // 3. Bottom Footer (SUBTOTAL + CHECKOUT Button)
              Container(
                padding: const EdgeInsets.all(22),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFFDE8EC), width: 1.2),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SUBTOTAL',
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: AppColors.textDark,
                          ),
                        ),
                        Obx(() => Text(
                          '₹${cartCtrl.subtotal.toStringAsFixed(2)}',
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          PlayStoreDownloadDialog.show(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'CHECKOUT',
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// RIGHT-SIDE SLIDE-OVER WISHLIST DRAWER
// ==========================================
class _SideWishlistDrawer extends StatelessWidget {
  const _SideWishlistDrawer();

  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Wishlist',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, anim1, anim2) {
        return const _SideWishlistDrawer();
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        final curved = CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final wishCtrl = Get.find<WishlistController>();
    final cartCtrl = Get.find<CartController>();

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: isMobile ? screenWidth * 0.94 : 390,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 30,
                offset: const Offset(-6, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Top Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFFDE8EC), width: 1.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Text(
                      'WISHLIST (${wishCtrl.items.length})',
                      style: GoogleFonts.montserrat(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        color: AppColors.textDark,
                      ),
                    )),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.close, size: 20, color: Color(0xFF64748B)),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Scrollable Wishlist Items List
              Expanded(
                child: Obx(() {
                  if (wishCtrl.items.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF0F3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.favorite_border, size: 32, color: AppColors.primary),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Your wishlist is empty',
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Tap the heart icon on any product to save your favorite styles.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: const Color(0xFF64748B),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                    itemCount: wishCtrl.items.length,
                    separatorBuilder: (context, index) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 14),
                      height: 1,
                      color: const Color(0xFFFDE8EC),
                    ),
                    itemBuilder: (context, index) {
                      final product = wishCtrl.items[index];

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              width: 76,
                              height: 76,
                              color: const Color(0xFFF8F9FA),
                              child: AppImage(
                                path: product.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Product Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '₹${product.price.toStringAsFixed(2)}',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // MOVE TO BAG Button
                                InkWell(
                                  onTap: () {
                                    cartCtrl.addItem(product);
                                    wishCtrl.toggleWishlist(product);
                                    Get.rawSnackbar(
                                      titleText: Text(
                                        'Moved to Bag',
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          fontSize: 13.5,
                                        ),
                                      ),
                                      messageText: Text(
                                        '${product.title} moved to your shopping bag.',
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                      snackPosition: SnackPosition.TOP,
                                      backgroundColor: const Color(0xFF1E1E24),
                                      margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
                                      borderRadius: 12,
                                      duration: const Duration(seconds: 2),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(4),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.shopping_bag_outlined, size: 13, color: Colors.white),
                                        const SizedBox(width: 6),
                                        Text(
                                          'MOVE TO BAG',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Remove Button
                          InkWell(
                            onTap: () => wishCtrl.toggleWishlist(product),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.close, size: 16, color: Color(0xFF94A3B8)),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
              ),

              // 3. Bottom Footer
              Container(
                padding: const EdgeInsets.all(22),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFFDE8EC), width: 1.2),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.textDark, width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    child: Text(
                      'CONTINUE SHOPPING',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
