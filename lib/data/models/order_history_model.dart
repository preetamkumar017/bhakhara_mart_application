class OrderHistoryModel {
  final String id;
  final String orderNo;
  final String totalAmount;
  final String? couponCode;
  final String? discountAmount;
  final String paymentMode;
  final String paymentStatus;
  final String? deliveryOtp;
  final String createdAt;
  final String deliveryStatus;

  OrderHistoryModel({
    required this.id,
    required this.orderNo,
    required this.totalAmount,
    this.couponCode,
    this.discountAmount,
    this.paymentMode = 'COD',
    this.paymentStatus = 'PENDING',
    this.deliveryOtp,
    required this.createdAt,
    required this.deliveryStatus,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderHistoryModel(
      id: json['id']?.toString() ?? '',
      orderNo: json['order_no'] ?? '',
      totalAmount: json['total_amount']?.toString() ?? '0.00',
      couponCode: json['coupon_code']?.toString(),
      discountAmount: json['discount_amount']?.toString(),
      paymentMode: json['payment_mode']?.toString() ?? 'COD',
      paymentStatus: json['payment_status']?.toString() ?? 'PENDING',
      deliveryOtp: json['delivery_otp']?.toString(),
      createdAt: json['created_at'] ?? '',
      deliveryStatus: json['delivery_status'] ?? 'PLACED',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_no': orderNo,
      'total_amount': totalAmount,
      'coupon_code': couponCode,
      'discount_amount': discountAmount,
      'payment_mode': paymentMode,
      'payment_status': paymentStatus,
      'delivery_otp': deliveryOtp,
      'created_at': createdAt,
      'delivery_status': deliveryStatus,
    };
  }
}

class OrderDetailModel {
  final String id;
  final String orderNo;
  final String totalAmount;
  final String? subtotal;
  final String? couponCode;
  final String? discountAmount;
  final String? deliveryCharge;
  final String paymentMode;
  final String paymentStatus;
  final String? deliveryOtp;
  final String? deliveryInstructions;
  final String? invoiceToken;
  final String createdAt;
  final String deliveryStatus;
  final String? customerName;
  final String? mobile;
  final String fullAddress;
  final String city;
  final String state;
  final String pincode;
  final String? deliveryNotes;
  final List<OrderItemModel> items;
  final List<OrderTimelineItem> timeline;

  OrderDetailModel({
    required this.id,
    required this.orderNo,
    required this.totalAmount,
    this.subtotal,
    this.couponCode,
    this.discountAmount,
    this.deliveryCharge,
    this.paymentMode = 'COD',
    this.paymentStatus = 'PENDING',
    this.deliveryOtp,
    this.deliveryInstructions,
    this.invoiceToken,
    required this.createdAt,
    required this.deliveryStatus,
    this.customerName,
    this.mobile,
    required this.fullAddress,
    required this.city,
    required this.state,
    required this.pincode,
    this.deliveryNotes,
    required this.items,
    this.timeline = const [],
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json, {List<dynamic>? timelineList}) {
    var itemsList = <OrderItemModel>[];
    if (json['items'] != null) {
      itemsList = List<Map<String, dynamic>>.from(json['items'])
          .map((item) => OrderItemModel.fromJson(item))
          .toList();
    }

    var timelineParsed = <OrderTimelineItem>[];
    if (timelineList != null) {
      timelineParsed = timelineList
          .map((e) => OrderTimelineItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return OrderDetailModel(
      id: json['id']?.toString() ?? '',
      orderNo: json['order_no'] ?? '',
      totalAmount: json['total_amount']?.toString() ?? '0.00',
      subtotal: json['subtotal']?.toString(),
      couponCode: json['coupon_code']?.toString(),
      discountAmount: json['discount_amount']?.toString(),
      deliveryCharge: json['delivery_charge']?.toString(),
      paymentMode: json['payment_mode']?.toString() ?? 'COD',
      paymentStatus: json['payment_status']?.toString() ?? 'PENDING',
      deliveryOtp: json['delivery_otp']?.toString(),
      deliveryInstructions: json['delivery_instructions']?.toString(),
      invoiceToken: json['invoice_token']?.toString(),
      createdAt: json['created_at'] ?? '',
      deliveryStatus: json['delivery_status'] ?? 'PLACED',
      customerName: json['customer_name']?.toString(),
      mobile: json['mobile']?.toString(),
      fullAddress: json['full_address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      deliveryNotes: json['delivery_notes']?.toString(),
      items: itemsList,
      timeline: timelineParsed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_no': orderNo,
      'total_amount': totalAmount,
      'subtotal': subtotal,
      'coupon_code': couponCode,
      'discount_amount': discountAmount,
      'delivery_charge': deliveryCharge,
      'payment_mode': paymentMode,
      'payment_status': paymentStatus,
      'delivery_otp': deliveryOtp,
      'delivery_instructions': deliveryInstructions,
      'invoice_token': invoiceToken,
      'created_at': createdAt,
      'delivery_status': deliveryStatus,
      'customer_name': customerName,
      'mobile': mobile,
      'full_address': fullAddress,
      'city': city,
      'state': state,
      'pincode': pincode,
      'delivery_notes': deliveryNotes,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderTimelineItem {
  final String status;
  final String? changedBy;
  final String createdAt;

  OrderTimelineItem({
    required this.status,
    this.changedBy,
    required this.createdAt,
  });

  factory OrderTimelineItem.fromJson(Map<String, dynamic> json) {
    return OrderTimelineItem(
      status: json['status']?.toString() ?? '',
      changedBy: json['changed_by']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}

class OrderItemModel {
  final String productId;
  final String productName;
  final String image;
  final String categoryId;
  final String categoryName;
  final String unitId;
  final String unitName;
  final String unitCode;
  final String quantity;
  final String salePrice;
  final String gstPercent;
  final String lineTotal;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.image,
    required this.categoryId,
    required this.categoryName,
    required this.unitId,
    required this.unitName,
    required this.unitCode,
    required this.quantity,
    required this.salePrice,
    required this.gstPercent,
    required this.lineTotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name'] ?? '',
      image: json['image']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      categoryName: json['category_name'] ?? '',
      unitId: json['unit_id']?.toString() ?? '',
      unitName: json['unit_name'] ?? '',
      unitCode: json['unit_code'] ?? '',
      quantity: json['quantity']?.toString() ?? '0.00',
      salePrice: json['sale_price']?.toString() ?? '0.00',
      gstPercent: json['gst_percent']?.toString() ?? '0.00',
      lineTotal: json['line_total']?.toString() ?? '0.00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'image': image,
      'category_id': categoryId,
      'category_name': categoryName,
      'unit_id': unitId,
      'unit_name': unitName,
      'unit_code': unitCode,
      'quantity': quantity,
      'sale_price': salePrice,
      'gst_percent': gstPercent,
      'line_total': lineTotal,
    };
  }
}
