import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import 'stylish_logo.dart';

class AppDrawer extends StatelessWidget {
  final ValueChanged<int>? onNavigateTab;
  final int currentTabIndex;

  const AppDrawer({
    super.key,
    this.onNavigateTab,
    this.currentTabIndex = 0,
  });

  void _handleNavigation(BuildContext context, int tabIndex) {
    Navigator.pop(context);
    if (onNavigateTab != null) {
      onNavigateTab!(tabIndex);
    } else {
      switch (tabIndex) {
        case 0:
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (r) => false);
          break;
        case 1:
          Navigator.pushNamed(context, AppRoutes.main);
          break;
        case 2:
          Navigator.pushNamed(context, AppRoutes.cart);
          break;
        case 3:
          Navigator.pushNamed(context, AppRoutes.catalog);
          break;
        case 4:
          Navigator.pushNamed(context, AppRoutes.profile);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primaryLight),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StylishLogo(height: 40),
                SizedBox(height: 10),
                Text(
                  'Fashion at your fingertips',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              currentTabIndex == 0 ? Icons.home : Icons.home_outlined,
              color: currentTabIndex == 0 ? AppColors.primary : AppColors.textDark,
            ),
            title: Text(
              'Home',
              style: TextStyle(
                color: currentTabIndex == 0 ? AppColors.primary : AppColors.textDark,
                fontWeight: currentTabIndex == 0 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: currentTabIndex == 0,
            selectedTileColor: AppColors.primaryLight.withValues(alpha: 0.5),
            onTap: () => _handleNavigation(context, 0),
          ),
          ListTile(
            leading: Icon(
              currentTabIndex == 3 ? Icons.search : Icons.search_outlined,
              color: currentTabIndex == 3 ? AppColors.primary : AppColors.textDark,
            ),
            title: Text(
              'Search & Catalog',
              style: TextStyle(
                color: currentTabIndex == 3 ? AppColors.primary : AppColors.textDark,
                fontWeight: currentTabIndex == 3 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: currentTabIndex == 3,
            selectedTileColor: AppColors.primaryLight.withValues(alpha: 0.5),
            onTap: () => _handleNavigation(context, 3),
          ),
          ListTile(
            leading: Icon(
              currentTabIndex == 1 ? Icons.favorite : Icons.favorite_border,
              color: currentTabIndex == 1 ? AppColors.primary : AppColors.textDark,
            ),
            title: Text(
              'Wishlist',
              style: TextStyle(
                color: currentTabIndex == 1 ? AppColors.primary : AppColors.textDark,
                fontWeight: currentTabIndex == 1 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: currentTabIndex == 1,
            selectedTileColor: AppColors.primaryLight.withValues(alpha: 0.5),
            onTap: () => _handleNavigation(context, 1),
          ),
          ListTile(
            leading: Icon(
              currentTabIndex == 2 ? Icons.shopping_bag : Icons.shopping_bag_outlined,
              color: currentTabIndex == 2 ? AppColors.primary : AppColors.textDark,
            ),
            title: Text(
              'Shopping Bag',
              style: TextStyle(
                color: currentTabIndex == 2 ? AppColors.primary : AppColors.textDark,
                fontWeight: currentTabIndex == 2 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: currentTabIndex == 2,
            selectedTileColor: AppColors.primaryLight.withValues(alpha: 0.5),
            onTap: () => _handleNavigation(context, 2),
          ),
          ListTile(
            leading: Icon(
              currentTabIndex == 4 ? Icons.person : Icons.person_outline,
              color: currentTabIndex == 4 ? AppColors.primary : AppColors.textDark,
            ),
            title: Text(
              'My Profile',
              style: TextStyle(
                color: currentTabIndex == 4 ? AppColors.primary : AppColors.textDark,
                fontWeight: currentTabIndex == 4 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: currentTabIndex == 4,
            selectedTileColor: AppColors.primaryLight.withValues(alpha: 0.5),
            onTap: () => _handleNavigation(context, 4),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language, color: AppColors.primary),
            title: const Text(
              'Desktop Website View',
              style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
            subtitle: const Text('View website layout format'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.website);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.primary),
            title: const Text(
              'Log Out',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.signIn);
            },
          ),
        ],
      ),
    );
  }
}
