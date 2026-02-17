import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';

class TermsConditionsView extends StatelessWidget {
  const TermsConditionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms & Conditions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: ${DateTime.now().year}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Please read these terms and conditions carefully before using our grocery delivery service. By using our app and services, you agree to be bound by these terms.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    height: 1.6,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              title: '1. Order and Payment',
              content:
                  'Payment Method:\n'
                  '• We currently accept Cash on Delivery (COD) as the primary payment method\n'
                  '• Payment must be made in cash to the delivery person upon receipt of your order\n'
                  '• Please keep exact change ready to facilitate smooth delivery\n'
                  '• The delivery person will provide a receipt upon payment\n\n'
                  'Order Confirmation:\n'
                  '• All orders are subject to availability and confirmation\n'
                  '• We reserve the right to refuse or cancel any order\n'
                  '• Order confirmation will be sent via app notification or SMS\n'
                  '• Prices are subject to change without prior notice',
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: '2. Delivery',
              content:
                  'Delivery Time:\n'
                  '• Delivery time depends on your location and product availability\n'
                  '• Estimated delivery time will be provided at the time of order placement\n'
                  '• We strive to deliver within the estimated timeframe but cannot guarantee exact delivery times\n'
                  '• Delays may occur due to unforeseen circumstances such as weather, traffic, or high demand\n\n'
                  'Delivery Charges:\n'
                  '• Delivery charges may apply based on your location and order value\n'
                  '• Delivery fees will be clearly displayed before order confirmation\n'
                  '• Minimum order value may be required for delivery\n'
                  '• Free delivery may be offered on orders above a certain amount\n\n'
                  'Delivery Area:\n'
                  '• We deliver to specified serviceable areas only\n'
                  '• Please ensure your delivery address is within our service zone\n'
                  '• Accurate address details are essential for successful delivery',
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: '3. Cancellation Policy',
              content:
                  'Before Dispatch:\n'
                  '• Orders can be cancelled free of charge before they are dispatched\n'
                  '• To cancel, please contact customer support immediately\n'
                  '• Cancellation requests will be processed promptly\n'
                  '• You will receive confirmation of cancellation via app notification\n\n'
                  'After Dispatch:\n'
                  '• Once an order is dispatched, cancellation may not be possible\n'
                  '• If cancellation is requested after dispatch, charges may apply\n'
                  '• Cancellation charges will cover the delivery and handling costs incurred\n'
                  '• The amount of charges will depend on the order status and delivery progress\n\n'
                  'Non-Delivery:\n'
                  '• If you are unavailable to receive the order, it may be considered cancelled\n'
                  '• Multiple failed delivery attempts may result in order cancellation\n'
                  '• Applicable charges may be levied for failed deliveries',
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: '4. Refund and Replacement Policy',
              content:
                  'Eligibility:\n'
                  '• Refunds or replacements are provided only for damaged or defective products\n'
                  '• Claims must be made within 24 hours of delivery\n'
                  '• Photographic evidence of damage or defect may be required\n'
                  '• Products must be in their original packaging with all tags intact\n\n'
                  'Damaged Products:\n'
                  '• If you receive damaged products, please report immediately\n'
                  '• We will arrange for replacement or refund as appropriate\n'
                  '• Replacement will be subject to product availability\n'
                  '• Refund will be processed within 7-10 business days\n\n'
                  'Defective Products:\n'
                  '• Defective products will be replaced or refunded at our discretion\n'
                  '• Quality issues must be reported with supporting evidence\n'
                  '• We reserve the right to inspect returned products\n\n'
                  'Non-Refundable:\n'
                  '• Perishable items cannot be returned unless damaged or defective\n'
                  '• Change of mind is not a valid reason for refund\n'
                  '• Opened or used products are not eligible for return',
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: '5. Product Quality and Responsibility',
              content:
                  'Quality Assurance:\n'
                  '• We are committed to providing high-quality products\n'
                  '• All products are sourced from reliable suppliers\n'
                  '• We conduct quality checks before dispatch\n'
                  '• Fresh products are carefully selected and handled\n\n'
                  'Company Responsibility:\n'
                  '• We take full responsibility for the quality of products delivered\n'
                  '• Any quality issues will be addressed promptly and fairly\n'
                  '• We ensure proper storage and handling of all products\n'
                  '• Temperature-sensitive items are transported in appropriate conditions\n\n'
                  'Product Information:\n'
                  '• Product descriptions and images are for reference only\n'
                  '• Actual products may vary slightly from images\n'
                  '• We strive to provide accurate product information\n'
                  '• Expiry dates and manufacturing dates are checked before delivery',
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: '6. User Responsibilities',
              content:
                  'Account Security:\n'
                  '• You are responsible for maintaining the confidentiality of your account\n'
                  '• Do not share your login credentials with others\n'
                  '• Notify us immediately of any unauthorized access\n\n'
                  'Accurate Information:\n'
                  '• Provide accurate delivery address and contact information\n'
                  '• Update your details if they change\n'
                  '• Ensure someone is available to receive the delivery\n\n'
                  'Proper Use:\n'
                  '• Use the app and services for lawful purposes only\n'
                  '• Do not misuse or abuse our services\n'
                  '• Respect our delivery personnel',
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: '7. Limitation of Liability',
              content:
                  'We shall not be liable for:\n\n'
                  '• Delays caused by circumstances beyond our control\n'
                  '• Indirect or consequential damages\n'
                  '• Loss or damage due to incorrect address provided by you\n'
                  '• Issues arising from third-party services\n'
                  '• Force majeure events including natural disasters, strikes, or government actions\n\n'
                  'Our total liability is limited to the value of your order.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: '8. Modifications to Terms',
              content:
                  'Right to Modify:\n'
                  '• We reserve the right to modify these terms and conditions at any time\n'
                  '• Changes will be effective immediately upon posting in the app\n'
                  '• Continued use of our services constitutes acceptance of modified terms\n'
                  '• We may notify you of significant changes via app notification or email\n\n'
                  'It is your responsibility to review these terms periodically for any updates.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: '9. Governing Law',
              content:
                  'These terms and conditions are governed by the laws of India. Any disputes arising from these terms or use of our services shall be subject to the exclusive jurisdiction of the courts in our registered location.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: '10. Contact Information',
              content:
                  'For any questions, concerns, or support regarding these terms and conditions, please contact us through:\n\n'
                  '• In-app customer support\n'
                  '• Email support\n'
                  '• Phone support\n\n'
                  'We are here to assist you and ensure a smooth shopping experience.',
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                'By using our app and services, you acknowledge that you have read, understood, and agree to be bound by these Terms & Conditions.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.primary,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                height: 1.6,
                color: AppColors.textPrimary,
              ),
        ),
      ],
    );
  }
}
