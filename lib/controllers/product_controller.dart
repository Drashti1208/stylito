import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/product_api_service.dart';

class ProductController extends GetxController {
  final RxList<ProductModel> allProducts = <ProductModel>[].obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 1. Load initial data immediately for zero blank screen latency
    allProducts.assignAll(ProductModel.sampleProducts);
    // 2. Fetch fresh real-time products from the REST API
    refreshProductsFromApi();
  }

  Future<void> refreshProductsFromApi() async {
    isLoading.value = true;
    try {
      final remoteProducts = await ProductApiService.fetchProducts();
      if (remoteProducts.isNotEmpty) {
        allProducts.assignAll(remoteProducts);
      }
    } catch (_) {
      // Keep offline sample products if backend is not started
    } finally {
      isLoading.value = false;
    }
  }

  List<ProductModel> get dealOfTheDayProducts =>
      allProducts.where((p) => p.isDealOfTheDay).toList();

  List<ProductModel> get trendingProducts =>
      allProducts.where((p) => p.isTrending).toList();

  List<ProductModel> get newArrivalProducts =>
      allProducts.where((p) => p.isNewArrival).toList();

  List<ProductModel> getProductsByCategory(String category) {
    if (category.toLowerCase() == 'all') {
      return allProducts;
    }
    return allProducts
        .where((p) => p.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }
}
