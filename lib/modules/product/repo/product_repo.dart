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
}
