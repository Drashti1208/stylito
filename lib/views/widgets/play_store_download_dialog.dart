import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

class PlayStoreDownloadDialog extends StatefulWidget {
  const PlayStoreDownloadDialog({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PlayStoreDownloadDialog(),
    );
  }

  @override
  State<PlayStoreDownloadDialog> createState() => _PlayStoreDownloadDialogState();
}

class _PlayStoreDownloadDialogState extends State<PlayStoreDownloadDialog>
    with SingleTickerProviderStateMixin {
  bool _isDownloading = false;
  bool _isInstalled = false;
  double _progress = 0.0;
  Timer? _downloadTimer;

  @override
  void dispose() {
    _downloadTimer?.cancel();
    super.dispose();
  }

  void _startDownload() {
    if (_isInstalled) {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, AppRoutes.main);
      return;
    }

    setState(() {
      _isDownloading = true;
      _progress = 0.0;
    });

    _downloadTimer = Timer.periodic(const Duration(milliseconds: 70), (timer) {
      if (_progress < 1.0) {
        setState(() {
          _progress += 0.035;
        });
      } else {
        timer.cancel();
        setState(() {
          _isDownloading = false;
          _isInstalled = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Play Store Top Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF5F6368)),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Image.asset(
                      AppAssets.logo,
                      height: 24,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.play_arrow,
                        color: Color(0xFF01875F),
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Google Play',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF5F6368),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.search, color: Color(0xFF5F6368)),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Color(0xFF5F6368)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),

          // Scrollable App Listing Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Icon + Title + Developer
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F3),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            AppAssets.logo,
                            width: 56,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.shopping_bag,
                              color: AppColors.primary,
                              size: 38,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Stylito: Fashion & Trends',
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF202124),
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Stylito Technologies Inc.',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF01875F),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Contains ads \u00B7 In-app purchases',
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                color: const Color(0xFF5F6368),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Rating, Size, Age, Downloads Stats Strip
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _metricItem(
                          top: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                '4.8',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Color(0xFF202124),
                                ),
                              ),
                              SizedBox(width: 2),
                              Icon(Icons.star, size: 14, color: Color(0xFF202124)),
                            ],
                          ),
                          bottom: '128K reviews',
                        ),
                        _dividerLine(),
                        _metricItem(
                          top: const Text(
                            '24 MB',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Color(0xFF202124),
                            ),
                          ),
                          bottom: 'Download size',
                        ),
                        _dividerLine(),
                        _metricItem(
                          top: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFF5F6368)),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: const Text(
                              '12+',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                                color: Color(0xFF202124),
                              ),
                            ),
                          ),
                          bottom: 'Rated for 12+',
                        ),
                        _dividerLine(),
                        _metricItem(
                          top: const Text(
                            '5M+',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Color(0xFF202124),
                            ),
                          ),
                          bottom: 'Downloads',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Install / Open / Progress Button
                  if (_isDownloading) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _progress < 0.95 ? 'Downloading...' : 'Installing...',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF01875F),
                              ),
                            ),
                            Text(
                              '${(_progress * 100).toInt()}%',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF5F6368),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: _progress,
                            minHeight: 8,
                            backgroundColor: const Color(0xFFE8F5E9),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF01875F)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              _downloadTimer?.cancel();
                              setState(() {
                                _isDownloading = false;
                                _progress = 0.0;
                              });
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Color(0xFF5F6368), fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    ElevatedButton(
                      onPressed: _startDownload,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isInstalled ? const Color(0xFF0B57D0) : const Color(0xFF01875F),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _isInstalled ? 'Open App' : 'Install',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),

                  // Verified by Play Protect
                  Row(
                    children: [
                      const Icon(Icons.verified_user_outlined, size: 18, color: Color(0xFF01875F)),
                      const SizedBox(width: 8),
                      Text(
                        'Verified by Play Protect',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: const Color(0xFF5F6368),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Screenshots Carousel
                  Text(
                    'Screenshots',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF202124),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _screenshotCard(AppAssets.heroFashion),
                        _screenshotCard(AppAssets.banner50Off),
                        _screenshotCard(AppAssets.catWomens),
                        _screenshotCard(AppAssets.catBeauty),
                        _screenshotCard(AppAssets.catKids),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // About this app
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'About this app',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF202124),
                        ),
                      ),
                      const Icon(Icons.arrow_forward, size: 20, color: Color(0xFF5F6368)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stylito is your all-in-one luxury fashion and trends destination. Shop from over 50,000+ handpicked authentic apparel, footwear, beauty, and accessories with instant doorstep delivery, secure checkout, and easy returns.',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      height: 1.5,
                      color: const Color(0xFF5F6368),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // App Info Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _tagChip('Fashion & Beauty'),
                      _tagChip('Shopping'),
                      _tagChip('#1 Top Free'),
                      _tagChip("Editor's Choice"),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricItem({required Widget top, required String bottom}) {
    return Column(
      children: [
        top,
        const SizedBox(height: 4),
        Text(
          bottom,
          style: GoogleFonts.roboto(
            fontSize: 11,
            color: const Color(0xFF5F6368),
          ),
        ),
      ],
    );
  }

  Widget _dividerLine() {
    return Container(
      width: 1,
      height: 24,
      color: const Color(0xFFE0E0E0),
    );
  }

  Widget _screenshotCard(String path) {
    return Container(
      width: 115,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          path,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: const Color(0xFFF3F4F6),
            child: const Icon(Icons.image, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _tagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF3C4043),
        ),
      ),
    );
  }
}

