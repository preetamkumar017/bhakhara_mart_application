class ProductModel {
  final String id;
  final String categoryId;
  final String productName;
  final String barcode;
  final String unit;
  final double salePrice;
  final double purchasePrice;
  final double gstPercent;
  final String status;

  ProductModel({
    required this.id,
    required this.categoryId,
    required this.productName,
    required this.barcode,
    required this.unit,
    required this.salePrice,
    required this.purchasePrice,
    required this.gstPercent,
    required this.status,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      categoryId: json['category_id'].toString(),
      productName: json['product_name'] ?? '',
      barcode: json['barcode'] ?? '',
      unit: json['unit'] ?? '',
      salePrice: double.parse(json['sale_price'].toString()),
      purchasePrice: double.parse(json['purchase_price'].toString()),
      gstPercent: double.parse(json['gst_percent'].toString()),
      status: json['status'].toString(),
    );
  }
}
