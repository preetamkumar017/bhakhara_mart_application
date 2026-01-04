class CartItemModel {
  final String id;
  final String productId;
  final String name;
  final String unit;
  final double price;
  final double gst;
  final double quantity;
  final double subtotal;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.unit,
    required this.price,
    required this.gst,
    required this.quantity,
    required this.subtotal,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'].toString(),
      productId: json['product_id'].toString(),
      name: json['product_name'],
      unit: json['unit'],
      price: double.parse(json['sale_price']),
      gst: double.parse(json['gst_percent']),
      quantity: double.parse(json['quantity']),
      subtotal: double.parse(json['subtotal']),
    );
  }
}
