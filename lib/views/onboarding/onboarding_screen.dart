import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingItem> _pages = [
    OnboardingItem(
      title: 'Choose Products',
      description:
          'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',
      imagePath: AppAssets.onboarding1,
      icon: Icons.shopping_bag_outlined,
      accentColor: const Color(0xFFF83758),
    ),
    OnboardingItem(
      title: 'Make Payment',
      description:
          'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',
      imagePath: AppAssets.onboarding2,
      icon: Icons.credit_card_outlined,
      accentColor: const Color(0xFF4392F9),
    ),
    OnboardingItem(
      title: 'Get Your Order',
      description:
          'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',
      imagePath: AppAssets.onboarding3,
      icon: Icons.local_shipping_outlined,
      accentColor: const Color(0xFF31B757),
    ),
  ];

  void _onNext() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToGetStarted();
    }
  }

  void _onPrev() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateToGetStarted() {
    Navigator.pushReplacementNamed(context, AppRoutes.getStarted);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Page counter & Skip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '${_currentIndex + 1}',
                      style: AppTextStyles.bodyBold.copyWith(
                        color: AppColors.textDark,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: '/${_pages.length}',
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 16,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _navigateToGetStarted,
                    child: Text(
                      'Skip',
                      style: AppTextStyles.bodyBold.copyWith(
                        color: AppColors.textDark,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Exact Figma Illustration from assets
                        _buildIllustration(item),
                        const SizedBox(height: 36),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.heading2.copyWith(fontSize: 24),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          item.description,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 14,
                            height: 1.5,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Controls (Prev, Indicators, Next / Get Started)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Prev button
                  SizedBox(
                    width: 80,
                    child: _currentIndex > 0
                        ? TextButton(
                            onPressed: _onPrev,
                            style: TextButton.styleFrom(alignment: Alignment.centerLeft),
                            child: Text(
                              'Prev',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textLight,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  // Indicator Dots
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_pages.length, (index) {
                      final isActive = index == _currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.textDark : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  // Next / Get Started button
                  SizedBox(
                    width: 100,
                    child: TextButton(
                      onPressed: _onNext,
                      style: TextButton.styleFrom(alignment: Alignment.centerRight),
                      child: Text(
                        _currentIndex == _pages.length - 1 ? 'Get Started' : 'Next',
                        style: AppTextStyles.bodyBold.copyWith(
                          color: AppColors.primary,
                          fontSize: 16,
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
    );
  }

  Widget _buildIllustration(OnboardingItem item) {
    return SizedBox(
      width: 300,
      height: 270,
      child: Image.asset(
        item.imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            color: item.accentColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            item.icon,
            size: 90,
            color: item.accentColor,
          ),
        ),
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final String imagePath;
  final IconData icon;
  final Color accentColor;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.icon,
    required this.accentColor,
  });
}
