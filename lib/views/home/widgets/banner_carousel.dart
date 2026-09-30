import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_assets.dart';

class BannerCarousel extends StatefulWidget {
  final VoidCallback? onShopNow;

  const BannerCarousel({super.key, this.onShopNow});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<String> _bannerImages = [
    AppAssets.banner50Off,
    AppAssets.banner2,
    AppAssets.banner3,
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % _bannerImages.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 190,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _bannerImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final imgPath = _bannerImages[index];
              return GestureDetector(
                onTap: widget.onShopNow,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      imgPath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),

        // Indicator dots matching Figma (circle dots)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_bannerImages.length, (index) {
            final isActive = index == _currentPage;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? const Color(0xFFFA7189) : const Color(0xFFDEDBDB),
              ),
            );
          }),
        ),
      ],
    );
  }
}
