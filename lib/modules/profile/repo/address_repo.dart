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
}

