import 'package:bhakharamart/core/utils/snackbar.dart';
import 'package:bhakharamart/data/app_exception.dart';
import 'package:bhakharamart/data/models/order_history_model.dart';
import 'package:bhakharamart/modules/orders/repo/order_repo.dart';
import 'package:bhakharamart/modules/cart/controller/cart_controller.dart';
import 'package:bhakharamart/modules/cart/repo/cart_repo.dart';
import 'package:bhakharamart/res/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final OrderRepo _orderRepo = OrderRepo();

  // Order history state
  final orders = <OrderHistoryModel>[].obs;
  final isLoadingOrders = false.obs;
  final orderCount = 0.obs;

  // Selected order detail state
  final isLoadingDetail = false.obs;
  final selectedOrder = Rxn<OrderDetailModel>();

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  /// Fetch all orders for the user
  Future<void> fetchOrders() async {
    isLoadingOrders.value = true;
    try {
      orders.assignAll(await _orderRepo.fetchOrderHistory());
      orderCount.value = orders.length;
    } catch (e) {
      orders.clear();
      orderCount.value = 0;
      _handleError(e, 'Unable to load orders');
    } finally {
      isLoadingOrders.value = false;
    }
  }

  /// Refresh order list
  Future<void> refreshOrders() async {
    await fetchOrders();
  }

  /// Fetch details for a specific order
  Future<OrderDetailModel?> fetchOrderDetail(int orderId) async {
    isLoadingDetail.value = true;
    try {
      final detail = await _orderRepo.fetchOrderDetail(orderId);
      selectedOrder.value = detail;
      return detail;
    } catch (e) {
      selectedOrder.value = null;
      _handleError(e, 'Unable to load order details');
      return null;
    } finally {
      isLoadingDetail.value = false;
    }
  }

  /// Reorder all items from a past order into active cart
  Future<void> reorderOrder(int orderId) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final detail = await _orderRepo.fetchOrderDetail(orderId);
      if (Get.isDialogOpen == true) Get.back();

      if (detail.items.isEmpty) {
        SnackBarUtils.showError('Unable to fetch items from this order');
        return;
      }

      final CartRepo cartRepo = CartRepo();
      int addedCount = 0;

      for (final item in detail.items) {
        final pid = int.tryParse(item.productId.toString()) ?? 0;
        final qty = int.tryParse(item.quantity.toString()) ?? 1;
        if (pid > 0) {
          try {
            await cartRepo.addToCart(pid, qty > 0 ? qty : 1);
            addedCount++;
          } catch (_) {
            // Continue adding remaining items
          }
        }
      }

      if (Get.isRegistered<CartController>()) {
        final cartController = Get.find<CartController>();
        await cartController.loadCart();
      }

      SnackBarUtils.showSuccess('Added $addedCount item(s) to your cart!');
      Get.toNamed(RoutesName.cart);
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      SnackBarUtils.showError('Failed to re-order: $e');
    }
  }

  /// Cancel an order with a reason
  Future<bool> cancelOrder(int orderId, String reason) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final success = await _orderRepo.cancelOrder(orderId, reason);
      if (Get.isDialogOpen == true) Get.back();

      if (success) {
        SnackBarUtils.showSuccess('Order #$orderId has been cancelled');
        await fetchOrderDetail(orderId);
        await fetchOrders();
        return true;
      }
      return false;
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      _handleError(e, 'Failed to cancel order');
      return false;
    }
  }

  /// Handle errors and show user-friendly messages
  void _handleError(dynamic error, String defaultMessage) {
    String errorMessage;

    if (error is ApiErrorException) {
      // API returned success: false
      errorMessage = error.errorMessage.isNotEmpty 
        ? error.errorMessage 
        : defaultMessage;
    } else if (error is BadRequestException) {
      errorMessage = 'Something went wrong. Please try again.';
    } else if (error is UnauthorizedException) {
      errorMessage = 'Session expired. Please login again.';
      // Will auto logout via NetworkApiServices
    } else if (error is ForbiddenException) {
      errorMessage = 'You don\'t have permission for this action.';
    } else if (error is NotFoundException) {
      errorMessage = 'The requested item was not found.';
    } else if (error is ServerException) {
      errorMessage = 'Server is temporarily unavailable. Please try later.';
    } else if (error is InternetErrorException) {
      errorMessage = 'No internet connection. Please check your network.';
    } else if (error is TimeoutException) {
      errorMessage = 'Request timed out. Please try again.';
    } else {
      // Unknown error
      errorMessage = defaultMessage;
    }

    // Show error snackbar (only if not already showing)
    if (Get.isSnackbarOpen != true) {
      SnackBarUtils.showError(errorMessage);
    }
  }

  /// Get color for delivery status
  Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'DELIVERED':
        return Colors.green;
      case 'SHIPPED':
        return Colors.blue;
      case 'OUT_FOR_DELIVERY':
        return Colors.orange;
      case 'PLACED':
        return Colors.teal;
      case 'CANCELLED':
        return Colors.red;
      case 'RETURNED':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  /// Get status display text
  String getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'PLACED':
        return 'Order Placed';
      case 'PROCESSING':
        return 'Processing';
      case 'SHIPPED':
        return 'Shipped';
      case 'OUT_FOR_DELIVERY':
        return 'Out for Delivery';
      case 'DELIVERED':
        return 'Delivered';
      case 'CANCELLED':
        return 'Cancelled';
      case 'RETURNED':
        return 'Returned';
      default:
        return status;
    }
  }
}

