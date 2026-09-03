import 'package:bhakharamart/data/models/order_history_model.dart';
import 'package:bhakharamart/data/models/order_model.dart';
import 'package:bhakharamart/data/network/api_endpoints.dart';
import 'package:bhakharamart/data/network/network_api_services.dart';

class OrderRepo {
  final _api = NetworkApiServices();

  /// Place an order with the given address ID and optional coupon/instructions/slot
  Future<OrderModel> placeOrder(
    int addressId, {
    String? couponCode,
    String? deliveryInstructions,
    String? deliverySlot,
  }) async {
    try {
      final payload = <String, dynamic>{
        'address_id': addressId,
      };

      if (couponCode != null && couponCode.trim().isNotEmpty) {
        payload['coupon_code'] = couponCode.trim().toUpperCase();
      }

      if (deliveryInstructions != null && deliveryInstructions.trim().isNotEmpty) {
        payload['delivery_instructions'] = deliveryInstructions.trim();
      }

      if (deliverySlot != null && deliverySlot.trim().isNotEmpty) {
        payload['delivery_slot'] = deliverySlot.trim();
      }

      final response = await _api.postApi(
        ApiEndpoints.orderPlace,
        payload,
      );

      final orderModel = OrderModel.fromJson(response);

      if (orderModel.isSuccess) {
        return orderModel;
      } else {
        return OrderModel.error(orderModel.message ?? 'Order placement failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch order history (list of all orders)
  Future<List<OrderHistoryModel>> fetchOrderHistory() async {
    try {
      final response = await _api.getApi(ApiEndpoints.orders);

      if (response['status'] == true && response['data'] != null) {
        final List<dynamic> dataList = response['data'];
        return dataList
            .map((item) => OrderHistoryModel.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch order details for a specific order
  Future<OrderDetailModel> fetchOrderDetail(int orderId) async {
    try {
      final response = await _api.getApi(ApiEndpoints.orderDetail(orderId));

      if (response['status'] == true) {
        final orderData = response['order'] as Map<String, dynamic>;
        final itemsList = <OrderItemModel>[];
        
        if (response['items'] != null) {
          itemsList.addAll(
            List<Map<String, dynamic>>.from(response['items'])
                .map((item) => OrderItemModel.fromJson(item))
                .toList()
          );
        }
        
        orderData['items'] = itemsList.map((item) => item.toJson()).toList();
        final timeline = response['timeline'] as List<dynamic>?;
        
        return OrderDetailModel.fromJson(orderData, timelineList: timeline);
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch order details');
      }
    } catch (e) {
      rethrow;
    }
  }
}
