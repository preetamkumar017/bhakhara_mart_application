import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/themes/app_colors.dart';

class HelpSupportView extends StatelessWidget {
  const HelpSupportView({super.key});

  Future<void> _openWhatsApp() async {
    const phone = "916260898800";
    const msg = "Hi Bhakhra Mart Support, I need help with my grocery order.";
    final url = Uri.parse("https://wa.me/$phone?text=${Uri.encodeComponent(msg)}");
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Fluttertoast.showToast(msg: "Please WhatsApp us at +91-6260898800");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Could not open WhatsApp: +91-6260898800");
    }
  }

  Future<void> _makeCall() async {
    final url = Uri.parse("tel:+916260898800");
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Help & 24x7 Support'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Quick Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.support_agent, size: 28, color: AppColors.primary),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Instant Customer Care',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            Text(
                              'Average response time: Under 5 mins',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _openWhatsApp,
                          icon: const Icon(Icons.chat, color: Colors.white, size: 18),
                          label: const Text('WhatsApp Chat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366), // WhatsApp Green
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _makeCall,
                          icon: const Icon(Icons.call, color: AppColors.primary, size: 18),
                          label: const Text('Call Us', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _buildSupportSection(
              context,
              icon: Icons.shopping_bag_outlined,
              title: '1. Order Related Issues',
              description: 'For order status, live delivery updates, or COD verification PIN issues, chat with us on WhatsApp or call our helpline.',
              iconColor: AppColors.primary,
            ),
            const SizedBox(height: 12),
            _buildSupportSection(
              context,
              icon: Icons.payment_outlined,
              title: '2. Cash on Delivery (COD) Support',
              description: 'We support 100% Cash on Delivery at your doorstep. Please share the 4-digit PIN with the delivery boy after receiving groceries.',
              iconColor: AppColors.success,
            ),
            const SizedBox(height: 12),
            _buildSupportSection(
              context,
              icon: Icons.cancel_outlined,
              title: '3. Cancellation & Instant Replacement',
              description: 'If you receive damaged items or want to modify an order, contact us immediately for 100% replacement guarantee.',
              iconColor: AppColors.error,
            ),

            const SizedBox(height: 20),

            /// Contact info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Direct Contacts', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const Divider(height: 16),
                  _buildContactRow(icon: Icons.email_outlined, label: 'Email Support', value: 'bhakharamart@gmail.com'),
                  const SizedBox(height: 10),
                  _buildContactRow(icon: Icons.phone_outlined, label: 'Direct Helpline', value: '+91-6260898800'),
                  const SizedBox(height: 10),
                  _buildContactRow(icon: Icons.access_time_outlined, label: 'Service Hours', value: '7:00 AM – 10:00 PM (All 7 Days)'),
                ],
              ),
            ),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 6),
          Text(description, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildContactRow({required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}
