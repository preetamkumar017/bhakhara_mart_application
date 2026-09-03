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
  final landmarkController = TextEditingController();
  final RxString selectedAddressType = 'Home'.obs;
  final RxString selectedInstruction = ''.obs;

  Future<void> _initialFetch() async {
    await fetchAddresses();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialFetch();
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Delivery Addresses'),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAddressDialog(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add New Address', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                const Icon(
                  Icons.location_off_outlined,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No delivery addresses saved yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _showAddAddressDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Address'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
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
              : Colors.grey.shade300,
          width: address.isDefaultAddress ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Type badge & Default badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: address.isDefaultAddress ? AppColors.primary : AppColors.card,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      address.addressType == 'Work'
                          ? Icons.work_outline
                          : (address.addressType == 'Other' ? Icons.place_outlined : Icons.home_outlined),
                      size: 14,
                      color: address.isDefaultAddress ? Colors.white : AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      address.addressType.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: address.isDefaultAddress ? Colors.white : AppColors.primary,
                      ),
                    ),
                  ],
                ),
                if (address.isDefaultAddress)
                  const Text(
                    'DEFAULT ADDRESS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
          
          /// Address content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.addressLine1,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                if (address.addressLine2.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(address.addressLine2, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                ],
                if (address.landmark != null && address.landmark!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text('Near ${address.landmark}', style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                ],
                const SizedBox(height: 2),
                Text(
                  '${address.city}, ${address.state} - ${address.pincode}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                if (address.deliveryInstructions != null && address.deliveryInstructions!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 12, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        'Note: ${address.deliveryInstructions}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!address.isDefaultAddress)
                      TextButton.icon(
                        onPressed: () => _setDefaultAddress(address),
                        icon: const Icon(Icons.check_circle_outline, size: 16),
                        label: const Text('Set as Default', style: TextStyle(fontSize: 12)),
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                      onPressed: () => _deleteAddress(address),
                      tooltip: 'Delete',
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Delivery Address'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Address Type', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Obx(() => Row(
                    children: ['Home', 'Work', 'Other'].map((type) {
                      final isSelected = selectedAddressType.value == type;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(type),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (_) => selectedAddressType.value = type,
                        ),
                      );
                    }).toList(),
                  )),
              const SizedBox(height: 10),
              _buildDialogTextField(
                controller: addressLine1Controller,
                label: 'House / Flat / Building No. *',
                hint: 'e.g. Flat 402, Shivam Heights',
              ),
              const SizedBox(height: 10),
              _buildDialogTextField(
                controller: addressLine2Controller,
                label: 'Street / Area / Colony',
                hint: 'e.g. Main Road, Shankar Nagar',
              ),
              const SizedBox(height: 10),
              _buildDialogTextField(
                controller: landmarkController,
                label: 'Landmark',
                hint: 'e.g. Near Water Tank or School',
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildDialogTextField(
                      controller: cityController,
                      label: 'City *',
                      hint: 'City',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildDialogTextField(
                      controller: pincodeController,
                      label: 'Pincode *',
                      hint: '6-digit',
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildDialogTextField(
                controller: stateController,
                label: 'State',
                hint: 'State',
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
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Save Address', style: TextStyle(color: Colors.white)),
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
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
    landmarkController.clear();
    selectedAddressType.value = 'Home';
    selectedInstruction.value = '';
  }

  Future<void> _addAddress(BuildContext context) async {
    if (addressLine1Controller.text.trim().isEmpty) {
      SnackBarUtils.showError('Address line 1 is required');
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
        landmark: landmarkController.text.trim(),
        addressType: selectedAddressType.value,
        deliveryInstructions: selectedInstruction.value,
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
            onPressed: () => Get.back(result: false),
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

    if (confirm == true) {
      try {
        await _addressRepo.deleteAddress(int.parse(address.id));
        SnackBarUtils.showSuccess('Address deleted');
        await fetchAddresses();
      } catch (e) {
        SnackBarUtils.showError('Failed to delete address: $e');
      }
    }
  }
}
