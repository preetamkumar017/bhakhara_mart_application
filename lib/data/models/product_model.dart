import 'product_variant_model.dart';

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
  final bool isFavorite;
  final double averageRating;
  final int reviewCount;
  final List<ProductVariantModel> variants;

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
    this.isFavorite = false,
    this.averageRating = 4.8,
    this.reviewCount = 12,
    this.variants = const [],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final stock = double.tryParse(json['stock_qty']?.toString() ?? '0') ?? 0.0;
    final inStock = json['is_in_stock'] != null
        ? (json['is_in_stock'] == true || json['is_in_stock'].toString() == '1')
        : (stock > 0 || json['stock_qty'] == null);

    List<ProductVariantModel> varList = [];
    if (json['variants'] != null && json['variants'] is List) {
      varList = (json['variants'] as List)
          .map((v) => ProductVariantModel.fromJson(v))
          .toList();
    }

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
      isFavorite: json['is_favorite'] == true || json['is_favorite'].toString() == '1',
      averageRating: double.tryParse(json['average_rating']?.toString() ?? '4.8') ?? 4.8,
      reviewCount: int.tryParse(json['review_count']?.toString() ?? '12') ?? 12,
      variants: varList,
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
    bool? isFavorite,
    double? averageRating,
    int? reviewCount,
    List<ProductVariantModel>? variants,
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
      isFavorite: isFavorite ?? this.isFavorite,
      averageRating: averageRating ?? this.averageRating,
      reviewCount: reviewCount ?? this.reviewCount,
      variants: variants ?? this.variants,
    );
  }
}
