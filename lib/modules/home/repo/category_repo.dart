import '../../../data/network/network_api_services.dart';
import '../../../data/network/api_endpoints.dart';
import '../../../data/models/category_model.dart';

class CategoryRepo {
  final _apiService = NetworkApiServices();

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await _apiService.getApi(ApiEndpoints.categories);

    if (response['status'] != true) {
      throw Exception('Failed to load categories');
    }

    final List list = response['data'];
    return list.map((e) => CategoryModel.fromJson(e)).toList();
  }
}
