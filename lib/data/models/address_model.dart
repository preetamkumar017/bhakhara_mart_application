class AddressModel {
  String id;
  String customerId;
  String addressLine1;
  String addressLine2;
  String city;
  String state;
  String pincode;
  String? latitude;
  String? longitude;
  String isDefault;
  final String createdAt;

  AddressModel({
    required this.id,
    required this.customerId,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    this.latitude,
    this.longitude,
    required this.isDefault,
    required this.createdAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic val) {
      if (val == null) return '';
      return val.toString();
    }

    return AddressModel(
      id: parseString(json['id']),
      customerId: parseString(json['customer_id']),
      addressLine1: parseString(json['address_line1']),
      addressLine2: parseString(json['address_line2']),
      city: parseString(json['city']),
      state: parseString(json['state']),
      pincode: parseString(json['pincode']),
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      isDefault: parseString(json['is_default']),
      createdAt: parseString(json['created_at']),
    );
  }

  /// Get full address as a formatted string
  String get fullAddress {
    final parts = [
      addressLine1,
      if (addressLine2.isNotEmpty) addressLine2,
      '$city, $state $pincode',
    ];
    return parts.where((e) => e.isNotEmpty).join('\n');
  }

  /// Get single line address
  String get shortAddress {
    final parts = [
      addressLine1,
      if (addressLine2.isNotEmpty) addressLine2,
      '$city - $pincode',
    ];
    return parts.where((e) => e.isNotEmpty).join(', ');
  }

  /// Check if this is the default address
  bool get isDefaultAddress => isDefault == '1';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
      'created_at': createdAt,
    };
  }
}

