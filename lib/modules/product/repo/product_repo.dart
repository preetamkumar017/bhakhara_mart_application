import '../../../data/network/network_api_services.dart';
import '../../../data/network/api_endpoints.dart';
import '../../../data/models/product_model.dart';
import '../widgets/product_filter_bottom_sheet.dart';

class ProductRepo {
  final _api = NetworkApiServices();

  Future<List<ProductModel>> getProducts(
    String categoryId, {
    ProductFilterOptions? filters,
    int page = 1,
    int limit = 20,
  }) async {
    String url = '${ApiEndpoints.categoryProducts(int.parse(categoryId))}?page=$page&limit=$limit';
    
    if (filters != null) {
      url += '&sort_by=${filters.sortBy}';
      if (filters.inStockOnly) url += '&in_stock=1';
      if (filters.minPrice != null) url += '&min_price=${filters.minPrice}';
      if (filters.maxPrice != null) url += '&max_price=${filters.maxPrice}';
    }

    final response = await _api.getApi(url);

    if (response['status'] != true) {
      throw Exception('Failed to load products');
    }

    final List list = response['data'] ?? [];
    return list.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<List<ProductModel>> getAllProducts({
    ProductFilterOptions? filters,
    int page = 1,
    int limit = 20,
  }) async {
    String url = '${ApiEndpoints.products}?page=$page&limit=$limit';
    
    if (filters != null) {
      url += '&sort_by=${filters.sortBy}';
      if (filters.inStockOnly) url += '&in_stock=1';
      if (filters.minPrice != null) url += '&min_price=${filters.minPrice}';
      if (filters.maxPrice != null) url += '&max_price=${filters.maxPrice}';
    }

    final response = await _api.getApi(url);

    if (response['status'] != true) {
      throw Exception('Failed to load products');
    }

    final List list = response['data'] ?? [];
    return list.map((e) => ProductModel.fromJson(e)).toList();
  }

  /// Search products with filters and pagination
  Future<List<ProductModel>> searchProducts(
    String query, {
    ProductFilterOptions? filters,
    int page = 1,
    int limit = 20,
  }) async {
    String url = ApiEndpoints.productsSearch(query, page, limit);

    if (filters != null) {
      url += '&sort_by=${filters.sortBy}';
      if (filters.inStockOnly) url += '&in_stock=1';
      if (filters.minPrice != null) url += '&min_price=${filters.minPrice}';
      if (filters.maxPrice != null) url += '&max_price=${filters.maxPrice}';
    }

    final response = await _api.getApi(url);

    if (response['status'] != true) {
      throw Exception('Failed to search products');
    }

    final List list = response['data'] ?? [];
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

    final List list = response['data'] ?? [];
    return list.map((e) => {
      'id': e['id'].toString(),
      'product_name': e['product_name'] ?? '',
    }).toList();
  }
}
