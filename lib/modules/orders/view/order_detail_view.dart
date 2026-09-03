import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:bhakharamart/core/themes/app_colors.dart';
import 'package:bhakharamart/data/models/order_history_model.dart';
import 'package:bhakharamart/data/network/api_endpoints.dart';
import 'package:bhakharamart/modules/orders/controller/order_controller.dart';

class OrderDetailView extends StatelessWidget {
  OrderDetailView({super.key});

  final OrderController controller = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    final int orderId = int.parse(Get.parameters['orderId'] ?? '0');
    Future.microtask(() => controller.fetchOrderDetail(orderId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Order Details & Tracking'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => controller.fetchOrderDetail(orderId),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Status',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingDetail.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.selectedOrder.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text(
                  'Unable to load order details',
                  style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => controller.fetchOrderDetail(orderId),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        final order = controller.selectedOrder.value!;

        return RefreshIndicator(
          onRefresh: () => controller.fetchOrderDetail(orderId),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 1. Order Status & Header Card
                _buildOrderHeaderCard(order),

                const SizedBox(height: 14),

                /// 2. Delivery OTP Card (Only for active orders)
                if (order.deliveryOtp != null &&
                    order.deliveryOtp!.isNotEmpty &&
                    order.deliveryStatus != 'DELIVERED' &&
                    order.deliveryStatus != 'CANCELLED')
                  _buildDeliveryOtpCard(order.deliveryOtp!),

                const SizedBox(height: 14),

                /// 3. Visual 5-Stage Delivery Timeline
                _buildDeliveryTimelineCard(order),

                const SizedBox(height: 14),

                /// 4. Delivery Address & Instructions
                _buildDeliveryAddressCard(order),

                const SizedBox(height: 14),

                /// 5. Order Items
                _buildOrderItemsCard(order),

                const SizedBox(height: 14),

                /// 6. Bill Summary & Coupon Savings
                _buildBillSummaryCard(order),

                const SizedBox(height: 20),

                /// 7. Action Button: Download Invoice
                _buildInvoiceDownloadButton(order),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildOrderHeaderCard(OrderDetailModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.orderNo}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: controller.getStatusColor(order.deliveryStatus).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: controller.getStatusColor(order.deliveryStatus).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  controller.getStatusText(order.deliveryStatus),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: controller.getStatusColor(order.deliveryStatus),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.schedule, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                'Placed on ${order.createdAt}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.payments_outlined, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                'Payment Mode: ${order.paymentMode} (${order.paymentStatus})',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryOtpCard(String otp) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.key, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'COD Verification PIN / OTP',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  otp,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    color: AppColors.primary,
                  ),
                ),
                const Text(
                  'Share this PIN with delivery rider to receive order',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryTimelineCard(OrderDetailModel order) {
    final stages = [
      {'status': 'PLACED', 'title': 'Order Placed', 'desc': 'Received by store'},
      {'status': 'CONFIRMED', 'title': 'Confirmed', 'desc': 'Store accepted order'},
      {'status': 'PACKED', 'title': 'Packed', 'desc': 'Fresh items packed'},
      {'status': 'OUT_FOR_DELIVERY', 'title': 'Out for Delivery', 'desc': 'Rider is on the way'},
      {'status': 'DELIVERED', 'title': 'Delivered', 'desc': 'Enjoy your groceries!'},
    ];

    int currentStep = 0;
    final currentStatus = order.deliveryStatus.toUpperCase();
    if (currentStatus == 'CONFIRMED') currentStep = 1;
    if (currentStatus == 'PACKED') currentStep = 2;
    if (currentStatus == 'OUT_FOR_DELIVERY') currentStep = 3;
    if (currentStatus == 'DELIVERED') currentStep = 4;
    if (currentStatus == 'CANCELLED') currentStep = -1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.local_shipping_outlined, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Live Delivery Status',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (currentStatus == 'CANCELLED')
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.cancel, color: AppColors.error),
                  SizedBox(width: 8),
                  Text(
                    'This order was cancelled.',
                    style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          else
            Column(
              children: List.generate(stages.length, (index) {
                final isDone = index <= currentStep;
                final isCurrent = index == currentStep;
                final isLast = index == stages.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isDone ? AppColors.primary : AppColors.card,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDone ? AppColors.primary : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            isDone ? Icons.check : Icons.circle,
                            size: 14,
                            color: isDone ? Colors.white : Colors.transparent,
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 28,
                            color: isDone && index < currentStep
                                ? AppColors.primary
                                : Colors.grey.shade300,
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stages[index]['title']!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                              color: isDone ? AppColors.textPrimary : AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            stages[index]['desc']!,
                            style: TextStyle(
                              fontSize: 11,
                              color: isCurrent ? AppColors.primary : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
        ],
      ),
    );
  }

  Widget _buildDeliveryAddressCard(OrderDetailModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Delivery Address',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (order.customerName != null && order.customerName!.isNotEmpty)
            Text(
              order.customerName!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          Text(
            order.fullAddress,
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          ),
          if (order.city.isNotEmpty)
            Text(
              '${order.city}, ${order.state} - ${order.pincode}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          if (order.deliveryNotes != null && order.deliveryNotes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 14, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Instructions: ${order.deliveryNotes}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderItemsCard(OrderDetailModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Items (${order.items.length})',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (_, __) => const Divider(height: 16),
            itemBuilder: (_, index) {
              final item = order.items[index];
              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: '${ApiEndpoints.domain}/uploads/products/${item.image}',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        width: 50,
                        height: 50,
                        color: AppColors.card,
                        child: const Icon(Icons.image_not_supported, size: 20, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${double.parse(item.quantity).toInt()} x ₹${double.parse(item.salePrice).toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₹${double.parse(item.lineTotal).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBillSummaryCard(OrderDetailModel order) {
    final double subtotal = double.tryParse(order.subtotal ?? order.totalAmount) ?? 0.0;
    final double discount = double.tryParse(order.discountAmount ?? '0') ?? 0.0;
    final double total = double.tryParse(order.totalAmount) ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.receipt_long_outlined, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Payment Breakdown',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 20),
          _buildBillRow('Items Total', '₹${subtotal.toStringAsFixed(2)}'),
          if (discount > 0) ...[
            const SizedBox(height: 6),
            _buildBillRow(
              'Coupon Discount (${order.couponCode ?? 'SAVED'})',
              '-₹${discount.toStringAsFixed(2)}',
              isDiscount: true,
            ),
          ],
          const SizedBox(height: 6),
          _buildBillRow('Delivery Fee', 'FREE', isFree: true),
          const Divider(height: 16),
          _buildBillRow(
            'Total Payable (COD)',
            '₹${total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isDiscount = false, bool isFree = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 14 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isDiscount ? AppColors.success : AppColors.textPrimary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isDiscount
                ? AppColors.success
                : (isFree ? AppColors.success : (isTotal ? AppColors.primary : AppColors.textPrimary)),
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceDownloadButton(OrderDetailModel order) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () {
          Fluttertoast.showToast(
            msg: "Invoice token: ${order.invoiceToken ?? order.orderNo}\nDownloading PDF invoice...",
          );
        },
        icon: const Icon(Icons.picture_as_pdf, color: AppColors.primary),
        label: const Text(
          'Download Tax Invoice PDF',
          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
