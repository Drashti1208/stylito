import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/navigation_controller.dart';
import '../core/constants/app_colors.dart';
import 'cart/shopping_bag_screen.dart';
import 'catalog/trending_products_screen.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';
import 'wishlist/wishlist_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavigationController>();
    final cartController = Get.find<CartController>();

    final List<Widget> pages = [
      HomeScreen(onNavigateTab: navController.changeTab),
      const WishlistScreen(),
      const ShoppingBagScreen(showBackButton: false),
      TrendingProductsScreen(onNavigateTab: navController.changeTab),
      const ProfileScreen(showBackButton: false),
    ];

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: navController.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(navController, 0, Icons.home_outlined, Icons.home, 'Home'),
                  _buildNavItem(navController, 1, Icons.favorite_border, Icons.favorite, 'Wishlist'),
                  _buildCenterCartButton(navController, cartController),
                  _buildNavItem(navController, 3, Icons.search, Icons.search, 'Search'),
                  _buildNavItem(navController, 4, Icons.settings_outlined, Icons.settings, 'Setting'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    NavigationController navController,
    int index,
    IconData outlineIcon,
    IconData filledIcon,
    String label,
  ) {
    final isSelected = navController.currentIndex.value == index;
    return InkWell(
      onTap: () => navController.changeTab(index),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : outlineIcon,
              color: isSelected ? AppColors.primary : AppColors.textDark,
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textDark,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterCartButton(
    NavigationController navController,
    CartController cartController,
  ) {
    return GestureDetector(
      onTap: () => navController.changeTab(2),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.shopping_cart_outlined,
                color: Color(0xFF17223B),
                size: 24,
              ),
            ),
          ),
          Obx(() {
            final badgeCount = cartController.itemCount;
            if (badgeCount <= 0) return const SizedBox.shrink();
            return Positioned(
              top: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
