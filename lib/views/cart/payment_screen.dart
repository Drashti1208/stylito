import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import 'widgets/payment_success_dialog.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0;

  final List<PaymentMethodData> _methods = [
    PaymentMethodData(
      name: 'VISA',
      cardNumber: '*********2109',
      icon: Icons.credit_card,
      accentColor: const Color(0xFF1A1F71),
    ),
    PaymentMethodData(
      name: 'PayPal',
      cardNumber: '*********2109',
      icon: Icons.account_balance_wallet,
      accentColor: const Color(0xFF003087),
    ),
    PaymentMethodData(
      name: 'Maestro',
      cardNumber: '*********2109',
      icon: Icons.credit_card_outlined,
      accentColor: const Color(0xFFEB001B),
    ),
    PaymentMethodData(
      name: 'Apple Pay',
      cardNumber: '*********2109',
      icon: Icons.apple,
      accentColor: Colors.black,
    ),
  ];

  void _processPayment() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PaymentSuccessDialog(),
    );
    Get.find<CartController>().clearCart();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Get.find<CartController>();

    return Obx(() {
      final orderAmount = cartProvider.subtotal > 0 ? cartProvider.subtotal : 7000.00;
      const shippingAmount = 30.00;
      final totalAmount = orderAmount + shippingAmount;

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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cost summary table
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFEEEEEE)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
                      Text('₹ ${orderAmount.toInt()}', style: AppTextStyles.bodyBold),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Shipping', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
                      Text('₹ ${shippingAmount.toInt()}', style: AppTextStyles.bodyBold),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: AppColors.divider),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: AppTextStyles.bodyBold.copyWith(fontSize: 16)),
                      Text(
                        '₹ ${totalAmount.toInt()}',
                        style: AppTextStyles.bodyBold.copyWith(
                          fontSize: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Payment Title
            Text('Payment', style: AppTextStyles.heading3.copyWith(fontSize: 18)),
            const SizedBox(height: 16),

            // Payment methods
            Column(
              children: List.generate(_methods.length, (index) {
                final method = _methods[index];
                final isSelected = index == _selectedMethod;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMethod = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFDF7F8) : const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : const Color(0xFFE4E4E4),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: const Color(0xFFDDDDDD)),
                              ),
                              child: Text(
                                method.name,
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: method.accentColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              method.cardNumber,
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark),
                            ),
                          ],
                        ),
                        Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: isSelected ? AppColors.primary : AppColors.textLight,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 36),

            // Continue Button
            ElevatedButton(
              onPressed: _processPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                'Continue',
                style: AppTextStyles.button.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    });
  }
}

class PaymentMethodData {
  final String name;
  final String cardNumber;
  final IconData icon;
  final Color accentColor;

  PaymentMethodData({
    required this.name,
    required this.cardNumber,
    required this.icon,
    required this.accentColor,
  });
}
