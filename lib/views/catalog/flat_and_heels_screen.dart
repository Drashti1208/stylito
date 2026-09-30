import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../models/product_model.dart';
import '../product_details/product_details_screen.dart';

class FlatAndHeelsScreen extends StatefulWidget {
  const FlatAndHeelsScreen({super.key});

  @override
  State<FlatAndHeelsScreen> createState() => _FlatAndHeelsScreenState();
}

class _FlatAndHeelsScreenState extends State<FlatAndHeelsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategoryFilter = 'All';
  final Set<String> _userAddedIds = {};

  // Initial curated Flat and Heels catalog
  late List<ProductModel> _products;

  @override
  void initState() {
    super.initState();
    _products = [
      const ProductModel(
        id: 'heels_luxury_stiletto',
        title: 'Luxury Stiletto Heels',
        subtitle: 'Pointed toe high heels in rose champagne finish',
        description:
            'Turn heads with these handcrafted stiletto heels. Featuring comfortable memory foam cushioning, a sleek 4-inch heel, and non-slip sole designed for evening galas and formal events.',
        price: 2499.00,
        originalPrice: 4999.00,
        discountPercent: 50,
        rating: 4.9,
        reviewCount: 4210,
        imageUrl: AppAssets.heelsBanner,
        galleryImages: [AppAssets.heelsBanner],
        sizes: ['36 EU', '37 EU', '38 EU', '39 EU', '40 EU'],
        category: 'Heels',
        deliveryTime: 'Delivery in 1-2 Days',
        isTrending: true,
      ),
      const ProductModel(
        id: 'heels_velvet_block',
        title: 'Velvet Block Heels',
        subtitle: 'Chunky block heel sandals with gold buckle strap',
        description:
            'A perfect blend of height and all-day stability. Crafted from plush velvet with breathable leather lining and secure ankle straps.',
        price: 1899.00,
        originalPrice: 3299.00,
        discountPercent: 42,
        rating: 4.7,
        reviewCount: 2890,
        imageUrl: AppAssets.heelsBanner,
        galleryImages: [AppAssets.heelsBanner],
        sizes: ['36 EU', '37 EU', '38 EU', '39 EU', '40 EU', '41 EU'],
        category: 'Heels',
        deliveryTime: 'Free Next Day Delivery',
        isDealOfTheDay: true,
      ),
      const ProductModel(
        id: 'flats_classic_loafers',
        title: 'Classic Leather Loafers',
        subtitle: 'Hand-burnished brown leather penny loafers',
        description:
            'Timeless elegance for your daily commute. Featuring supple leather upper, flexible rubber driving outsole, and cushioned arch support.',
        price: 1499.00,
        originalPrice: 2499.00,
        discountPercent: 40,
        rating: 4.8,
        reviewCount: 3450,
        imageUrl: AppAssets.productBrownLoafers,
        galleryImages: [AppAssets.productBrownLoafers],
        sizes: ['37 EU', '38 EU', '39 EU', '40 EU', '41 EU', '42 EU'],
        category: 'Flats',
        deliveryTime: 'Delivery in 2-3 Days',
      ),
      const ProductModel(
        id: 'flats_slip_on_ballet',
        title: 'Breathable Ballet Flats',
        subtitle: 'Ultra-light flexible round-toe ballerina slip-ons',
        description:
            'Designed for everyday comfort and ease. Ultra-pliable sole folds effortlessly, making them an ideal on-the-go pair for office or casual wear.',
        price: 1199.00,
        originalPrice: 1999.00,
        discountPercent: 40,
        rating: 4.6,
        reviewCount: 1920,
        imageUrl: AppAssets.shoesCrisp,
        galleryImages: [AppAssets.shoesCrisp],
        sizes: ['36 EU', '37 EU', '38 EU', '39 EU', '40 EU'],
        category: 'Flats',
        deliveryTime: 'Delivery in 2 Days',
      ),
      const ProductModel(
        id: 'heels_strappy_sandals',
        title: 'Strappy Evening Heels',
        subtitle: 'Minimalist metallic strap high heel sandals',
        description:
            'Sculpted silhouette with slim criss-cross straps and square open toe. Perfect accompaniment to dresses and party ensembles.',
        price: 2799.00,
        originalPrice: 4499.00,
        discountPercent: 38,
        rating: 4.8,
        reviewCount: 1640,
        imageUrl: AppAssets.heelsBanner,
        galleryImages: [AppAssets.heelsBanner],
        sizes: ['37 EU', '38 EU', '39 EU', '40 EU'],
        category: 'Sandals',
        deliveryTime: 'Express Delivery',
      ),
      const ProductModel(
        id: 'flats_active_cushion',
        title: 'Comfort Daily Walk Flats',
        subtitle: 'Ergonomic supportive slip-on walking flat',
        description:
            'Engineered with dual-density foam midsoles and flexible knit upper to keep you fatigue-free all day long.',
        price: 999.00,
        originalPrice: 1799.00,
        discountPercent: 44,
        rating: 4.5,
        reviewCount: 5120,
        imageUrl: AppAssets.productHrx,
        galleryImages: [AppAssets.productHrx],
        sizes: ['36 EU', '37 EU', '38 EU', '39 EU', '40 EU', '41 EU'],
        category: 'Flats',
        deliveryTime: 'Delivery in 1 Day',
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProductModel> get _filteredProducts {
    final query = _searchController.text.trim().toLowerCase();
    return _products.where((p) {
      final matchesQuery = query.isEmpty ||
          p.title.toLowerCase().contains(query) ||
          p.subtitle.toLowerCase().contains(query) ||
          p.category.toLowerCase().contains(query);

      final matchesCat = _selectedCategoryFilter == 'All' ||
          (_selectedCategoryFilter == 'My Added' && _userAddedIds.contains(p.id)) ||
          p.category.toLowerCase() == _selectedCategoryFilter.toLowerCase();

      return matchesQuery && matchesCat;
    }).toList();
  }



  void _deleteDynamicProduct(ProductModel product) {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Product',
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to remove "${product.title}" from the catalog?',
          style: GoogleFonts.montserrat(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              setState(() {
                _products.removeWhere((p) => p.id == product.id);
                _userAddedIds.remove(product.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Removed "${product.title}"'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Get.find<CartController>();
    final wishlistProvider = Get.find<WishlistController>();

    return Obx(() {
      final displayedList = _filteredProducts;

      final heelsCount = _products.where((p) => p.category.toLowerCase() == 'heels').length;
      final flatsCount = _products.where((p) => p.category.toLowerCase() == 'flats').length;
      final userAddedCount = _userAddedIds.length;

      return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Flat and Heels',
              style: GoogleFonts.playfairDisplay(
                color: const Color(0xFF1B1B1B),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${_products.length} Products Available',
              style: GoogleFonts.montserrat(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TOP DYNAMIC PROMO HERO BANNER
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF7EA), Color(0xFFFFECE5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFE0B2), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 90,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(color: Color(0x14000000), blurRadius: 6),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          AppAssets.heelsBanner,
                          fit: BoxFit.contain,
                          errorBuilder: (ctx, err, stack) => const Icon(Icons.shopping_bag, size: 40, color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'DYNAMIC DATA STUDIO',
                              style: GoogleFonts.montserrat(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Flat and Heels Collection',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF222222),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Explore curated stilettos, flats, wedges, sandals, and stylish luxury footwear.',
                            style: GoogleFonts.montserrat(
                              fontSize: 11,
                              color: const Color(0xFF666666),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 3. SUMMARY STATISTICS CHIPS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _statBadge('All Items', '${_products.length}', const Color(0xFF1B1B1B)),
                    const SizedBox(width: 8),
                    _statBadge('Heels', '$heelsCount', const Color(0xFFF83758)),
                    const SizedBox(width: 8),
                    _statBadge('Flats', '$flatsCount', const Color(0xFF2563EB)),
                    const SizedBox(width: 8),
                    _statBadge('Custom Added', '$userAddedCount', const Color(0xFF059669)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 4. SEARCH BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE5E5E5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() {}),
                    style: GoogleFonts.montserrat(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Search heels, flats, sandals...',
                      hintStyle: GoogleFonts.montserrat(fontSize: 13, color: Colors.grey.shade400),
                      prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // 5. CATEGORY FILTER CHIPS
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _filterChip('All'),
                    _filterChip('Heels'),
                    _filterChip('Flats'),
                    _filterChip('Sandals'),
                    _filterChip('My Added'),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 6. PRODUCTS GRID
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: displayedList.isEmpty
                    ? _buildEmptyState()
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final crossCount = width > 700 ? 3 : 2;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: displayedList.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossCount,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 18,
                              childAspectRatio: 0.58,
                            ),
                            itemBuilder: (context, index) {
                              final product = displayedList[index];
                              final isUserAdded = _userAddedIds.contains(product.id);
                              final isFav = wishlistProvider.isWishlisted(product.id);

                              return _buildProductCard(
                                product: product,
                                isUserAdded: isUserAdded,
                                isFav: isFav,
                                onToggleWishlist: () => wishlistProvider.toggleWishlist(product),
                                onAddToCart: () {
                                  cartProvider.addItem(product);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Added "${product.title}" to bag!'),
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: const Color(0xFF1B1B1B),
                                    ),
                                  );
                                },
                                onDelete: isUserAdded ? () => _deleteDynamicProduct(product) : null,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailsScreen(product: product),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
    });
  }



  Widget _statBadge(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String title) {
    final isSelected = _selectedCategoryFilter == title;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF333333),
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() => _selectedCategoryFilter = title);
          }
        },
        selectedColor: AppColors.primary,
        backgroundColor: Colors.white,
        elevation: isSelected ? 2 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.primary : const Color(0xFFE2E2E2),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(Icons.search_off_outlined, size: 54, color: Colors.grey),
          const SizedBox(height: 14),
          Text(
            'No matching products found',
            style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Try clearing your search or choosing another category filter above!',
            style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required ProductModel product,
    required bool isUserAdded,
    required bool isFav,
    required VoidCallback onToggleWishlist,
    required VoidCallback onAddToCart,
    required VoidCallback onTap,
    VoidCallback? onDelete,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUserAdded ? AppColors.primary.withValues(alpha: 0.35) : const Color(0xFFEFEFEF),
            width: isUserAdded ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isUserAdded
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area with Badges
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFBF9F8),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                      child: product.imageUrl.startsWith('http')
                          ? Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                AppAssets.heelsBanner,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Image.asset(
                              product.imageUrl,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                AppAssets.heelsBanner,
                                fit: BoxFit.contain,
                              ),
                            ),
                    ),
                  ),

                  // Top-left: Category or User Added Badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isUserAdded)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF059669),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'CUSTOM',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${product.discountPercent}% OFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Top-right: Wishlist Heart & Delete (if custom)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: onToggleWishlist,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Color(0x1A000000), blurRadius: 4),
                              ],
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              size: 16,
                              color: isFav ? AppColors.primary : Colors.grey.shade700,
                            ),
                          ),
                        ),
                        if (onDelete != null) ...[
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: onDelete,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(color: Color(0x1A000000), blurRadius: 4),
                                ],
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                size: 16,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    style: GoogleFonts.montserrat(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1B1B1B),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Color(0xFFEDB310)),
                      const SizedBox(width: 3),
                      Text(
                        '${product.rating}',
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviewCount})',
                        style: GoogleFonts.montserrat(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '\u20B9${product.price.toStringAsFixed(0)}',
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1B1B1B),
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (product.originalPrice > product.price)
                        Text(
                          '\u20B9${product.originalPrice.toStringAsFixed(0)}',
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      InkWell(
                        onTap: onAddToCart,
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            size: 15,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
