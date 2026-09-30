import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/product_model.dart';
import '../home/widgets/product_card.dart';

import '../widgets/app_drawer.dart';

class TrendingProductsScreen extends StatefulWidget {
  final String? initialCategory;
  final ValueChanged<int>? onNavigateTab;
  final bool showBackButton;

  const TrendingProductsScreen({
    super.key,
    this.initialCategory,
    this.onNavigateTab,
    this.showBackButton = false,
  });

  @override
  State<TrendingProductsScreen> createState() => _TrendingProductsScreenState();
}

class _TrendingProductsScreenState extends State<TrendingProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _filteredProducts = [];
  String _sortBy = 'featured';

  @override
  void initState() {
    super.initState();
    _filterProducts();
  }

  void _filterProducts([String query = '']) {
    final all = ProductModel.sampleProducts;
    setState(() {
      _filteredProducts = all.where((product) {
        final matchesCategory = widget.initialCategory == null ||
            widget.initialCategory == 'all' ||
            product.category.toLowerCase() == widget.initialCategory!.toLowerCase();
        final matchesQuery = query.isEmpty ||
            product.title.toLowerCase().contains(query.toLowerCase()) ||
            product.subtitle.toLowerCase().contains(query.toLowerCase());
        return matchesCategory && matchesQuery;
      }).toList();

      if (_sortBy == 'price_low') {
        _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
      } else if (_sortBy == 'price_high') {
        _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
      } else if (_sortBy == 'rating') {
        _filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
      }
    });
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
              ListTile(
                title: Text('Featured', style: AppTextStyles.bodyMedium),
                trailing: _sortBy == 'featured' ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  setState(() => _sortBy = 'featured');
                  _filterProducts(_searchController.text);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Price: Low to High', style: AppTextStyles.bodyMedium),
                trailing: _sortBy == 'price_low' ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  setState(() => _sortBy = 'price_low');
                  _filterProducts(_searchController.text);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Price: High to Low', style: AppTextStyles.bodyMedium),
                trailing: _sortBy == 'price_high' ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  setState(() => _sortBy = 'price_high');
                  _filterProducts(_searchController.text);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Customer Rating', style: AppTextStyles.bodyMedium),
                trailing: _sortBy == 'rating' ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  setState(() => _sortBy = 'rating');
                  _filterProducts(_searchController.text);
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      drawer: AppDrawer(
        onNavigateTab: widget.onNavigateTab,
        currentTabIndex: 3,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => Center(
            child: InkWell(
              onTap: () {
                if (widget.showBackButton) {
                  Navigator.pop(context);
                } else {
                  Scaffold.of(context).openDrawer();
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.only(left: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    widget.showBackButton ? Icons.arrow_back : Icons.menu,
                    size: 20,
                    color: const Color(0xFF17223B),
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Image.asset(
          AppAssets.logoHeader,
          height: 32,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          isAntiAlias: true,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              if (widget.onNavigateTab != null) {
                widget.onNavigateTab!(4);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              width: 38,
              height: 38,
              child: ClipOval(
                child: Image.asset(
                  AppAssets.userAvatar,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  isAntiAlias: true,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterProducts,
                  decoration: InputDecoration(
                    hintText: 'Search any Product..',
                    hintStyle: AppTextStyles.caption.copyWith(
                      color: const Color(0xFFBBBBBB),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFFBBBBBB)),
                    suffixIcon: const Icon(Icons.mic_none, color: Color(0xFFBBBBBB)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // Items Count and Filter Strip
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '52,082+ Iteams',
                    style: AppTextStyles.bodyBold.copyWith(fontSize: 16),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: _showSortDialog,
                        borderRadius: BorderRadius.circular(6),
                        child: _filterPill('Sort', Icons.swap_vert),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Filter options applied!'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: _filterPill('Filter', Icons.filter_alt_outlined),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Product Grid
            Expanded(
              child: _filteredProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 60, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text('No products found', style: AppTextStyles.subHeading),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: _filteredProducts[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterPill(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textDark,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          Icon(icon, size: 14, color: AppColors.textDark),
        ],
      ),
    );
  }
}
