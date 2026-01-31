import 'package:bhakharamart/data/models/customer_model.dart';
import 'package:bhakharamart/data/network/api_endpoints.dart';
import 'package:bhakharamart/data/network/network_api_services.dart';

class ProfileRepo {
  final _api = NetworkApiServices();

  /// Fetch customer profile data
  /// 
  /// Returns [CustomerModel] on success
  /// Throws exception on API error
  Future<CustomerModel> getProfile() async {
    try {
      final response = await _api.getApi(ApiEndpoints.customerProfile);
      
      if (response['status'] == true && response['data'] != null) {
        return CustomerModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch profile');
      }
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  /// Update customer profile
  /// 
  /// [name] - Customer full name (min 2 chars)
  /// [email] - Email address (valid format)
  /// [alternateMobile] - Alternate mobile (10 digits)
  /// [profileImage] - Profile image path
  /// [dateOfBirth] - DOB in YYYY-MM-DD format
  /// [gender] - male/female/other/prefer_not_to_say
  /// 
  /// All parameters are optional - only include fields you want to update
  /// 
  /// Returns updated [CustomerModel] on success
  /// Throws exception on validation error or API error
  Future<CustomerModel> updateProfile({
    String? name,
    String? email,
    String? alternateMobile,
    String? profileImage,
    String? dateOfBirth,
    String? gender,
  }) async {
    // Build update payload with only provided fields
    final Map<String, dynamic> payload = {};
    
    if (name != null) payload['name'] = name;
    if (email != null) payload['email'] = email;
    if (alternateMobile != null) payload['alternate_mobile'] = alternateMobile;
    if (profileImage != null) payload['profile_image'] = profileImage;
    if (dateOfBirth != null) payload['date_of_birth'] = dateOfBirth;
    if (gender != null) payload['gender'] = gender;

    // Validate that at least one field is provided
    if (payload.isEmpty) {
      throw Exception('No data provided for update');
    }

    try {
      final response = await _api.putApi(
        ApiEndpoints.customerProfile,
        payload,
      );

      if (response['status'] == true) {
        if (response['data'] != null) {
          return CustomerModel.fromJson(response['data']);
        } else {
          // If no data returned, fetch updated profile
          return await getProfile();
        }
      } else {
        // Handle validation errors
        final message = response['message'] ?? 'Failed to update profile';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}

