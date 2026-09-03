import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/themes/app_colors.dart';
import '../../../data/network/api_endpoints.dart';
import '../../../data/network/network_api_services.dart';

class RewardsView extends StatefulWidget {
  const RewardsView({super.key});

  @override
  State<RewardsView> createState() => _RewardsViewState();
}

class _RewardsViewState extends State<RewardsView> {
  final NetworkApiServices _api = NetworkApiServices();
  bool isLoading = true;
  int pointsBalance = 100;
  double rupeesValue = 10.0;
  String referralCode = 'BM100';
  String shareMsg = 'Order groceries with Flat ₹50 OFF!';
  List<dynamic> transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchRewards();
  }

  Future<void> _fetchRewards() async {
    try {
      final res = await _api.getApi(ApiEndpoints.customerRewards);
      if (res['status'] == true && res['data'] != null) {
        final data = res['data'];
        setState(() {
          pointsBalance = int.tryParse(data['points_balance']?.toString() ?? '100') ?? 100;
          rupeesValue = double.tryParse(data['rupees_value']?.toString() ?? '10.0') ?? 10.0;
          referralCode = data['referral_code']?.toString() ?? 'BM100';
          shareMsg = data['referral_share_msg']?.toString() ?? shareMsg;
          transactions = data['transactions'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: referralCode));
    Fluttertoast.showToast(msg: "Referral code '$referralCode' copied!");
  }

  void _shareWhatsApp() {
    Share.share(shareMsg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bhakhra Coins & Rewards'),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Bhakhra Coins Balance Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E3C72).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.stars_rounded, color: Colors.amber, size: 28),
                                SizedBox(width: 8),
                                Text(
                                  'Bhakhra Coins',
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text('10 Coins = ₹1', style: TextStyle(color: Colors.white, fontSize: 11)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '$pointsBalance Coins',
                          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Equivalent to ₹${rupeesValue.toStringAsFixed(2)} discount on your next order',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Refer & Earn Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.card_giftcard, color: AppColors.primary, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Refer Friends & Earn ₹50',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Share your referral code with friends. They get Flat ₹50 OFF on their 1st order and you earn 500 Bhakhra Coins!',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                        ),
                        const SizedBox(height: 14),

                        /// Code box
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), style: BorderStyle.solid),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('YOUR REFERRAL CODE', style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                                  Text(
                                    referralCode,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: AppColors.primary),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 20, color: AppColors.primary),
                                onPressed: _copyCode,
                                tooltip: 'Copy Code',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _shareWhatsApp,
                            icon: const Icon(Icons.share, color: Colors.white, size: 18),
                            label: const Text('Share Code on WhatsApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF25D366),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// How it Works
                  const Text('How to Earn & Redeem', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildRuleRow(Icons.shopping_bag_outlined, 'Shop & Earn', 'Earn 1 Bhakhra Coin on every ₹10 spent on groceries.'),
                  const SizedBox(height: 8),
                  _buildRuleRow(Icons.people_outline, 'Referral Bonus', 'Earn 500 Coins (₹50) when your invited friend receives their first order.'),
                  const SizedBox(height: 8),
                  _buildRuleRow(Icons.savings_outlined, 'Instant Redemption', 'Coins are automatically applied at checkout for maximum savings.'),
                ],
              ),
            ),
    );
  }

  Widget _buildRuleRow(IconData icon, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
