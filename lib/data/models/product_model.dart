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
  final double stockQty;
  final bool isInStock;

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
    this.stockQty = 0.0,
    this.isInStock = true,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final stock = double.tryParse(json['stock_qty']?.toString() ?? '0') ?? 0.0;
    final inStock = json['is_in_stock'] != null
        ? (json['is_in_stock'] == true || json['is_in_stock'].toString() == '1')
        : (stock > 0 || json['stock_qty'] == null);

    return ProductModel(
      id: json['id'].toString(),
      categoryId: json['category_id']?.toString() ?? '',
      productName: json['product_name'] ?? '',
      barcode: json['barcode']?.toString() ?? '',
      unit: json['unit']?.toString() ?? '',
      salePrice: double.tryParse(json['sale_price']?.toString() ?? '0') ?? 0.0,
      purchasePrice: double.tryParse(json['purchase_price']?.toString() ?? '0') ?? 0.0,
      gstPercent: double.tryParse(json['gst_percent']?.toString() ?? '0') ?? 0.0,
      status: json['status']?.toString() ?? '1',
      image: json['image']?.toString() ?? '',
      stockQty: stock,
      isInStock: inStock,
    );
  }

  ProductModel copyWith({
    String? id,
    String? categoryId,
    String? productName,
    String? barcode,
    String? unit,
    double? salePrice,
    double? purchasePrice,
    double? gstPercent,
    String? status,
    String? image,
    double? stockQty,
    bool? isInStock,
  }) {
    return ProductModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      productName: productName ?? this.productName,
      barcode: barcode ?? this.barcode,
      unit: unit ?? this.unit,
      salePrice: salePrice ?? this.salePrice,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      gstPercent: gstPercent ?? this.gstPercent,
      status: status ?? this.status,
      image: image ?? this.image,
      stockQty: stockQty ?? this.stockQty,
      isInStock: isInStock ?? this.isInStock,
    );
  }
}
