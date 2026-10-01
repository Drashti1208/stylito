import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_routes.dart';
import '../../models/product_model.dart';
import '../home/widgets/product_card.dart';
import 'widgets/animated_category_banner.dart';

class FashionProductsScreen extends StatefulWidget {
  final String? initialFilter;

  const FashionProductsScreen({super.key, this.initialFilter});

  @override
  State<FashionProductsScreen> createState() => _FashionProductsScreenState();
}

class _FashionProductsScreenState extends State<FashionProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _sortBy = 'featured';

  final List<String> _categories = [
    'All',
    'Womenswear',
    'Menswear',
    'Dresses & Gowns',
    'Footwear & Sneakers',
    'Outerwear',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialFilter != null && _categories.contains(widget.initialFilter)) {
      _selectedCategory = widget.initialFilter!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProductModel> get _filteredProducts {
    final query = _searchController.text.trim().toLowerCase();
    List<ProductModel> list = ProductModel.fashionProducts.where((p) {
      final matchesQuery = query.isEmpty ||
          p.title.toLowerCase().contains(query) ||
          p.subtitle.toLowerCase().contains(query) ||
          p.description.toLowerCase().contains(query);

      bool matchesCat = true;
      if (_selectedCategory == 'Womenswear') {
        matchesCat = p.category == 'womens';
      } else if (_selectedCategory == 'Menswear') {
        matchesCat = p.category == 'mens';
      } else if (_selectedCategory == 'Dresses & Gowns') {
        matchesCat = p.title.toLowerCase().contains('dress') ||
            p.title.toLowerCase().contains('kurta');
      } else if (_selectedCategory == 'Footwear & Sneakers') {
        matchesCat = p.title.toLowerCase().contains('sneakers') ||
            p.title.toLowerCase().contains('heels') ||
            p.title.toLowerCase().contains('loafers');
      } else if (_selectedCategory == 'Outerwear') {
        matchesCat = p.title.toLowerCase().contains('jacket') ||
            p.title.toLowerCase().contains('winter');
      }

      return matchesQuery && matchesCat;
    }).toList();

    if (_sortBy == 'price_low') {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'price_high') {
      list.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sortBy == 'rating') {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return list;
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Sort Fashion Items By', style: AppTextStyles.bodyBold),
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('Featured / Popular'),
                trailing: _sortBy == 'featured' ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  setState(() => _sortBy = 'featured');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Price: Low to High'),
                trailing: _sortBy == 'price_low' ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  setState(() => _sortBy = 'price_low');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Price: High to Low'),
                trailing: _sortBy == 'price_high' ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  setState(() => _sortBy = 'price_high');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Customer Rating'),
                trailing: _sortBy == 'rating' ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  setState(() => _sortBy = 'rating');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Get.find<CartController>();
    final displayedProducts = _filteredProducts;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
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
              'Fashion Runway',
              style: GoogleFonts.playfairDisplay(
                color: const Color(0xFF1B1B1B),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Trending Outfits & Curated Styles',
              style: GoogleFonts.montserrat(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Color(0xFF1B1B1B)),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.main);
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF1B1B1B)),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.cart);
                },
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Obx(() {
                  if (cartProvider.itemCount <= 0) return const SizedBox.shrink();
                  return Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cartProvider.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 1. ANIMATED HERO PROMO BANNER
          const SliverToBoxAdapter(
            child: AnimatedCategoryBanner.fashion(),
          ),

          // 2. SEARCH BAR
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search fashion styles, brands, outfits...',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 22),
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 14)),

          // 3. CATEGORY FILTER CHIPS
          SliverToBoxAdapter(
            child: SizedBox(
              height: 38,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategory = cat);
                      }
                    },
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF333333),
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : Colors.grey.shade300,
                      ),
                    ),
                    showCheckmark: false,
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 14)),

          // 4. HEADER: ITEM COUNT & SORT ACTION
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${displayedProducts.length} Fashion Products',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF1B1B1B),
                    ),
                  ),
                  InkWell(
                    onTap: _showSortDialog,
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.sort, size: 16, color: Color(0xFF1B1B1B)),
                          SizedBox(width: 4),
                          Text(
                            'Sort',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // 5. PRODUCTS GRID OR EMPTY STATE
          if (displayedProducts.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 60, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text(
                      'No fashion products found',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Try searching for another style or reset filter.',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _selectedCategory = 'All';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Reset Filter'),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.64,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = displayedProducts[index];
                    return ProductCard(product: product);
                  },
                  childCount: displayedProducts.length,
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }
}
