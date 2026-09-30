import '../core/constants/api_constants.dart';
import '../models/cart_item_model.dart';
import '../models/user_profile_model.dart';
import 'api_service.dart';

class OrderApiService {
  static Future<ApiResponse<dynamic>> createOrder({
    required List<CartItemModel> items,
    required UserProfileModel userProfile,
    required double subtotal,
    required double discountAmount,
    required double deliveryFee,
    required double totalAmount,
    String paymentMethod = 'Online / Card',
  }) async {
    final payload = {
      'customer_name': userProfile.accountHolderName.isNotEmpty
          ? userProfile.accountHolderName
          : userProfile.email.split('@')[0],
      'customer_email': userProfile.email,
      'shipping_address': '${userProfile.address}, ${userProfile.city}, ${userProfile.state} - ${userProfile.pincode}',
      'subtotal': subtotal,
      'discount_amount': discountAmount,
      'delivery_fee': deliveryFee,
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
      'items': items.map((i) => {
        'product': {
          'id': i.product.id,
          'title': i.product.title,
          'price': i.product.price,
        },
        'selected_size': i.selectedSize,
        'selected_color': i.selectedColor,
        'quantity': i.quantity,
        'total_price': i.totalPrice,
      }).toList(),
    };

    return await ApiService.post(
      ApiConstants.orders,
      body: payload,
    );
  }
}
