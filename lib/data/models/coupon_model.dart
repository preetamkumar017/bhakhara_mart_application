class CouponModel {
  final int? id;
  final String? discountName;
  final String code;
  final String? description;
  final String discountType; // 'PERCENT' or 'FLAT'
  final double discountValue;
  final double minOrderAmount;
  final double? maxDiscount;
  final String? startDate;
  final String? endDate;

  CouponModel({
    this.id,
    this.discountName,
    required this.code,
    this.description,
    required this.discountType,
    required this.discountValue,
    required this.minOrderAmount,
    this.maxDiscount,
    this.startDate,
    this.endDate,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      discountName: json['discount_name']?.toString(),
      code: json['code']?.toString() ?? '',
      description: json['description']?.toString(),
      discountType: json['discount_type']?.toString().toUpperCase() ?? 'FLAT',
      discountValue: double.tryParse(json['discount_value']?.toString() ?? '0') ?? 0.0,
      minOrderAmount: double.tryParse(json['min_order_amount']?.toString() ?? '0') ?? 0.0,
      maxDiscount: json['max_discount'] != null
          ? double.tryParse(json['max_discount'].toString())
          : null,
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'discount_name': discountName,
      'code': code,
      'description': description,
      'discount_type': discountType,
      'discount_value': discountValue,
      'min_order_amount': minOrderAmount,
      'max_discount': maxDiscount,
      'start_date': startDate,
      'end_date': endDate,
    };
  }

  String get offerBadgeText {
    if (discountType == 'PERCENT') {
      return "${discountValue.toInt()}% OFF";
    }
    return "₹${discountValue.toInt()} FLAT OFF";
  }
}
