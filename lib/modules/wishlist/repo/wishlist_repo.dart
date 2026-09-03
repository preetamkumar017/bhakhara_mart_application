import 'package:flutter/foundation.dart';
import '../../../data/models/product_model.dart';
import '../../../data/network/api_endpoints.dart';
import '../../../data/network/network_api_services.dart';

class WishlistRepo {
  final _api = NetworkApiServices();

  /// Fetch all wishlist items
  Future<List<ProductModel>> fetchWishlist() async {
    try {
      final res = await _api.getApi(ApiEndpoints.wishlist);
      if (res['status'] == true && res['data'] != null) {
        final List list = res['data'];
        return list.map((e) => ProductModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      if (kDebugMode) debugPrint('[WishlistRepo] error: $e');
      return [];
    }
  }

  /// Toggle product in wishlist
  Future<bool> toggleWishlist(int productId) async {
    try {
      final res = await _api.postApi(
        ApiEndpoints.wishlistToggle,
        {'product_id': productId},
      );
      if (res['status'] == true && res['data'] != null) {
        return res['data']['is_favorite'] == true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) debugPrint('[WishlistRepo::toggle] error: $e');
      rethrow;
    }
  }

  /// Restock Notify Me
  Future<bool> notifyMe(int productId) async {
    try {
      final res = await _api.postApi(
        ApiEndpoints.productNotifyMe,
        {'product_id': productId},
      );
      return res['status'] == true;
    } catch (e) {
      if (kDebugMode) debugPrint('[WishlistRepo::notifyMe] error: $e');
      rethrow;
    }
  }
}
