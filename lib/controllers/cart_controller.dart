import 'package:get/get.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> items = <CartItemModel>[].obs;
  final RxnString _appliedCoupon = RxnString();
  final RxDouble _discountPercent = 0.0.obs;
  final RxDouble _deliveryFee = 0.0.obs; // Free delivery as per Figma

  @override
  void onInit() {
    super.onInit();
    _initDefaultItems();
  }

  void _initDefaultItems() {
    final samples = ProductModel.sampleProducts;
    final item1 = samples.firstWhere((p) => p.id == 'womens_casual_wear', orElse: () => samples[0]);
    final item2 = samples.firstWhere((p) => p.id == 'mens_jacket', orElse: () => samples[1]);

    items.addAll([
      CartItemModel(product: item1, selectedSize: '42', selectedColor: 'Black', quantity: 1),
      CartItemModel(product: item2, selectedSize: 'M', selectedColor: 'Green', quantity: 1),
    ]);
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  String? get appliedCoupon => _appliedCoupon.value;

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get discountAmount => subtotal * (_discountPercent.value / 100);

  double get deliveryFee => _deliveryFee.value;

  double get total => (subtotal - discountAmount + deliveryFee).clamp(0.0, double.infinity);

  void addItem(ProductModel product, {String size = '42', String color = 'Black'}) {
    final index = items.indexWhere((item) => item.product.id == product.id && item.selectedSize == size);
    if (index >= 0) {
      items[index].quantity += 1;
      items.refresh();
    } else {
      items.add(CartItemModel(product: product, selectedSize: size, selectedColor: color, quantity: 1));
    }
  }

  void updateQuantity(int index, int quantity) {
    if (index >= 0 && index < items.length) {
      if (quantity <= 0) {
        items.removeAt(index);
      } else {
        items[index].quantity = quantity;
        items.refresh();
      }
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
    }
  }

  void updateSize(int index, String size) {
    if (index >= 0 && index < items.length) {
      items[index].selectedSize = size;
      items.refresh();
    }
  }

  bool applyCoupon(String code) {
    final upper = code.trim().toUpperCase();
    if (upper == 'STYLISH50') {
      _appliedCoupon.value = code;
      _discountPercent.value = 50.0;
      return true;
    } else if (upper == 'STYLISH20') {
      _appliedCoupon.value = code;
      _discountPercent.value = 20.0;
      return true;
    }
    return false;
  }

  void removeCoupon() {
    _appliedCoupon.value = null;
    _discountPercent.value = 0.0;
  }

  void clearCart() {
    items.clear();
    _appliedCoupon.value = null;
    _discountPercent.value = 0.0;
  }
}
