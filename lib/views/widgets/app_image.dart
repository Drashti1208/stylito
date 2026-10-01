import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  String _sanitizePath(String rawPath) {
    if (rawPath.isEmpty) return 'assets/images/product_flare_dress.png';

    // Map legacy database names to actual asset files
    final legacyMap = {
      'assets/images/kurta.png': 'assets/images/product_kurta.png',
      'assets/images/shoes.png': 'assets/images/product_hrx.png',
      'assets/images/philips_trimmer.png': 'assets/images/product_mens_starry.png',
      'assets/images/womens_casual.png': 'assets/images/product_kurta.png',
      'assets/images/mens_jacket.png': 'assets/images/product_leather_jacket.png',
      'assets/images/heels.png': 'assets/images/heels_banner.png',
      'assets/images/nike_sneakers.png': 'assets/images/product_nike_shop.png',
      'assets/images/black_dress.png': 'assets/images/product_black_dress.png',
      'assets/images/flare_dress.png': 'assets/images/product_flare_dress.png',
      'assets/images/denim_dress.png': 'assets/images/product_denim_dress.png',
      'assets/images/starry_shirt.png': 'assets/images/product_mens_starry.png',
    };

    if (legacyMap.containsKey(rawPath)) {
      return legacyMap[rawPath]!;
    }

    return rawPath;
  }

  @override
  Widget build(BuildContext context) {
    final cleanPath = _sanitizePath(path);
    Widget imageWidget;

    if (cleanPath.startsWith('http://') || cleanPath.startsWith('https://')) {
      imageWidget = Image.network(
        cleanPath,
        width: width,
        height: height,
        fit: fit,
        filterQuality: FilterQuality.high,
        isAntiAlias: true,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    } else {
      imageWidget = Image.asset(
        cleanPath.startsWith('assets/') ? cleanPath : 'assets/images/$cleanPath',
        width: width,
        height: height,
        fit: fit,
        filterQuality: FilterQuality.high,
        isAntiAlias: true,
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF7ECEE),
      child: const Center(
        child: Icon(Icons.checkroom_outlined, color: Color(0xFFF83758), size: 24),
      ),
    );
  }
}
