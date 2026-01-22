import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/themes/app_colors.dart';
import '../../../data/models/address_model.dart';
import '../../../res/components/custom_button.dart';
import '../../../res/components/custom_textfield.dart';
import '../controller/checkout_controller.dart';

class CheckoutView extends StatelessWidget {
  CheckoutView({super.key});

  final CheckoutController controller = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        actions: [
          if (controller.hasAddresses)
            IconButton(
              onPressed: () => Get.to(() => AddressManagementView()),
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Manage Addresses',
            ),
        ],
      ),
      body: Obx(() {
        // Show loading indicator while fetching addresses
        if (controller.isLoadingAddresses.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Address Section
                    Text(
                      'Delivery address',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    
                    // Address Dropdown or Add Address
                    if (controller.hasAddresses)
                      _buildAddressDropdown(context)
                    else
                      _buildNoAddressView(context),

                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: controller.landmarkController,
                      hintText: 'Landmark (optional)',
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Show cart summary
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order Summary', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Items:'),
                                Text('${controller.totalItems}'),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total Amount:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('₹${controller.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Show error message if any
                    Obx(() {
                      if (controller.lastErrorMessage.isNotEmpty) {
                        return Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  controller.lastErrorMessage.value,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),
            
            // Place Order Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Obx(() {
                  return CustomButton(
                    label: controller.isPlacingOrder.value 
                      ? 'Placing Order...' 
                      : 'Place COD Order • ₹${controller.totalAmount.toStringAsFixed(2)}',
                    onPressed: controller.isPlacingOrder.value || !controller.hasAddresses
                      ? null 
                      : controller.placeOrder,
                  );
                }),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAddressDropdown(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField<AddressModel>(
        value: controller.selectedAddress.value,
        items: controller.addresses.map((address) {
          return DropdownMenuItem<AddressModel>(
            value: address,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    address.shortAddress,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  // if (address.isDefaultAddress)
                  //   Text(
                  //     'Default',
                  //     style: TextStyle(
                  //       fontSize: 11,
                  //       color: Theme.of(context).primaryColor,
                  //     ),
                  //   ),
                ],
              ),
            ),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) {
            controller.selectAddress(val);
          }
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }

  Widget _buildNoAddressView(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.9,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'No addresses found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Please add a delivery address to continue',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showAddAddressDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Address'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    final addressLine1Controller = TextEditingController();
    final addressLine2Controller = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final pincodeController = TextEditingController();
    
    final formKey = GlobalKey<FormState>();
    final isSaving = false.obs;

    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add New Address',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Address Line 1
                CustomTextField(
                  controller: addressLine1Controller,
                  hintText: 'Address Line 1 *',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                
                // Address Line 2
                CustomTextField(
                  controller: addressLine2Controller,
                  hintText: 'Address Line 2 (optional)',
                ),
                const SizedBox(height: 12),
                
                // City
                CustomTextField(
                  controller: cityController,
                  hintText: 'City *',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                
                // State
                CustomTextField(
                  controller: stateController,
                  hintText: 'State *',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                
                // Pincode
                CustomTextField(
                  controller: pincodeController,
                  hintText: 'Pincode *',
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // Submit Button
                Obx(() {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSaving.value
                        ? null
                        : () async {
                            if (formKey.currentState!.validate()) {
                              isSaving.value = true;
                              try {
                                await controller.addAddress(
                                  addressLine1: addressLine1Controller.text.trim(),
                                  addressLine2: addressLine2Controller.text.trim(),
                                  city: cityController.text.trim(),
                                  state: stateController.text.trim(),
                                  pincode: pincodeController.text.trim(),
                                );
                                
                                // Close dialog on success
                                Get.back();
                                
                                // Show success message
                                Get.snackbar(
                                  'Success',
                                  'Address added successfully',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: AppColors.success,
                                  colorText: Colors.white,
                                );
                              } catch (e) {
                                // Show error in dialog
                                Get.snackbar(
                                  'Error',
                                  'Failed to add address',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: AppColors.error,
                                  colorText: Colors.white,
                                );
                              } finally {
                                isSaving.value = false;
                              }
                            }
                          },
                      child: isSaving.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save Address'),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Dedicated Address Management Page
class AddressManagementView extends StatelessWidget {
  AddressManagementView({super.key});

  // Put controller here to ensure it's initialized
  final CheckoutController controller = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Addresses'),
        actions: [
          IconButton(
            onPressed: () => controller.refreshAddresses(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingAddresses.value && controller.addresses.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.hasAddresses) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_off_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No addresses found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _showAddAddressDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Address'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshAddresses(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.addresses.length,
            itemBuilder: (_, index) {
              final address = controller.addresses[index];
              return _buildAddressCard(context, address);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAddressDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Address'),
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, AddressModel address) {
    final isSelected = controller.selectedAddressId.value == int.parse(address.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (address.isDefaultAddress)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Default',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          if (address.isDefaultAddress) const SizedBox(width: 8),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                              size: 16,
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        address.fullAddress,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (!address.isDefaultAddress)
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => controller.setDefaultAddress(address),
                      icon: const Icon(Icons.star_border, size: 18),
                      label: const Text('Set Default'),
                    ),
                  ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _confirmDelete(context, address),
                    icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                    label: const Text('Delete', style: TextStyle(color: AppColors.error)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    final addressLine1Controller = TextEditingController();
    final addressLine2Controller = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final pincodeController = TextEditingController();
    
    final formKey = GlobalKey<FormState>();
    final isSaving = false.obs;

    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add New Address',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                CustomTextField(
                  controller: addressLine1Controller,
                  hintText: 'Address Line 1 *',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Required';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                
                CustomTextField(
                  controller: addressLine2Controller,
                  hintText: 'Address Line 2 (optional)',
                ),
                const SizedBox(height: 12),
                
                CustomTextField(
                  controller: cityController,
                  hintText: 'City *',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Required';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                
                CustomTextField(
                  controller: stateController,
                  hintText: 'State *',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Required';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                
                CustomTextField(
                  controller: pincodeController,
                  hintText: 'Pincode *',
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Required';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                Obx(() {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSaving.value
                        ? null
                        : () async {
                            if (formKey.currentState!.validate()) {
                              isSaving.value = true;
                              try {
                                await controller.addAddress(
                                  addressLine1: addressLine1Controller.text.trim(),
                                  addressLine2: addressLine2Controller.text.trim(),
                                  city: cityController.text.trim(),
                                  state: stateController.text.trim(),
                                  pincode: pincodeController.text.trim(),
                                );
                                Get.back();
                                Get.snackbar(
                                  'Success',
                                  'Address added successfully',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: AppColors.success,
                                  colorText: Colors.white,
                                );
                              } catch (e) {
                                Get.snackbar(
                                  'Error',
                                  'Failed to add address',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: AppColors.error,
                                  colorText: Colors.white,
                                );
                              } finally {
                                isSaving.value = false;
                              }
                            }
                          },
                      child: isSaving.value
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save Address'),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, AddressModel address) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Address'),
        content: Text('Are you sure you want to delete this address?\n\n${address.shortAddress}'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              try {
                await controller.deleteAddress(address);
                Get.snackbar(
                  'Success',
                  'Address deleted',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.success,
                  colorText: Colors.white,
                );
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Failed to delete address',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.error,
                  colorText: Colors.white,
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

