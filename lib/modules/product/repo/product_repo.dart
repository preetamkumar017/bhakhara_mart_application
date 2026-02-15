import '../../../data/network/network_api_services.dart';
import '../../../data/network/api_endpoints.dart';
import '../../../data/models/product_model.dart';

class ProductRepo {
  final _api = NetworkApiServices();

  Future<List<ProductModel>> getProducts(String categoryId) async {
    final response =
        await _api.getApi(ApiEndpoints.productsByCategory(categoryId));

    if (response['status'] != true) {
      throw Exception('Failed to load products');
    }

    final List list = response['data'];
    return list.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<List<ProductModel>> getAllProducts() async {
    final response = await _api.getApi(ApiEndpoints.products);

    if (response['status'] != true) {
      throw Exception('Failed to load products');
    }

    final List list = response['data'];
    return list.map((e) => ProductModel.fromJson(e)).toList();
  }

  /// Search products with pagination
  Future<List<ProductModel>> searchProducts(String query, {int page = 1, int limit = 20}) async {
    final response = await _api.getApi(
      ApiEndpoints.productsSearch(query, page, limit),
    );

    if (response['status'] != true) {
      throw Exception('Failed to search products');
    }

    final List list = response['data'];
    return list.map((e) => ProductModel.fromJson(e)).toList();
  }

  /// Get product suggestions for autocomplete
  Future<List<Map<String, dynamic>>> getProductSuggestions(String query) async {
    final response = await _api.getApi(
      '${ApiEndpoints.productsSuggest}?q=$query',
    );

    if (response['status'] != true) {
      throw Exception('Failed to get suggestions');
    }

    final List list = response['data'];
    return list.map((e) => {
      'id': e['id'].toString(),
      'product_name': e['product_name'] ?? '',
    }).toList();
  }
}

