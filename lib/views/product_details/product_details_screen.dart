import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_routes.dart';
import '../../models/product_model.dart';
import '../home/widgets/product_card.dart';
import '../widgets/app_image.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final PageController _imageController = PageController();
  int _currentImageIndex = 0;
  late String _selectedSize;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.product.sizes.isNotEmpty ? widget.product.sizes[1] : '7 UK';
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Get.find<CartController>();
    final similarProducts = ProductModel.sampleProducts
        .where((p) => p.id != widget.product.id)
        .take(4)
        .toList();

    final images = widget.product.galleryImages.isNotEmpty
        ? widget.product.galleryImages
        : [widget.product.imageUrl, widget.product.imageUrl];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, size: 24),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.cart);
                },
              ),
              Obx(() {
                if (cartProvider.itemCount <= 0) return const SizedBox.shrink();
                return Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cartProvider.itemCount}',
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
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            SizedBox(
              height: 250,
              child: PageView.builder(
                controller: _imageController,
                itemCount: images.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AppImage(
                        path: images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            // Carousel dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                final isActive = index == _currentImageIndex;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : const Color(0xFFDADBDB),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 18),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Size Label & Selector
                  Text(
                    'Size: $_selectedSize',
                    style: AppTextStyles.bodyBold.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.product.sizes.map((size) {
                      final isSelected = size == _selectedSize;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSize = size;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryLight : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.border,
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            size,
                            style: AppTextStyles.bodyBold.copyWith(
                              fontSize: 13,
                              color: isSelected ? AppColors.primary : AppColors.textDark,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),

                  // Title & Subtitle
                  Text(
                    widget.product.title,
                    style: AppTextStyles.heading3.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.product.subtitle,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 13,
                      color: AppColors.textBody,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Ratings
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < widget.product.rating.floor()
                                ? Icons.star
                                : (index < widget.product.rating ? Icons.star_half : Icons.star_border),
                            color: AppColors.starRating,
                            size: 16,
                          );
                        }),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.product.reviewCount}',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Price
                  Row(
                    children: [
                      Text(
                        '₹${widget.product.price.toInt()}',
                        style: AppTextStyles.heading2.copyWith(
                          fontSize: 18,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '₹${widget.product.originalPrice.toInt()}',
                        style: AppTextStyles.originalPrice.copyWith(fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.product.discountPercent}% Off',
                        style: AppTextStyles.discount.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Product Details section
                  Text(
                    'Product Details',
                    style: AppTextStyles.bodyBold.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.product.description,
                    maxLines: _isExpanded ? 100 : 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 13,
                      height: 1.4,
                      color: AppColors.textMuted,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(
                      _isExpanded ? 'Show less' : '...More',
                      style: AppTextStyles.bodyBold.copyWith(
                        color: AppColors.primary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Dual Action Buttons: Go to Cart & Buy Now
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            cartProvider.addItem(widget.product, size: _selectedSize);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${widget.product.title} added to cart!'),
                                duration: const Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'VIEW CART',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.pushNamed(context, AppRoutes.cart);
                                  },
                                ),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                          },
                          icon: const Icon(Icons.shopping_cart_outlined, size: 18, color: Color(0xFF3F80FF)),
                          label: Text(
                            'Go to cart',
                            style: GoogleFonts.montserrat(
                              color: const Color(0xFF3F80FF),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF3F80FF), width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            cartProvider.addItem(widget.product, size: _selectedSize);
                            Navigator.pushNamed(context, AppRoutes.cart);
                          },
                          icon: const Icon(Icons.touch_app_outlined, size: 18, color: Colors.white),
                          label: Text(
                            'Buy Now',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Delivery Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFECEF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery in',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textDark,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          '1 within Hour',
                          style: AppTextStyles.bodyBold.copyWith(
                            color: AppColors.textDark,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // View Similar / Add to Compare
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.remove_red_eye_outlined, size: 16, color: AppColors.textDark),
                          label: Text(
                            'View Similar',
                            style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: AppColors.textDark),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {

                          },
                          icon: const Icon(Icons.compare_arrows, size: 16, color: AppColors.textDark),
                          label: Text(
                            'Add to Compare',
                            style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: AppColors.textDark),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Similar To 282+ Items Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Similar To 282+ Items',
                        style: AppTextStyles.bodyBold.copyWith(fontSize: 16),
                      ),
                      Row(
                        children: [
                          _filterPill('Sort', Icons.swap_vert),
                          const SizedBox(width: 8),
                          _filterPill('Filter', Icons.filter_alt_outlined),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Similar products grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: similarProducts.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: similarProducts[index]);
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterPill(String title, IconData icon) {
    return Container(
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
    );
  }
}
