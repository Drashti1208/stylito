import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  String selectedSize;
  String selectedColor;
  int quantity;

  CartItemModel({
    required this.product,
    this.selectedSize = '42',
    this.selectedColor = 'Black',
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}
