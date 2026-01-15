import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bhakharamart/core/themes/app_colors.dart';
import '../controller/profile_controller.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),

            /// Profile Avatar Section
            _buildProfileAvatar(),

            const SizedBox(height: 16),

            /// User Information Section
            _buildUserInfoSection(),

            const SizedBox(height: 24),

            /// Profile Actions/Options Section
            _buildProfileOptionsSection(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Build profile avatar with icon
  Widget _buildProfileAvatar() {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        child: const Icon(
          Icons.person,
          size: 50,
          color: AppColors.primary,
        ),
      ),
    );
  }

  /// Build user information section (Name, Email, Mobile)
  Widget _buildUserInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          /// User Name
          _buildInfoRow(
            icon: Icons.person_outline,
            label: 'Name',
            value: 'John Doe', // TODO: Replace with dynamic user data
          ),
          const Divider(height: 24),

          /// Email Address
          _buildInfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: 'john.doe@email.com', // TODO: Replace with dynamic user data
          ),
          const Divider(height: 24),

          /// Mobile Number
          _buildInfoRow(
            icon: Icons.phone_outlined,
            label: 'Mobile',
            value: '+91 98765 43210', // TODO: Replace with dynamic user data
          ),
        ],
      ),
    );
  }

  /// Build individual info row for user details
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build profile options/actions list
  Widget _buildProfileOptionsSection() {
    final options = [
      _ProfileOption(
        icon: Icons.edit_outlined,
        title: 'Edit Profile',
        subtitle: 'Update your personal information',
        onTap: () => Get.toNamed('/edit-profile'),
      ),
      _ProfileOption(
        icon: Icons.shopping_bag_outlined,
        title: 'My Orders',
        subtitle: 'View your order history',
        onTap: () => Get.toNamed('/orders'),
      ),
      _ProfileOption(
        icon: Icons.location_on_outlined,
        title: 'Address Management',
        subtitle: 'Manage delivery addresses',
        onTap: () => Get.toNamed('/address'),
      ),
      _ProfileOption(
        icon: Icons.help_outline,
        title: 'Help & Support',
        subtitle: 'Get help and contact support',
        onTap: () => _showComingSoonDialog('Help & Support'),
      ),
      _ProfileOption(
        icon: Icons.privacy_tip_outlined,
        title: 'Privacy Policy',
        subtitle: 'Read our privacy policy',
        onTap: () => _showComingSoonDialog('Privacy Policy'),
      ),
      _ProfileOption(
        icon: Icons.description_outlined,
        title: 'Terms & Conditions',
        subtitle: 'Read terms of service',
        onTap: () => _showComingSoonDialog('Terms & Conditions'),
      ),
      _ProfileOption(
        icon: Icons.logout,
        title: 'Logout',
        subtitle: 'Sign out from your account',
        isDestructive: true,
        onTap: () => _showLogoutDialog(),
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      itemBuilder: (_, index) {
        return _buildOptionTile(options[index]);
      },
    );
  }

  /// Build individual option tile
  Widget _buildOptionTile(_ProfileOption option) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: option.isDestructive
                ? AppColors.error.withOpacity(0.1)
                : AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            option.icon,
            size: 22,
            color: option.isDestructive ? AppColors.error : AppColors.primary,
          ),
        ),
        title: Text(
          option.title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: option.isDestructive ? AppColors.error : AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          option.subtitle,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textSecondary,
        ),
        onTap: option.onTap,
      ),
    );
  }

  /// Show logout confirmation dialog
  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  /// Show "Coming Soon" dialog for unimplemented features
  void _showComingSoonDialog(String feature) {
    Get.dialog(
      AlertDialog(
        title: const Text('Coming Soon'),
        content: Text('$feature feature is under development.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Model class for profile options
class _ProfileOption {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });
}

