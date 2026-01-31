import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bhakharamart/core/themes/app_colors.dart';
import 'package:bhakharamart/data/models/address_model.dart';
import 'package:bhakharamart/modules/profile/repo/address_repo.dart';
import 'package:bhakharamart/core/utils/snackbar.dart';

class AddressView extends StatelessWidget {
  AddressView({super.key});

  final AddressRepo _addressRepo = AddressRepo();
  
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isAdding = false.obs;

  // Form controllers
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();

  Future<void> _initialFetch() async {
    await fetchAddresses();
  }

  @override
  Widget build(BuildContext context) {
    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialFetch();
    });

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('My Addresses'),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAddressDialog(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (addresses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_off,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No addresses added yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _showAddAddressDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Address'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: addresses.length,
          itemBuilder: (_, index) {
            final address = addresses[index];
            return _buildAddressCard(context, address);
          },
        );
      }),
    );
  }

  Future<void> fetchAddresses() async {
    try {
      isLoading.value = true;
      addresses.assignAll(await _addressRepo.fetchAddresses());
    } catch (e) {
      SnackBarUtils.showError('Failed to load addresses: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Widget _buildAddressCard(BuildContext context, AddressModel address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: address.isDefaultAddress 
              ? AppColors.primary 
              : AppColors.divider,
          width: address.isDefaultAddress ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Default badge
          if (address.isDefaultAddress)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: const Text(
                'DEFAULT',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          
          // Address content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        address.fullAddress,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Actions row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Set as default
                    if (!address.isDefaultAddress)
                      TextButton(
                        onPressed: () => _setDefaultAddress(address),
                        child: const Text(
                          'Set as Default',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    
                    // Edit
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: () => _showEditAddressDialog(context, address),
                      color: AppColors.textSecondary,
                    ),
                    
                    // Delete
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => _deleteAddress(address),
                      color: AppColors.error,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    _clearForm();
    
    Get.dialog(
      AlertDialog(
        title: const Text('Add Address'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogTextField(
                controller: addressLine1Controller,
                label: 'Address Line 1 *',
                hint: 'House No., Street Name',
              ),
              const SizedBox(height: 12),
              _buildDialogTextField(
                controller: addressLine2Controller,
                label: 'Address Line 2',
                hint: 'Landmark, Area',
              ),
              const SizedBox(height: 12),
              _buildDialogTextField(
                controller: cityController,
                label: 'City *',
                hint: 'City name',
              ),
              const SizedBox(height: 12),
              _buildDialogTextField(
                controller: stateController,
                label: 'State',
                hint: 'State name',
              ),
              const SizedBox(height: 12),
              _buildDialogTextField(
                controller: pincodeController,
                label: 'Pincode *',
                hint: '6-digit pincode',
                keyboardType: TextInputType.number,
                maxLength: 6,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _addAddress(context),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditAddressDialog(BuildContext context, AddressModel address) {
    // Pre-fill form
    addressLine1Controller.text = address.addressLine1;
    addressLine2Controller.text = address.addressLine2;
    cityController.text = address.city;
    stateController.text = address.state;
    pincodeController.text = address.pincode;

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Address'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogTextField(
                controller: addressLine1Controller,
                label: 'Address Line 1 *',
                hint: 'House No., Street Name',
              ),
              const SizedBox(height: 12),
              _buildDialogTextField(
                controller: addressLine2Controller,
                label: 'Address Line 2',
                hint: 'Landmark, Area',
              ),
              const SizedBox(height: 12),
              _buildDialogTextField(
                controller: cityController,
                label: 'City *',
                hint: 'City name',
              ),
              const SizedBox(height: 12),
              _buildDialogTextField(
                controller: stateController,
                label: 'State',
                hint: 'State name',
              ),
              const SizedBox(height: 12),
              _buildDialogTextField(
                controller: pincodeController,
                label: 'Pincode *',
                hint: '6-digit pincode',
                keyboardType: TextInputType.number,
                maxLength: 6,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _updateAddress(context, address),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      keyboardType: keyboardType,
      maxLength: maxLength,
    );
  }

  void _clearForm() {
    addressLine1Controller.clear();
    addressLine2Controller.clear();
    cityController.clear();
    stateController.clear();
    pincodeController.clear();
  }

  Future<void> _addAddress(BuildContext context) async {
    // Validate required fields
    if (addressLine1Controller.text.trim().isEmpty) {
      SnackBarUtils.showError('Address line1 is required');
      return;
    }
    if (cityController.text.trim().isEmpty) {
      SnackBarUtils.showError('City is required');
      return;
    }
    if (pincodeController.text.trim().isEmpty) {
      SnackBarUtils.showError('Pincode is required');
      return;
    }

    Get.back(); // Close dialog

    try {
      isAdding.value = true;
      final success = await _addressRepo.addAddress(
        addressLine1: addressLine1Controller.text.trim(),
        addressLine2: addressLine2Controller.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        pincode: pincodeController.text.trim(),
      );
      if (success) {
        SnackBarUtils.showSuccess('Address added successfully');
        await fetchAddresses();
      }
    } catch (e) {
      SnackBarUtils.showError('Failed to add address: $e');
    } finally {
      isAdding.value = false;
      _clearForm();
    }
  }

  Future<void> _updateAddress(BuildContext context, AddressModel address) async {
    // Validate required fields
    if (addressLine1Controller.text.trim().isEmpty) {
      SnackBarUtils.showError('Address line1 is required');
      return;
    }

    Get.back(); // Close dialog

    try {
      isAdding.value = true;
      final success = await _addressRepo.updateAddress(
        addressId: int.parse(address.id),
        addressLine1: addressLine1Controller.text.trim(),
        addressLine2: addressLine2Controller.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        pincode: pincodeController.text.trim(),
      );
      if (success) {
        SnackBarUtils.showSuccess('Address updated successfully');
        await fetchAddresses();
      }
    } catch (e) {
      SnackBarUtils.showError('Failed to update address: $e');
    } finally {
      isAdding.value = false;
      _clearForm();
    }
  }

  Future<void> _setDefaultAddress(AddressModel address) async {
    try {
      await _addressRepo.setDefaultAddress(int.parse(address.id));
      SnackBarUtils.showSuccess('Default address updated');
      await fetchAddresses();
    } catch (e) {
      SnackBarUtils.showError('Failed to set default: $e');
    }
  }

  Future<void> _deleteAddress(AddressModel address) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            onPressed: () => Get.back(result: true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final success = await _addressRepo.deleteAddress(int.parse(address.id));
      if (success) {
        SnackBarUtils.showSuccess('Address deleted');
        addresses.remove(address);
      }
    } catch (e) {
      SnackBarUtils.showError('Failed to delete: $e');
    }
  }
}

