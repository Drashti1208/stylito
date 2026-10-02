import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_assets.dart';
import '../../core/routes/app_routes.dart';

class PlayStoreDownloadDialog extends StatefulWidget {
  final bool isDialog;

  const PlayStoreDownloadDialog({super.key, this.isDialog = false});

  static void show(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;
    if (isDesktop) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => const Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: PlayStoreDownloadDialog(isDialog: true),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const PlayStoreDownloadDialog(isDialog: false),
      );
    }
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
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 600 || widget.isDialog;

    final dialogWidth = isDesktop ? 390.0 : double.infinity;
    final dialogHeight = isDesktop
        ? (size.height > 600 ? 530.0 : size.height * 0.82)
        : size.height * 0.70;

    final borderRadius = isDesktop
        ? BorderRadius.circular(18)
        : const BorderRadius.vertical(top: Radius.circular(18));

    return Center(
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 540,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Column(
            children: [
              // Play Store Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF5F6368), size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        CustomPaint(
                          size: const Size(18, 18),
                          painter: _GooglePlayIconPainter(),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Google Play',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF5F6368),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.search, color: Color(0xFF5F6368), size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Color(0xFF5F6368), size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE0E0E0)),

              // Scrollable App Listing Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App Icon + Title + Developer
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Image.asset(
                                AppAssets.appLogoMark,
                                width: 36,
                                height: 36,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => CustomPaint(
                                  size: const Size(34, 34),
                                  painter: _StylitoLogoMarkPainter(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Stylito: Fashion & Trends',
                                  style: GoogleFonts.roboto(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF202124),
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Stylito Technologies Inc.',
                                  style: GoogleFonts.roboto(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF01875F),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Contains ads \u00B7 In-app purchases',
                                  style: GoogleFonts.roboto(
                                    fontSize: 11,
                                    color: const Color(0xFF5F6368),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Rating, Size, Age, Downloads Stats Strip
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
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
                                      fontSize: 13,
                                      color: Color(0xFF202124),
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Icon(Icons.star, size: 12, color: Color(0xFF202124)),
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
                                  fontSize: 13,
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
                                    fontSize: 10,
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
                                  fontSize: 13,
                                  color: Color(0xFF202124),
                                ),
                              ),
                              bottom: 'Downloads',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

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
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF01875F),
                                  ),
                                ),
                                Text(
                                  '${(_progress * 100).toInt()}%',
                                  style: GoogleFonts.roboto(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF5F6368),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: _progress,
                                minHeight: 6,
                                backgroundColor: const Color(0xFFE8F5E9),
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF01875F)),
                              ),
                            ),
                            const SizedBox(height: 8),
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
                                  style: TextStyle(color: Color(0xFF5F6368), fontWeight: FontWeight.w600, fontSize: 12),
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
                            minimumSize: const Size(double.infinity, 42),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            _isInstalled ? 'Open App' : 'Install',
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),

                      // Verified by Play Protect
                      Row(
                        children: [
                          const Icon(Icons.verified_user_outlined, size: 16, color: Color(0xFF01875F)),
                          const SizedBox(width: 6),
                          Text(
                            'Verified by Play Protect',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: const Color(0xFF5F6368),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Screenshots Carousel
                      Text(
                        'Screenshots',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF202124),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 140,
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
                      const SizedBox(height: 18),

                      // About this app
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'About this app',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF202124),
                            ),
                          ),
                          const Icon(Icons.arrow_forward, size: 18, color: Color(0xFF5F6368)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Stylito is your all-in-one luxury fashion and trends destination. Shop from over 50,000+ handpicked authentic apparel, footwear, beauty, and accessories with instant doorstep delivery, secure checkout, and easy returns.',
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          height: 1.45,
                          color: const Color(0xFF5F6368),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // App Info Tags
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _tagChip('Fashion & Beauty'),
                          _tagChip('Shopping'),
                          _tagChip('#1 Top Free'),
                          _tagChip("Editor's Choice"),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricItem({required Widget top, required String bottom}) {
    return Column(
      children: [
        top,
        const SizedBox(height: 3),
        Text(
          bottom,
          style: GoogleFonts.roboto(
            fontSize: 10,
            color: const Color(0xFF5F6368),
          ),
        ),
      ],
    );
  }

  Widget _dividerLine() {
    return Container(
      width: 1,
      height: 20,
      color: const Color(0xFFE0E0E0),
    );
  }

  Widget _screenshotCard(String path) {
    return Container(
      width: 85,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          path,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: const Color(0xFFF3F4F6),
            child: const Icon(Icons.image, color: Colors.grey, size: 24),
          ),
        ),
      ),
    );
  }

  Widget _tagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: GoogleFonts.roboto(
          fontSize: 11,
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

class _StylitoLogoMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;
    final strokeWidth = size.width * 0.22;
    final rect = Rect.fromCircle(center: center, radius: radius);

    const gradient = SweepGradient(
      startAngle: 0.0,
      endAngle: 3.141592653589793 * 2,
      colors: [
        Color(0xFFFF3366), // Vibrant Pink/Red
        Color(0xFFFF9100), // Orange
        Color(0xFFFFD600), // Amber Yellow
        Color(0xFF00E676), // Green
        Color(0xFF00B0FF), // Sky Blue
        Color(0xFFFF3366), // Loop back
      ],
    );

    final ringPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

