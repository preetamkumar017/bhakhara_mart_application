import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
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
            const SizedBox(height: 24),
            _buildSection(
              context,
              title: '1. Information We Collect',
              content:
                  'We collect personal information that you provide to us when using our grocery delivery app, including:\n\n'
                  '• Name\n'
                  '• Phone number\n'
                  '• Delivery address\n'
                  '• Order details\n\n'
                  'This information is collected solely for the purpose of processing and delivering your orders efficiently.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: '2. How We Use Your Information',
              content:
                  'Your personal data is used exclusively for:\n\n'
                  '• Processing your orders\n'
                  '• Delivering products to your specified address\n'
                  '• Communicating order status and updates\n'
                  '• Providing customer support\n'
                  '• Improving our services\n\n'
                  'We do not use your information for any other purpose without your explicit consent.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: '3. Data Storage and Security',
              content:
                  'We take the security of your personal information seriously. Your data is:\n\n'
                  '• Stored securely on protected servers\n'
                  '• Encrypted during transmission\n'
                  '• Accessible only to authorized personnel\n'
                  '• Protected by industry-standard security measures\n\n'
                  'We implement appropriate technical and organizational measures to protect your personal data against unauthorized access, alteration, disclosure, or destruction.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: '4. Data Sharing',
              content:
                  'We respect your privacy and do not share your personal information with third parties, except:\n\n'
                  '• When required by law or legal proceedings\n'
                  '• To comply with government regulations\n'
                  '• In response to valid legal requests from authorities\n'
                  '• To protect our rights, property, or safety\n\n'
                  'We do not sell, rent, or trade your personal information to any third party for marketing purposes.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: '5. Compliance with Indian IT Act, 2000',
              content:
                  'Our privacy practices comply with the Information Technology Act, 2000, and the Information Technology (Reasonable Security Practices and Procedures and Sensitive Personal Data or Information) Rules, 2011.\n\n'
                  'We are committed to protecting your sensitive personal data as defined under Indian law, including:\n\n'
                  '• Implementing reasonable security practices\n'
                  '• Obtaining consent for data collection and usage\n'
                  '• Ensuring data accuracy and integrity\n'
                  '• Providing mechanisms for data access and correction',
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: '6. User Consent',
              content:
                  'By using our app and services, you consent to:\n\n'
                  '• The collection of your personal information as described\n'
                  '• The use of your data for order processing and delivery\n'
                  '• The storage of your information on our secure servers\n'
                  '• Our privacy practices as outlined in this policy\n\n'
                  'You have the right to withdraw your consent at any time by discontinuing use of our services and requesting deletion of your account.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: '7. Your Rights',
              content:
                  'You have the right to:\n\n'
                  '• Access your personal information\n'
                  '• Correct inaccurate data\n'
                  '• Request deletion of your account and data\n'
                  '• Withdraw consent for data processing\n'
                  '• Lodge a complaint with relevant authorities\n\n'
                  'To exercise these rights, please contact our customer support.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: '8. Data Retention',
              content:
                  'We retain your personal information only for as long as necessary to:\n\n'
                  '• Fulfill the purposes outlined in this policy\n'
                  '• Comply with legal obligations\n'
                  '• Resolve disputes\n'
                  '• Enforce our agreements\n\n'
                  'Once your data is no longer required, it will be securely deleted or anonymized.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: '9. Changes to Privacy Policy',
              content:
                  'We may update this Privacy Policy from time to time to reflect changes in our practices or legal requirements. We will notify you of any significant changes through the app or via email.\n\n'
                  'Continued use of our services after such modifications constitutes acceptance of the updated Privacy Policy.',
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: '10. Contact Us',
              content:
                  'If you have any questions, concerns, or requests regarding this Privacy Policy or our data practices, please contact us through:\n\n'
                  '• In-app customer support\n'
                  '• Email support\n'
                  '• Phone support\n\n'
                  'We are committed to addressing your privacy concerns promptly and effectively.',
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
