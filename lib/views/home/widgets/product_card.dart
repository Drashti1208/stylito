import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../../controllers/wishlist_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../models/product_model.dart';
import '../../product_details/product_details_screen.dart';
import '../../widgets/app_image.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final double? width;

  const ProductCard({
    super.key,
    required this.product,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.find<WishlistController>();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Wishlist Button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: AspectRatio(
                    aspectRatio: 1.15,
                    child: AppImage(
                      path: product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      wishlistController.toggleWishlist(product);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Obx(() {
                        final isFav = wishlistController.isWishlisted(product.id);
                        return Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? AppColors.primary : AppColors.textDark,
                          size: 16,
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyBold.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textBody,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Price row
                  Row(
                    children: [
                      Text(
                        '₹${product.price.toInt()}',
                        style: AppTextStyles.price.copyWith(fontSize: 13),
                      ),
                      const SizedBox(width: 6),
                      if (product.originalPrice > product.price) ...[
                        Text(
                          '₹${product.originalPrice.toInt()}',
                          style: AppTextStyles.originalPrice.copyWith(fontSize: 11),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${product.discountPercent}% Off',
                          style: AppTextStyles.discount.copyWith(fontSize: 11),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Ratings
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < product.rating.floor()
                                ? Icons.star
                                : (index < product.rating ? Icons.star_half : Icons.star_border),
                            color: AppColors.starRating,
                            size: 13,
                          );
                        }),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        NumberFormat.decimalPattern('en_IN').format(product.reviewCount),
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