/// Animated Play Store Badge Button for Landing Pages
class PlayStoreAnimatedButton extends StatefulWidget {
  final VoidCallback? onTap;

  const PlayStoreAnimatedButton({super.key, this.onTap});

  @override
  State<PlayStoreAnimatedButton> createState() => _PlayStoreAnimatedButtonState();
}

class _PlayStoreAnimatedButtonState extends State<PlayStoreAnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 4.0, end: 14.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF83758).withValues(alpha: 0.35),
                  blurRadius: _glowAnimation.value,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: InkWell(
              onTap: widget.onTap ?? () => PlayStoreDownloadDialog.show(context),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFA987), Color(0xFFF87189)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Google Play Logo Icon
                    CustomPaint(
                      size: const Size(22, 22),
                      painter: _GooglePlayIconPainter(),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'GET IT ON',
                          style: GoogleFonts.roboto(
                            fontSize: 9,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        Text(
                          'Google Play',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_downward,
                        size: 13,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GooglePlayIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bluePaint = Paint()..color = const Color(0xFF00C3FF);
    final greenPaint = Paint()..color = const Color(0xFF00E676);
    final redPaint = Paint()..color = const Color(0xFFFF3D00);
    final yellowPaint = Paint()..color = const Color(0xFFFFD600);

    final pathBlue = Path()
      ..moveTo(w * 0.1, h * 0.1)
      ..lineTo(w * 0.65, h * 0.5)
      ..lineTo(w * 0.1, h * 0.9)
      ..close();
    canvas.drawPath(pathBlue, bluePaint);

    final pathGreen = Path()
      ..moveTo(w * 0.65, h * 0.5)
      ..lineTo(w * 0.1, h * 0.1)
      ..lineTo(w * 0.85, h * 0.4)
      ..close();
    canvas.drawPath(pathGreen, greenPaint);

    final pathRed = Path()
      ..moveTo(w * 0.65, h * 0.5)
      ..lineTo(w * 0.1, h * 0.9)
      ..lineTo(w * 0.85, h * 0.6)
      ..close();
    canvas.drawPath(pathRed, redPaint);

    final pathYellow = Path()
      ..moveTo(w * 0.65, h * 0.5)
      ..lineTo(w * 0.85, h * 0.4)
      ..lineTo(w * 0.95, h * 0.5)
      ..lineTo(w * 0.85, h * 0.6)
      ..close();
    canvas.drawPath(pathYellow, yellowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
