class ProductVariantModel {
  final int id;
  final String variantName;
  final double salePrice;
  final double? mrp;
  final double stockQty;
  final bool isDefault;

  ProductVariantModel({
    required this.id,
    required this.variantName,
    required this.salePrice,
    this.mrp,
    required this.stockQty,
    this.isDefault = false,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      variantName: json['variant_name']?.toString() ?? '',
      salePrice: double.tryParse(json['sale_price']?.toString() ?? '0') ?? 0.0,
      mrp: json['mrp'] != null ? double.tryParse(json['mrp'].toString()) : null,
      stockQty: double.tryParse(json['stock_qty']?.toString() ?? '100') ?? 100.0,
      isDefault: json['is_default'] == true || json['is_default'] == 1 || json['is_default'] == '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'variant_name': variantName,
      'sale_price': salePrice,
      'mrp': mrp,
      'stock_qty': stockQty,
      'is_default': isDefault,
    };
  }

  bool get isInStock => stockQty > 0;
}
