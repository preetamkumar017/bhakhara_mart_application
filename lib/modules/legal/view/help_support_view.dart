import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';

class HelpSupportView extends StatelessWidget {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Help & Support'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Help & Support',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'We are here to help you with any issues or questions.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 24),
            _buildSupportSection(
              context,
              icon: Icons.shopping_bag_outlined,
              title: '1. Order Related Issues',
              description:
                  'For order status, delivery updates, or order confirmation issues, please contact us.\n\n'
                  'We will help you track your order and resolve any delivery-related concerns.',
              iconColor: AppColors.primary,
            ),
            const SizedBox(height: 20),
            _buildSupportSection(
              context,
              icon: Icons.payment_outlined,
              title: '2. Payment Support',
              description:
                  'Currently, we support Cash on Delivery (COD).\n\n'
                  'For payment-related queries, reach out to our support team. We ensure secure and hassle-free payment collection at your doorstep.',
              iconColor: AppColors.success,
            ),
            const SizedBox(height: 20),
            _buildSupportSection(
              context,
              icon: Icons.cancel_outlined,
              title: '3. Cancellation & Refund',
              description:
                  'If you want to cancel an order or request a refund/replacement, please contact us before dispatch or within a reasonable time after delivery.\n\n'
                  'Our team will process your request as per our cancellation and refund policy.',
              iconColor: AppColors.warning,
            ),
            const SizedBox(height: 20),
            _buildSupportSection(
              context,
              icon: Icons.inventory_2_outlined,
              title: '4. Product Issues',
              description:
                  'If you receive a damaged or defective product, inform us immediately with order details.\n\n'
                  'We will arrange for a replacement or refund based on the situation. Please provide photos of the damaged product for faster resolution.',
              iconColor: AppColors.error,
            ),
            const SizedBox(height: 20),
            _buildSupportSection(
              context,
              icon: Icons.phone_android_outlined,
              title: '5. Technical Support',
              description:
                  'For app-related issues like login problems, app crashes, or any technical difficulties, please contact our technical support team.\n\n'
                  'We will assist you in resolving the issue and ensure smooth app experience.',
              iconColor: AppColors.secondary,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.contact_support_outlined,
                        color: AppColors.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '6. Contact Us',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: AppColors.primary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildContactRow(
                    context,
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: 'support@bhakharamart.com',
                  ),
                  const SizedBox(height: 12),
                  _buildContactRow(
                    context,
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: '+91-XXXXXXXXXX',
                  ),
                  const SizedBox(height: 12),
                  _buildContactRow(
                    context,
                    icon: Icons.access_time_outlined,
                    label: 'Support Hours',
                    value: '10:00 AM – 6:00 PM\n(Monday to Saturday)',
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule_outlined,
                          color: AppColors.success,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'We aim to respond within 24–48 working hours.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 13,
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.secondary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'For faster resolution, please keep your order ID ready when contacting support.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            height: 1.5,
                            color: AppColors.textPrimary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  height: 1.6,
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
