import '../core/constants/api_constants.dart';
import '../models/product_model.dart';
import 'api_service.dart';

class ProductApiService {
  static Future<List<ProductModel>> fetchProducts({
    String? category,
    String? search,
  }) async {
    String url = ApiConstants.products;
    final queryParams = <String>[];
    if (category != null && category.isNotEmpty && category.toLowerCase() != 'all') {
      queryParams.add('category=${Uri.encodeComponent(category)}');
    }
    if (search != null && search.isNotEmpty) {
      queryParams.add('search=${Uri.encodeComponent(search)}');
    }
    if (queryParams.isNotEmpty) {
      url += '?${queryParams.join('&')}';
    }

    final response = await ApiService.get(url);
    if (response.success && response.data != null) {
      final list = response.data['data'] as List?;
      if (list != null) {
        return list
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    }
    // Fallback to sample data if offline
    return ProductModel.sampleProducts;
  }

  static Future<List<ProductModel>> fetchDeals() async {
    final response = await ApiService.get(ApiConstants.productDeals);
    if (response.success && response.data != null) {
      final list = response.data['data'] as List?;
      if (list != null && list.isNotEmpty) {
        return list
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    }
    return ProductModel.sampleProducts.where((p) => p.isDealOfTheDay).toList();
  }

  static Future<List<ProductModel>> fetchTrending() async {
    final response = await ApiService.get(ApiConstants.productTrending);
    if (response.success && response.data != null) {
      final list = response.data['data'] as List?;
      if (list != null && list.isNotEmpty) {
        return list
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    }
    return ProductModel.sampleProducts.where((p) => p.isTrending).toList();
  }
}
