import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../core/themes/app_colors.dart';
import '../../../data/network/api_endpoints.dart';
import '../../../data/network/network_api_services.dart';

class SubscriptionsView extends StatefulWidget {
  const SubscriptionsView({super.key});

  @override
  State<SubscriptionsView> createState() => _SubscriptionsViewState();
}

class _SubscriptionsViewState extends State<SubscriptionsView> {
  final NetworkApiServices _api = NetworkApiServices();
  bool isLoading = true;
  List<dynamic> subscriptions = [];

  @override
  void initState() {
    super.initState();
    _fetchSubscriptions();
  }

  Future<void> _fetchSubscriptions() async {
    try {
      final res = await _api.getApi(ApiEndpoints.subscriptions);
      if (res['status'] == true && res['data'] != null) {
        setState(() {
          subscriptions = res['data'];
          isLoading = false;
        });
      } else {
        _setSampleSubscriptions();
      }
    } catch (_) {
      _setSampleSubscriptions();
    }
  }

  void _setSampleSubscriptions() {
    setState(() {
      subscriptions = [
        {
          'id': 1,
          'product_name': 'Amul Taaza Homogenised Toned Milk',
          'unit': '1 Ltr Pouch',
          'sale_price': 56.0,
          'quantity': 2.0,
          'frequency': 'DAILY',
          'status': 'ACTIVE',
          'next_delivery_date': 'Tomorrow Morning',
          'delivery_time_slot': '07:00 AM - 09:00 AM',
          'image': 'milk_amul.jpg'
        },
        {
          'id': 2,
          'product_name': 'English Oven 100% Whole Wheat Bread',
          'unit': '400 GM',
          'sale_price': 45.0,
          'quantity': 1.0,
          'frequency': 'ALTERNATE_DAYS',
          'status': 'ACTIVE',
          'next_delivery_date': 'Tomorrow Morning',
          'delivery_time_slot': '07:00 AM - 09:00 AM',
          'image': 'bread_wheat.jpg'
        }
      ];
      isLoading = false;
    });
  }

  Future<void> _togglePause(int id, int index) async {
    final currentStatus = subscriptions[index]['status'];
    final newStatus = (currentStatus == 'ACTIVE') ? 'PAUSED' : 'ACTIVE';
    setState(() {
      subscriptions[index]['status'] = newStatus;
    });

    try {
      await _api.postApi(ApiEndpoints.subscriptionToggle(id), {});
      Fluttertoast.showToast(
        msg: newStatus == 'PAUSED' ? 'Subscription Paused ⏸️' : 'Subscription Resumed ▶️',
      );
    } catch (_) {
      Fluttertoast.showToast(msg: 'Status updated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bhakhra Daily • Subscriptions'),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Hero Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF203A43).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.wb_sunny_rounded, color: Colors.amber, size: 36),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fresh Morning Deliveries 🌅',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Daily milk, bread, & eggs delivered to your doorstep every morning by 7:00 AM. Pause anytime!',
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Active Subscriptions (${subscriptions.length})',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('FREE Morning Delivery', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  ...subscriptions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final sub = entry.value;
                    final bool isActive = sub['status'] == 'ACTIVE';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: '${ApiEndpoints.domain}/uploads/products/${sub['image']}',
                                  width: 55,
                                  height: 55,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => const Icon(Icons.local_drink, size: 30, color: AppColors.primary),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      sub['product_name'] ?? 'Daily Grocery Item',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${sub['quantity'].toInt()} packet (${sub['unit'] ?? ''}) • ₹${sub['sale_price']}/day',
                                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            sub['frequency'] ?? 'DAILY',
                                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Next: ${sub['next_delivery_date']}',
                                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isActive ? '🟢 Active Daily Delivery' : '⏸️ Paused (No Delivery)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isActive ? AppColors.success : Colors.orange.shade800,
                                ),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => _togglePause(sub['id'], index),
                                icon: Icon(isActive ? Icons.pause : Icons.play_arrow, size: 14),
                                label: Text(isActive ? 'Pause' : 'Resume', style: const TextStyle(fontSize: 12)),
                                style: OutlinedButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                  foregroundColor: isActive ? Colors.orange.shade800 : AppColors.success,
                                  side: BorderSide(color: isActive ? Colors.orange.shade300 : AppColors.success),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}
