import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_routes.dart';
import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../widgets/app_drawer.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/category_item.dart';
import 'widgets/deal_of_day_section.dart';
import 'widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  final Function(int)? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final categories = CategoryModel.sampleCategories;
    final dealProducts = ProductModel.sampleProducts.where((p) => p.isDealOfTheDay).toList();
    final trendingProducts = ProductModel.sampleProducts.where((p) => p.isTrending).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => Center(
            child: InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.only(left: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.menu, size: 20, color: Color(0xFF17223B)),
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
              if (onNavigateTab != null) {
                onNavigateTab!(4); // Profile tab
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
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
      drawer: AppDrawer(
        onNavigateTab: onNavigateTab,
        currentTabIndex: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  readOnly: true,
                  onTap: () {
                    if (onNavigateTab != null) {
                      onNavigateTab!(3); // Search/Catalog tab
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Search any Product..',
                    hintStyle: AppTextStyles.caption.copyWith(color: const Color(0xFFBBBBBB)),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFFBBBBBB)),
                    suffixIcon: const Icon(Icons.mic_none, color: Color(0xFFBBBBBB)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // All Featured Header & Sort / Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('All Featured', style: AppTextStyles.heading3.copyWith(fontSize: 18)),
                  Row(
                    children: [
                      _filterPill('Sort', Icons.swap_vert, () {
                        if (onNavigateTab != null) onNavigateTab!(3);
                      }),
                      const SizedBox(width: 8),
                      _filterPill('Filter', Icons.filter_alt_outlined, () {
                        if (onNavigateTab != null) onNavigateTab!(3);
                      }),
                    ],
                  ),
                ],
              ),
            ),

            // Categories Strip
            SizedBox(
              height: 90,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return CategoryItem(
                    category: categories[index],
                    index: index,
                    onTap: () {
                      switch (categories[index].id) {
                        case 'beauty':
                          Navigator.pushNamed(context, AppRoutes.beauty);
                          break;
                        case 'kids':
                          Navigator.pushNamed(context, AppRoutes.kids);
                          break;
                        case 'fashion':
                          Navigator.pushNamed(context, AppRoutes.fashion);
                          break;
                        case 'mens':
                          Navigator.pushNamed(context, AppRoutes.mens);
                          break;
                        case 'womens':
                          Navigator.pushNamed(context, AppRoutes.womens);
                          break;
                        default:
                          if (onNavigateTab != null) onNavigateTab!(3);
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Promotional Banner Carousel
            BannerCarousel(
              onShopNow: () {
                if (onNavigateTab != null) onNavigateTab!(3);
              },
            ),
            const SizedBox(height: 20),

            // Deal of the Day Section
            DealOfDaySection(
              products: dealProducts.isNotEmpty ? dealProducts : ProductModel.sampleProducts.take(3).toList(),
              onViewAll: () {
                if (onNavigateTab != null) onNavigateTab!(3);
              },
            ),
            const SizedBox(height: 20),
            //
            // // Special Offers Card
            // SpecialOffersBanner(
            //   onTap: () {
            //     if (onNavigateTab != null) onNavigateTab!(3);
            //   },
            // ),
            // const SizedBox(height: 20),

            // Flat and Heels promo card matching Figma exactly - Opens dynamic Flat & Heels page
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.flatAndHeels);
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7EA),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          AppAssets.heelsBanner,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                          isAntiAlias: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Flat and Heels',
                            style: AppTextStyles.bodyBold.copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Stand a chance to get rewarded',
                            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Visit now',
                                    style: AppTextStyles.caption.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.arrow_forward, size: 12, color: Colors.white),
                                ],
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
            const SizedBox(height: 20),

            // Trending Products Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFD6E87),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trending Products',
                          style: AppTextStyles.bodyBold.copyWith(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 12, color: Colors.white70),
                            const SizedBox(width: 4),
                            Text(
                              'Last Date 17/09/26',
                              style: AppTextStyles.caption.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        if (onNavigateTab != null) onNavigateTab!(3);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'View all',
                              style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward, size: 12, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Horizontal Trending List
            SizedBox(
              height: 275,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: trendingProducts.length,
                separatorBuilder: (context, index) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  return ProductCard(product: trendingProducts[index], width: 175);
                },
              ),
            ),
            const SizedBox(height: 20),

            // Hot Summer Sale Banner with clear image
            GestureDetector(
              onTap: () {
                if (onNavigateTab != null) onNavigateTab!(3);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE8D7),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        'assets/images/hot_summer_sale.png',
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        isAntiAlias: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'New Arrivals',
                                style: AppTextStyles.heading3.copyWith(fontSize: 18),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Summer '25 Collections",
                                style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'View all',
                                  style: AppTextStyles.caption.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_forward, size: 12, color: Colors.white),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sponsored Card - Up to 50% OFF - Opens Flat and Heels page
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.flatAndHeels);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                      child: Text(
                        'Sponserd',
                        style: AppTextStyles.heading3.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF222222),
                        ),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(
                              'assets/images/shoes_crisp.png',
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              isAntiAlias: true,
                            ),
                          ),
                        ),
                        // "UP TO 50% OFF" Banner overlay
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withValues(alpha: 0.4),
                                Colors.black.withValues(alpha: 0.1),
                                Colors.black.withValues(alpha: 0.5),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(width: 40, height: 1.5, color: Colors.white),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        'UP TO',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                    Container(width: 40, height: 1.5, color: Colors.white),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  '50% OFF',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'up to 50% Off',
                            style: AppTextStyles.bodyBold.copyWith(
                              fontSize: 15,
                              color: const Color(0xFF222222),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF555555)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }



  Widget _filterPill(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 2),
            Icon(icon, size: 13, color: AppColors.textDark),
          ],
        ),
      ),
    );
  }
}
