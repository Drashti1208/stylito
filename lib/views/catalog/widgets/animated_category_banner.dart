import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CategoryBannerType { beauty, kids, fashion, mens, womens }

class CategorySlideData {
  final String badgeText;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;

  const CategorySlideData({
    required this.badgeText,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
  });
}

class AnimatedCategoryBanner extends StatefulWidget {
  final CategoryBannerType type;
  final VoidCallback? onTap;

  const AnimatedCategoryBanner({
    super.key,
    required this.type,
    this.onTap,
  });

  const AnimatedCategoryBanner.beauty({super.key, this.onTap})
      : type = CategoryBannerType.beauty;

  const AnimatedCategoryBanner.kids({super.key, this.onTap})
      : type = CategoryBannerType.kids;

  const AnimatedCategoryBanner.fashion({super.key, this.onTap})
      : type = CategoryBannerType.fashion;

  const AnimatedCategoryBanner.mens({super.key, this.onTap})
      : type = CategoryBannerType.mens;

  const AnimatedCategoryBanner.womens({super.key, this.onTap})
      : type = CategoryBannerType.womens;

  @override
  State<AnimatedCategoryBanner> createState() => _AnimatedCategoryBannerState();
}

class _AnimatedCategoryBannerState extends State<AnimatedCategoryBanner>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _floatingController;
  late final AnimationController _pulseController;
  late final Animation<double> _floatingAnimation;
  late final Animation<double> _pulseAnimation;

  int _currentPage = 0;
  Timer? _timer;

  List<CategorySlideData> _getSlides() {
    switch (widget.type) {
      case CategoryBannerType.beauty:
        return const [
          CategorySlideData(
            badgeText: 'PREMIUM BEAUTY EDIT',
            title: 'Glow & Glamour',
            subtitle: 'Foundations, Lipsticks, Palettes & Skincare\nUp to 40% Off on Top Cosmetics',
            icon: Icons.auto_awesome,
            gradientColors: [
              Color(0xFFFF758C),
              Color(0xFFFF7EB3),
              Color(0xFFFA709A),
            ],
          ),
          CategorySlideData(
            badgeText: 'FLASH BEAUTY DEAL',
            title: 'Luxe Care & Scents',
            subtitle: 'Serums, Hydrating Creams & Perfumes\nFlat 25% Off with Code GLOW25',
            icon: Icons.spa_outlined,
            gradientColors: [
              Color(0xFFFA709A),
              Color(0xFFFEE140),
              Color(0xFFFF6E7F),
            ],
          ),
          CategorySlideData(
            badgeText: 'TRENDING IN COSMETICS',
            title: 'Velvet Mattes & Lip Care',
            subtitle: 'Long-lasting pigments & organic lip oils\nBuy 2 Get 1 Free on Luxury Shades',
            icon: Icons.brush_outlined,
            gradientColors: [
              Color(0xFFE91E63),
              Color(0xFFFF5252),
              Color(0xFFFF758C),
            ],
          ),
        ];

      case CategoryBannerType.kids:
        return const [
          CategorySlideData(
            badgeText: 'LIL\' STYLISTS & PLAY',
            title: 'Cool, Comfy & Fun',
            subtitle: 'Co-ords, Graphic Tees & Luggage\nSpecial Discounts for Happy Kids',
            icon: Icons.toys_outlined,
            gradientColors: [
              Color(0xFFFF9966),
              Color(0xFFFF5E62),
              Color(0xFFFC6767),
            ],
          ),
          CategorySlideData(
            badgeText: 'SUMMER PLAY SALE',
            title: 'Bright Colors & Sets',
            subtitle: 'Soft cotton sets, sneakers & sunnies\nUp to 45% Off Kidswear Collection',
            icon: Icons.child_care_outlined,
            gradientColors: [
              Color(0xFFFFA07A),
              Color(0xFFFF7043),
              Color(0xFFFF5252),
            ],
          ),
          CategorySlideData(
            badgeText: 'ADVENTURE READY',
            title: 'Luggage & Backpacks',
            subtitle: '3D Unicorn & Robot travel gear\nExtra 15% Off with Code KIDS15',
            icon: Icons.backpack_outlined,
            gradientColors: [
              Color(0xFFFF6F61),
              Color(0xFFDE6262),
              Color(0xFFFFB88C),
            ],
          ),
        ];

      case CategoryBannerType.fashion:
        return const [
          CategorySlideData(
            badgeText: 'ALL FASHION FEST',
            title: 'Runway & Trendsetters',
            subtitle: 'The Hottest Looks Across All Styles\n50-40% Off on Signature Outfits',
            icon: Icons.style_outlined,
            gradientColors: [
              Color(0xFFF83758),
              Color(0xFFFF5277),
              Color(0xFF9C27B0),
            ],
          ),
          CategorySlideData(
            badgeText: 'NEW SEASON DROP',
            title: 'Designer Couture',
            subtitle: 'Statement dresses, tailored jackets & sneakers\nComplimentary Express Delivery',
            icon: Icons.diamond_outlined,
            gradientColors: [
              Color(0xFF8E2DE2),
              Color(0xFFF83758),
              Color(0xFFFF6E7F),
            ],
          ),
          CategorySlideData(
            badgeText: 'TRENDING ATELIER',
            title: 'Streetwear & Classics',
            subtitle: 'Urban aesthetics, denim fits & accessories\nFlat ₹300 Off on First Fashion Order',
            icon: Icons.checkroom_outlined,
            gradientColors: [
              Color(0xFF2C3E50),
              Color(0xFFF83758),
              Color(0xFFFF758C),
            ],
          ),
        ];

      case CategoryBannerType.mens:
        return const [
          CategorySlideData(
            badgeText: 'MEN\'S POWER EDIT',
            title: 'Modern & Sharp',
            subtitle: 'Suits, Streetwear, Sneakers & Loafers\nMin 30% Off on Top Brands',
            icon: Icons.male_rounded,
            gradientColors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
          CategorySlideData(
            badgeText: 'WEEKEND CASUALS',
            title: 'Denims & Polo Shirts',
            subtitle: 'Breathable linens, oxford shirts & slip-ons\nFlat ₹500 Off with Code MEN500',
            icon: Icons.iron_outlined,
            gradientColors: [
              Color(0xFF1E3C72),
              Color(0xFF2A5298),
              Color(0xFF4A90E2),
            ],
          ),
          CategorySlideData(
            badgeText: 'SNEAKER HUB',
            title: 'Air Soles & Trainers',
            subtitle: 'High-top sneakers & athletic runners\nUp to 40% Off on Premium Kicks',
            icon: Icons.sports_tennis_outlined,
            gradientColors: [
              Color(0xFF141E30),
              Color(0xFF243B55),
              Color(0xFF2C5364),
            ],
          ),
        ];

      case CategoryBannerType.womens:
        return const [
          CategorySlideData(
            badgeText: 'WOMENS BOUTIQUE',
            title: 'Grace, Elegance & Chic',
            subtitle: 'Ethnic Kurtas, Boho Dresses & Heels\nUp to 60% Off on Festive Wear',
            icon: Icons.female_rounded,
            gradientColors: [
              Color(0xFF8E2DE2),
              Color(0xFF6A11CB),
              Color(0xFF4A00E0),
            ],
          ),
          CategorySlideData(
            badgeText: 'CELEBRATION EDIT',
            title: 'Anarkalis & Designer Sarees',
            subtitle: 'Hand-embroidered silk & georgette sets\nFree Matching Stole with Every Dress',
            icon: Icons.auto_fix_high,
            gradientColors: [
              Color(0xFF9C27B0),
              Color(0xFFE91E63),
              Color(0xFF8E2DE2),
            ],
          ),
          CategorySlideData(
            badgeText: 'BOHO & CASUAL',
            title: 'Heels, Flats & Tunics',
            subtitle: 'Comfort meets chic everyday glamour\nExtra 20% Off on 2 or More Items',
            icon: Icons.flare_outlined,
            gradientColors: [
              Color(0xFF7B1FA2),
              Color(0xFFBA68C8),
              Color(0xFF512DA8),
            ],
          ),
        ];
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    final slides = _getSlides();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % slides.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 550),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slides = _getSlides();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 2),
      child: Column(
        children: [
          SizedBox(
            height: 122,
            child: PageView.builder(
              controller: _pageController,
              itemCount: slides.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final slide = slides[index];
                return GestureDetector(
                  onTap: widget.onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: slide.gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: slide.gradientColors.first.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Background decorative ambient circles
                        Positioned(
                          right: -10,
                          top: -15,
                          child: AnimatedBuilder(
                            animation: _floatingAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _floatingAnimation.value * 0.4),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        Row(
                          children: [
                            // Text Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Animated Tag Badge
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.25),
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(
                                            color: Colors.white.withValues(alpha: 0.35),
                                            width: 0.8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AnimatedBuilder(
                                              animation: _pulseAnimation,
                                              builder: (context, child) {
                                                return Transform.scale(
                                                  scale: _pulseAnimation.value,
                                                  child: Container(
                                                    width: 5,
                                                    height: 5,
                                                    margin: const EdgeInsets.only(right: 4),
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            Text(
                                              slide.badgeText,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 8.5,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.8,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),

                                  // Animated Title
                                  Text(
                                    slide.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.playfairDisplay(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                  const SizedBox(height: 2),

                                  // Subtitle / Discount
                                  Text(
                                    slide.subtitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.92),
                                      fontSize: 10,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Floating Icon Graphic
                            AnimatedBuilder(
                              animation: _floatingAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _floatingAnimation.value * 0.7),
                                  child: child,
                                );
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.22),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.45),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    slide.icon,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),

          // Animated Slide Indicator Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(slides.length, (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                width: isActive ? 14 : 5,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isActive
                    ? (slides[_currentPage].gradientColors.first)
                    : const Color(0xFFDCDCDC),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
