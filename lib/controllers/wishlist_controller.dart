import 'package:get/get.dart';
import '../models/product_model.dart';

class WishlistController extends GetxController {
  final RxList<ProductModel> items = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Default initial items
    final samples = ProductModel.sampleProducts;
    if (samples.length >= 2) {
      items.addAll([samples[0], samples[1]]);
    }
  }

  bool isWishlisted(String productId) {
    return items.any((item) => item.id == productId);
  }

  void toggleWishlist(ProductModel product) {
    final index = items.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      items.removeAt(index);
    } else {
      items.add(product);
    }
  }

  void removeItem(String productId) {
    items.removeWhere((item) => item.id == productId);
  }
}
