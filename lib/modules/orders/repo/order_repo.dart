import 'package:bhakharamart/data/models/order_history_model.dart';
import 'package:bhakharamart/data/models/order_model.dart';
import 'package:bhakharamart/data/network/api_endpoints.dart';
import 'package:bhakharamart/data/network/network_api_services.dart';

class OrderRepo {
  final _api = NetworkApiServices();

  /// Place an order with the given address ID
  /// 
  /// [addressId] - The ID of the delivery address
  /// 
  /// Returns [OrderModel] with order details on success
  /// Throws exception on API error
  Future<OrderModel> placeOrder(int addressId) async {
    try {
      final response = await _api.postApi(
        ApiEndpoints.orderPlace,
        {'address_id': addressId},
      );

      final orderModel = OrderModel.fromJson(response);

      if (orderModel.isSuccess) {
        return orderModel;
      } else {
        // Return order model with error message for non-success responses
        return OrderModel.error(orderModel.message ?? 'Order placement failed');
      }
    } catch (e) {
      // Re-throw the exception to be handled by the controller
      rethrow;
    }
  }

  /// Fetch order history (list of all orders)
  /// 
  /// Returns [List<OrderHistoryModel>] on success
  /// Throws exception on API error
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
  /// 
  /// [orderId] - The ID of the order to fetch
  /// 
  /// Returns [OrderDetailModel] on success
  /// Throws exception on API error
  Future<OrderDetailModel> fetchOrderDetail(int orderId) async {
    try {
      final response = await _api.getApi(ApiEndpoints.orderDetail(orderId));

      if (response['status'] == true) {
        // Create order detail from 'order' object and 'items' from top level
        final orderData = response['order'] as Map<String, dynamic>;
        final itemsList = <OrderItemModel>[];
        
        if (response['items'] != null) {
          itemsList.addAll(
            List<Map<String, dynamic>>.from(response['items'])
                .map((item) => OrderItemModel.fromJson(item))
                .toList()
          );
        }
        
        // Add items to the order data for parsing
        orderData['items'] = itemsList.map((item) => item.toJson()).toList();
        
        return OrderDetailModel.fromJson(orderData);
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch order details');
      }
    } catch (e) {
      rethrow;
    }
  }
}

