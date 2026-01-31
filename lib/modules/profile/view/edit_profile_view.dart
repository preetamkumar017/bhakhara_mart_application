import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bhakharamart/core/themes/app_colors.dart';
import '../controller/profile_controller.dart';

class EditProfileView extends StatelessWidget {
  EditProfileView({super.key});

  final ProfileController controller = Get.find<ProfileController>();
  
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for text fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final alternateMobileController = TextEditingController();
  final dobController = TextEditingController();
  
  // Gender selection
  final RxString selectedGender = ''.obs;

  @override
  Widget build(BuildContext context) {
    // Initialize fields with current values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeFields();
    });

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isUpdating.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Name Field
                _buildTextField(
                  controller: nameController,
                  label: 'Name',
                  hint: 'Enter your name',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    if (value.length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                /// Email Field
                _buildTextField(
                  controller: emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if (!emailRegex.hasMatch(value)) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                /// Alternate Mobile Field
                _buildTextField(
                  controller: alternateMobileController,
                  label: 'Alternate Mobile',
                  hint: '10-digit mobile number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length != 10) {
                      return 'Mobile must be 10 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                /// Date of Birth Field
                _buildTextField(
                  controller: dobController,
                  label: 'Date of Birth',
                  hint: 'YYYY-MM-DD',
                  icon: Icons.cake_outlined,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 24),

                /// Gender Selection
                _buildGenderSection(),
                const SizedBox(height: 32),

                /// Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _initializeFields() {
    final customer = controller.customer.value;
    
    // Only set if different to avoid cursor jumping
    if (nameController.text != customer.name) {
      nameController.text = customer.name;
    }
    if (emailController.text != customer.email) {
      emailController.text = customer.email;
    }
    final altMobile = customer.alternateMobile ?? '';
    if (alternateMobileController.text != altMobile) {
      alternateMobileController.text = altMobile;
    }
    final dob = customer.dateOfBirth ?? '';
    if (dobController.text != dob) {
      dobController.text = dob;
    }
    if (selectedGender.value != customer.gender) {
      selectedGender.value = customer.gender ?? '';
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLength,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          keyboardType: keyboardType,
          maxLength: maxLength,
          readOnly: readOnly,
          onTap: onTap,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildGenderSection() {
    final genders = [
      {'value': 'male', 'label': 'Male', 'icon': Icons.male},
      {'value': 'female', 'label': 'Female', 'icon': Icons.female},
      {'value': 'other', 'label': 'Other', 'icon': Icons.person},
      {'value': 'prefer_not_to_say', 'label': 'Prefer not to say', 'icon': Icons.help_outline},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: genders.map((gender) {
            return Obx(() => ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(gender['icon'] as IconData, size: 18),
                  const SizedBox(width: 4),
                  Text(gender['label'] as String),
                ],
              ),
              selected: selectedGender.value == gender['value'],
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
              backgroundColor: AppColors.surface,
              side: BorderSide(
                color: selectedGender.value == gender['value']
                    ? AppColors.primary
                    : AppColors.divider,
              ),
              onSelected: (selected) {
                if (selected) {
                  selectedGender.value = gender['value'] as String;
                }
              },
            ));
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text = picked.toString().split(' ')[0];
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      controller.updateProfile(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        alternateMobile: alternateMobileController.text.isEmpty 
            ? null 
            : alternateMobileController.text.trim(),
        dateOfBirth: dobController.text.isEmpty ? null : dobController.text.trim(),
        gender: selectedGender.value.isEmpty ? null : selectedGender.value,
      ).then((success) {
        if (success) {
          Get.back();
        }
      });
    }
  }
}

