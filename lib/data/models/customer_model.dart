/// Customer Model representing the customer profile data from API
class CustomerModel {
  final String id;
  final String name;
  final String mobile;
  final String email;
  final String? alternateMobile;
  final String? profileImage;
  final String? dateOfBirth;
  final String? gender;
  final String isActive;
  final String createdAt;
  final String updatedAt;

  CustomerModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    this.alternateMobile,
    this.profileImage,
    this.dateOfBirth,
    this.gender,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Parse string value from dynamic
  static String _parseString(dynamic val) {
    if (val == null) return '';
    return val.toString();
  }

  /// Create CustomerModel from JSON response
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: _parseString(json['id']),
      name: _parseString(json['name']),
      mobile: _parseString(json['mobile']),
      email: _parseString(json['email']),
      alternateMobile: json['alternate_mobile']?.toString(),
      profileImage: json['profile_image']?.toString(),
      dateOfBirth: json['date_of_birth']?.toString(),
      gender: json['gender']?.toString(),
      isActive: _parseString(json['is_active']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
    );
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'email': email,
      'alternate_mobile': alternateMobile,
      'profile_image': profileImage,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Get profile image URL with base domain
  String? get fullProfileImage {
    if (profileImage == null || profileImage!.isEmpty) return null;
    if (profileImage!.startsWith('http')) return profileImage;
    // Prepend domain if path starts with /
    return 'https://bhakharamart.com$profileImage';
  }

  /// Check if customer is active
  bool get isActiveCustomer => isActive == '1' || isActive == 'true' || isActive == '1.0';

  /// Get formatted date of birth
  String? get formattedDOB {
    if (dateOfBirth == null || dateOfBirth!.isEmpty) return null;
    try {
      final date = DateTime.parse(dateOfBirth!);
      return '${date.day}-${date.month}-${date.year}';
    } catch (_) {
      return dateOfBirth;
    }
  }

  /// Get display gender (capitalized first letter)
  String? get displayGender {
    if (gender == null || gender!.isEmpty) return null;
    return '${gender![0].toUpperCase()}${gender!.substring(1).toLowerCase()}';
  }

  /// Create a copy with updated fields
  CustomerModel copyWith({
    String? id,
    String? name,
    String? mobile,
    String? email,
    String? alternateMobile,
    String? profileImage,
    String? dateOfBirth,
    String? gender,
    String? isActive,
    String? createdAt,
    String? updatedAt,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      alternateMobile: alternateMobile ?? this.alternateMobile,
      profileImage: profileImage ?? this.profileImage,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

