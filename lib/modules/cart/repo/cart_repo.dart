import '../../../data/network/network_api_services.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/network/api_endpoints.dart';

class CartRepo {
  final _api = NetworkApiServices();

  Future<List<CartItemModel>> fetchCart() async {
    final res = await _api.getApi(ApiEndpoints.cart);
    final List list = res['data'];
    return list.map((e) => CartItemModel.fromJson(e)).toList();
  }

  Future<void> addToCart(int productId, int qty) async {
    await _api.postApi(
      ApiEndpoints.cartAdd,
      {'product_id': productId, 'quantity': qty},
    );
  }

  Future<void> updateCart(int productId, int qty) async {
    await _api.postApi(
      ApiEndpoints.cartUpdate,
      {'product_id': productId, 'quantity': qty},
    );
  }

  Future<void> removeFromCart(int productId) async {
    await _api.postApi(
      ApiEndpoints.cartRemove,
      {'product_id': productId},
    );
  }
}
