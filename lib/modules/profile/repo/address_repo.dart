import 'package:bhakharamart/data/models/address_model.dart';
import 'package:bhakharamart/data/network/api_endpoints.dart';
import 'package:bhakharamart/data/network/network_api_services.dart';

class AddressRepo {
  final _api = NetworkApiServices();

  /// Fetch all addresses for the logged-in customer
  /// 
  /// Returns list of [AddressModel]
  /// Throws exception on API error
  Future<List<AddressModel>> fetchAddresses() async {
    final response = await _api.getApi(ApiEndpoints.addresses);
    
    if (response['status'] == true && response['data'] != null) {
      final List list = response['data'];
      return list.map((e) => AddressModel.fromJson(e)).toList();
    } else {
      throw Exception(response['message'] ?? 'Failed to fetch addresses');
    }
  }

  /// Add a new address
  /// 
  /// Returns the newly created [AddressModel]
  Future<AddressModel> addAddress({
    required String addressLine1,
    required String addressLine2,
    required String city,
    required String state,
    required String pincode,
    String? latitude,
    String? longitude,
  }) async {
    final response = await _api.postApi(
      ApiEndpoints.addressAdd,
      {
        'address_line1': addressLine1,
        'address_line2': addressLine2,
        'city': city,
        'state': state,
        'pincode': pincode,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      },
    );

    if (response['status'] == true) {
      // Check if response has data, otherwise refresh addresses list
      if (response['data'] != null) {
        return AddressModel.fromJson(response['data']);
      }
      // Return a placeholder - actual address will be fetched on refresh
      throw Exception('Address added but details not returned');
    } else {
      throw Exception(response['message'] ?? 'Failed to add address');
    }
  }

  /// Set an address as default
  Future<bool> setDefaultAddress(int addressId) async {
    final response = await _api.postApi(
      ApiEndpoints.addressSetDefault,
      {'address_id': addressId},
    );

    return response['status'] == true;
  }

  /// Delete an address
  Future<bool> deleteAddress(int addressId) async {
    final response = await _api.postApi(
      ApiEndpoints.addressDelete,
      {'address_id': addressId},
    );

    return response['status'] == true;
  }

  /// Update an existing address
  /// 
  /// [addressId] - Required: The ID of the address to update
  /// [addressLine1] - Primary address line (optional)
  /// [addressLine2] - Secondary address line (optional)
  /// [city] - City name (optional)
  /// [state] - State name (optional)
  /// [pincode] - 6-digit pincode (optional)
  /// [latitude] - GPS latitude (optional)
  /// [longitude] - GPS longitude (optional)
  /// 
  /// Returns updated [AddressModel] on success
  /// Throws exception on validation error or API error
  Future<AddressModel> updateAddress({
    required int addressId,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? pincode,
    String? latitude,
    String? longitude,
  }) async {
    // Validate addressId is provided
    if (addressId <= 0) {
      throw Exception('address_id required');
    }

    // Build update payload with only provided fields
    final Map<String, dynamic> payload = {'address_id': addressId};
    
    if (addressLine1 != null) payload['address_line1'] = addressLine1;
    if (addressLine2 != null) payload['address_line2'] = addressLine2;
    if (city != null) payload['city'] = city;
    if (state != null) payload['state'] = state;
    if (pincode != null) payload['pincode'] = pincode;
    if (latitude != null) payload['latitude'] = latitude;
    if (longitude != null) payload['longitude'] = longitude;

    final response = await _api.postApi(
      ApiEndpoints.addressUpdate,
      payload,
    );

    if (response['status'] == true) {
      if (response['data'] != null) {
        return AddressModel.fromJson(response['data']);
      } else {
        // If no data returned, throw exception
        throw Exception('Address updated but details not returned');
      }
    } else {
      throw Exception(response['message'] ?? 'Failed to update address');
    }
  }
}

