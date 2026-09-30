import 'package:get/get.dart';
import 'auth_controller.dart';
import 'cart_controller.dart';
import 'wishlist_controller.dart';
import 'product_controller.dart';
import 'navigation_controller.dart';
import 'inquiry_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<CartController>(CartController(), permanent: true);
    Get.put<WishlistController>(WishlistController(), permanent: true);
    Get.put<ProductController>(ProductController(), permanent: true);
    Get.put<NavigationController>(NavigationController(), permanent: true);
    Get.put<InquiryController>(InquiryController(), permanent: true);
  }
}
