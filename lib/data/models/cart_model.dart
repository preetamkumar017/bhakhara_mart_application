class CartItemModel {
  final String id;
  final String productId;
  final String name;
  final String unit;
  final double price;
  final double gst;
  final double quantity;
  final double subtotal;
  final String image;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.unit,
    required this.price,
    required this.gst,
    required this.quantity,
    required this.subtotal,
    required this.image,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic val) {
      if (val == null) return '';
      return val.toString();
    }
    
    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is double) return val;
      if (val is int) return val.toDouble();
      if (val is String && val.isNotEmpty) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    return CartItemModel(
      id: parseString(json['id']),
      productId: parseString(json['product_id']),
      name: parseString(json['product_name']),
      unit: parseString(json['unit']),
      price: parseDouble(json['sale_price']),
      gst: parseDouble(json['gst_percent']),
      quantity: parseDouble(json['quantity']),
      subtotal: parseDouble(json['subtotal']),
      image: parseString(json['image']),
    );
  }
}
