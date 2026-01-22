import 'package:bhakharamart/core/utils/snackbar.dart';
import 'package:bhakharamart/data/app_exception.dart';
import 'package:bhakharamart/data/models/address_model.dart';
import 'package:bhakharamart/data/models/order_model.dart';
import 'package:bhakharamart/modules/cart/controller/cart_controller.dart';
import 'package:bhakharamart/modules/profile/repo/address_repo.dart';
import 'package:bhakharamart/modules/orders/repo/order_repo.dart';
import 'package:bhakharamart/res/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  final AddressRepo _addressRepo = AddressRepo();
  final OrderRepo _orderRepo = OrderRepo();

  // Address state
  final addresses = <AddressModel>[].obs;
  final isLoadingAddresses = false.obs;
  
  // Selected address
  final selectedAddressId = 0.obs;
  final selectedAddress = Rx<AddressModel?>(null);
  
  final landmarkController = TextEditingController();

  // Loading and order state
  final isPlacingOrder = false.obs;
  final placedOrder = Rx<OrderModel?>(null);
  final lastErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  /// Load addresses from API
  Future<void> loadAddresses() async {
    isLoadingAddresses.value = true;
    try {
      addresses.assignAll(await _addressRepo.fetchAddresses());
      
      // Select default address or first address
      if (addresses.isNotEmpty) {
        final defaultAddress = addresses.firstWhere(
          (addr) => addr.isDefaultAddress,
          orElse: () => addresses.first,
        );
        selectAddress(defaultAddress);
      }
    } catch (e) {
      SnackBarUtils.showError('Failed to load addresses: ${e.toString()}');
    } finally {
      isLoadingAddresses.value = false;
    }
  }

  void selectAddress(AddressModel address) {
    selectedAddressId.value = int.parse(address.id);
    selectedAddress.value = address;
    // Clear error message when address changes
    lastErrorMessage.value = '';
  }

  /// Place an order with the selected address
  /// 
  /// Returns [OrderModel] if successful, null if cart is empty or error
  Future<OrderModel?> placeOrder() async {
    // Clear previous error
    lastErrorMessage.value = '';

    // Validate cart has items
    final cartController = Get.find<CartController>();
    if (cartController.items.isEmpty) {
      final errorMsg = 'Your cart is empty. Please add items before placing an order.';
      lastErrorMessage.value = errorMsg;
      SnackBarUtils.showError(errorMsg);
      return null;
    }

    // Validate address is selected
    if (selectedAddressId.value == 0) {
      final errorMsg = 'Please select a delivery address.';
      lastErrorMessage.value = errorMsg;
      SnackBarUtils.showError(errorMsg);
      return null;
    }

    isPlacingOrder.value = true;

    try {
      final order = await _orderRepo.placeOrder(selectedAddressId.value);
      
      if (order.isSuccess) {
        placedOrder.value = order;
        lastErrorMessage.value = '';
        
        SnackBarUtils.showSuccess(
          'Order placed successfully!\nOrder No: ${order.orderNo}\nAmount: ₹${order.totalAmount.toStringAsFixed(2)}',
        );
        
        // Clear the cart after successful order and navigate to home
        cartController.items.clear();
        cartController.update();
        
        // Navigate to home page after a short delay to show the success message
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed(RoutesName.home);
        });
        
        return order;
      } else {
        final errorMsg = order.message ?? 'Failed to place order. Please try again.';
        lastErrorMessage.value = errorMsg;
        SnackBarUtils.showError(errorMsg);
        return null;
      }
    } catch (e) {
      String errorMsg;
      
      if (e is ApiErrorException) {
        // Handle API error with message from response
        errorMsg = e.errorMessage;
      } else if (e is BadRequestException) {
        errorMsg = 'Invalid request. Please check your inputs.';
      } else if (e is ForbiddenException) {
        errorMsg = 'Access denied. Please try again.';
      } else if (e is UnauthorizedException) {
        errorMsg = 'Session expired. Please login again.';
      } else {
        errorMsg = 'Failed to place order: ${e.toString()}';
      }
      
      lastErrorMessage.value = errorMsg;
      SnackBarUtils.showError(errorMsg);
      return null;
    } finally {
      isPlacingOrder.value = false;
    }
  }

  /// Get the total cart amount from CartController
  double get totalAmount {
    try {
      final cartController = Get.find<CartController>();
      return cartController.totalAmount;
    } catch (e) {
      return 0.0;
    }
  }

  /// Get total items in cart
  int get totalItems {
    try {
      final cartController = Get.find<CartController>();
      return cartController.totalItems;
    } catch (e) {
      return 0;
    }
  }

  /// Check if addresses are loaded
  bool get hasAddresses => addresses.isNotEmpty;

  /// Refresh addresses
  Future<void> refreshAddresses() async {
    await loadAddresses();
  }

  /// Add a new address
  /// 
  /// Returns true if successful
  Future<bool> addAddress({
    required String addressLine1,
    required String addressLine2,
    required String city,
    required String state,
    required String pincode,
  }) async {
    try {
      await _addressRepo.addAddress(
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        city: city,
        state: state,
        pincode: pincode,
      );
      
      // Refresh addresses list after adding
      await loadAddresses();
      
      return true;
    } catch (e) {
      // Re-throw without showing snackbar (let the UI handle the display)
      rethrow;
    }
  }

  /// Delete an address
  Future<void> deleteAddress(AddressModel address) async {
    try {
      final success = await _addressRepo.deleteAddress(int.parse(address.id));
      
      if (success) {
        addresses.remove(address);
        
        // If deleted address was selected, select another one
        if (selectedAddressId.value == int.parse(address.id)) {
          if (addresses.isNotEmpty) {
            selectAddress(addresses.first);
          } else {
            selectedAddressId.value = 0;
            selectedAddress.value = null;
          }
        }
        
        SnackBarUtils.showSuccess('Address deleted');
      }
    } catch (e) {
      SnackBarUtils.showError('Failed to delete address: ${e.toString()}');
      rethrow;
    }
  }

  /// Set address as default
  Future<void> setDefaultAddress(AddressModel address) async {
    try {
      final success = await _addressRepo.setDefaultAddress(int.parse(address.id));
      
      if (success) {
        // Update isDefault status for all addresses
        for (var addr in addresses) {
          addr.isDefault = (addr.id == address.id) ? '1' : '0';
        }
        addresses.refresh();
        
        SnackBarUtils.showSuccess('Default address updated');
      }
    } catch (e) {
      SnackBarUtils.showError('Failed to set default address: ${e.toString()}');
      rethrow;
    }
  }

  @override
  void onClose() {
    landmarkController.dispose();
    super.onClose();
  }
}

