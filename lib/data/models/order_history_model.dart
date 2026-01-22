class OrderHistoryModel {
  final String id;
  final String orderNo;
  final String totalAmount;
  final String createdAt;
  final String deliveryStatus;

  OrderHistoryModel({
    required this.id,
    required this.orderNo,
    required this.totalAmount,
    required this.createdAt,
    required this.deliveryStatus,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderHistoryModel(
      id: json['id']?.toString() ?? '',
      orderNo: json['order_no'] ?? '',
      totalAmount: json['total_amount'] ?? '0.00',
      createdAt: json['created_at'] ?? '',
      deliveryStatus: json['delivery_status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_no': orderNo,
      'total_amount': totalAmount,
      'created_at': createdAt,
      'delivery_status': deliveryStatus,
    };
  }
}

class OrderDetailModel {
  final String id;
  final String orderNo;
  final String totalAmount;
  final String createdAt;
  final String deliveryStatus;
  final String fullAddress;
  final String city;
  final String state;
  final String pincode;
  final List<OrderItemModel> items;

  OrderDetailModel({
    required this.id,
    required this.orderNo,
    required this.totalAmount,
    required this.createdAt,
    required this.deliveryStatus,
    required this.fullAddress,
    required this.city,
    required this.state,
    required this.pincode,
    required this.items,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    var itemsList = <OrderItemModel>[];
    if (json['items'] != null) {
      itemsList = List<Map<String, dynamic>>.from(json['items'])
          .map((item) => OrderItemModel.fromJson(item))
          .toList();
    }

    return OrderDetailModel(
      id: json['id']?.toString() ?? '',
      orderNo: json['order_no'] ?? '',
      totalAmount: json['total_amount'] ?? '0.00',
      createdAt: json['created_at'] ?? '',
      deliveryStatus: json['delivery_status'] ?? '',
      fullAddress: json['full_address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      items: itemsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_no': orderNo,
      'total_amount': totalAmount,
      'created_at': createdAt,
      'delivery_status': deliveryStatus,
      'full_address': fullAddress,
      'city': city,
      'state': state,
      'pincode': pincode,
      'items': items.map((item) => item.toJson()).toList(),
    };
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

