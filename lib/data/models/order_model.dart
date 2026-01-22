class OrderModel {
  final int orderId;
  final String orderNo;
  final double totalAmount;
  final String deliveryStatus;
  final bool status;
  final String? message;

  OrderModel({
    required this.orderId,
    required this.orderNo,
    required this.totalAmount,
    required this.deliveryStatus,
    required this.status,
    this.message,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'] ?? 0,
      orderNo: json['order_no'] ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      deliveryStatus: json['delivery_status'] ?? '',
      status: json['status'] ?? false,
      message: json['message'],
    );
  }

  /// Factory constructor for error responses
  factory OrderModel.error(String message) {
    return OrderModel(
      orderId: 0,
      orderNo: '',
      totalAmount: 0,
      deliveryStatus: '',
      status: false,
      message: message,
    );
  }

  /// Check if order was placed successfully
  bool get isSuccess => status && orderId > 0;

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'order_no': orderNo,
      'total_amount': totalAmount,
      'delivery_status': deliveryStatus,
      'status': status,
      'message': message,
    };
  }
}

