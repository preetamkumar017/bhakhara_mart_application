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
  final String image;

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
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      categoryId: json['category_id'].toString(),
      productName: json['product_name'] ?? '',
      barcode: json['barcode']?.toString() ?? '',
      unit: json['unit']?.toString() ?? '',
      salePrice: double.tryParse(json['sale_price'].toString()) ?? 0.0,
      purchasePrice: double.tryParse(json['purchase_price'].toString()) ?? 0.0,
      gstPercent: double.tryParse(json['gst_percent'].toString()) ?? 0.0,
      status: json['status'].toString(),
      image: json['image']?.toString() ?? '',
    );
  }
}
