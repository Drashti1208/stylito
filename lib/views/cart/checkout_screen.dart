import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/routes/app_routes.dart';
import '../widgets/app_image.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Get.find<CartController>();
    final authProvider = Get.find<AuthController>();

    return Obx(() {
      final profile = authProvider.userProfile;

      return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address Header & Card
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: AppColors.textDark, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Delivery Address',
                  style: AppTextStyles.bodyBold.copyWith(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Address Card
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE5E5E5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Address :',
                              style: AppTextStyles.bodyBold.copyWith(fontSize: 12),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.profile);
                              },
                              child: const Icon(Icons.edit_note, size: 18, color: AppColors.textDark),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile.address.isNotEmpty
                              ? '${profile.address}, ${profile.city} ${profile.pincode}'
                              : 'No address added yet. Tap edit to enter your delivery address.',
                          style: AppTextStyles.caption.copyWith(
                            color: profile.address.isNotEmpty ? AppColors.textBody : AppColors.placeholder,
                            fontSize: 12,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile.phone.isNotEmpty
                              ? 'Contact : ${profile.phone}'
                              : (profile.email.isNotEmpty ? 'Email : ${profile.email}' : 'No contact saved'),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Plus Add Address Button
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.profile);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 48,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE5E5E5)),
                    ),
                    child: const Center(
                      child: Icon(Icons.add, color: AppColors.textDark, size: 24),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Shopping List Title
            Text(
              'Shopping List',
              style: AppTextStyles.bodyBold.copyWith(fontSize: 15),
            ),
            const SizedBox(height: 12),

            // Shopping items list
            if (cartProvider.items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text('Your bag is currently empty', style: AppTextStyles.subHeading),
                ),
              )
            else
              Column(
                children: List.generate(cartProvider.items.length, (index) {
                  final item = cartProvider.items[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: AppImage(
                                path: item.product.imageUrl,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.title,
                                    style: AppTextStyles.bodyBold.copyWith(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Variations: ${item.selectedColor}',
                                    style: AppTextStyles.caption.copyWith(fontSize: 11, color: AppColors.textMuted),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        '${item.product.rating}',
                                        style: AppTextStyles.caption.copyWith(fontSize: 11, color: AppColors.textDark),
                                      ),
                                      const SizedBox(width: 4),
                                      Row(
                                        children: List.generate(
                                          5,
                                          (i) => const Icon(Icons.star, color: AppColors.starRating, size: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        '\$${item.product.price.toInt()}.00',
                                        style: AppTextStyles.bodyBold.copyWith(fontSize: 14),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '\$${item.product.originalPrice.toInt()}.00',
                                        style: AppTextStyles.originalPrice.copyWith(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(color: AppColors.divider),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Order (${item.quantity}) :',
                              style: AppTextStyles.caption.copyWith(fontSize: 12, color: AppColors.textDark),
                            ),
                            Text(
                              '\$${item.totalPrice.toInt()}.00',
                              style: AppTextStyles.bodyBold.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.payment);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              'Proceed to Payment',
              style: AppTextStyles.button.copyWith(fontSize: 16),
            ),
          ),
        ),
      ),
    );
    });
  }
}
