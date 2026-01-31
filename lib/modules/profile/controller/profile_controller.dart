import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../res/routes/routes_name.dart';
import '../../../modules/cart/controller/cart_controller.dart';
import '../repo/profile_repo.dart';
import '../../../data/models/customer_model.dart';
import '../../../core/utils/snackbar.dart';

class ProfileController extends GetxController {
  final ProfileRepo _profileRepo = ProfileRepo();

  // Loading states
  final isLoading = false.obs;
  final isUpdating = false.obs;

  // Profile data
  final customer = CustomerModel(
    id: '',
    name: '',
    mobile: '',
    email: '',
    isActive: '0',
    createdAt: '',
    updatedAt: '',
  ).obs;

  // Error state
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  /// Fetch customer profile from API
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final profile = await _profileRepo.getProfile();
      customer.value = profile;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      SnackBarUtils.showError('Failed to load profile: $errorMessage');
    } finally {
      isLoading.value = false;
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
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? alternateMobile,
    String? profileImage,
    String? dateOfBirth,
    String? gender,
  }) async {
    try {
      isUpdating.value = true;
      
      final updatedProfile = await _profileRepo.updateProfile(
        name: name,
        email: email,
        alternateMobile: alternateMobile,
        profileImage: profileImage,
        dateOfBirth: dateOfBirth,
        gender: gender,
      );
      
      customer.value = updatedProfile;
      SnackBarUtils.showSuccess('Profile updated successfully');
      return true;
    } catch (e) {
      final error = e.toString().replaceAll('Exception: ', '');
      SnackBarUtils.showError(error);
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  /// Refresh profile data
  Future<void> refreshProfile() async {
    await fetchProfile();
  }

  /// Get customer name or default
  String get customerName => customer.value.name.isEmpty 
      ? 'User' 
      : customer.value.name;

  /// Get customer email
  String get customerEmail => customer.value.email;

  /// Get customer mobile
  String get customerMobile => customer.value.mobile;

  /// Check if profile is loaded
  bool get hasProfile => customer.value.id.isNotEmpty;

  /// Logout user
  void logout() {
    // Clear user info
    customer.value = CustomerModel(
      id: '',
      name: '',
      mobile: '',
      email: '',
      isActive: '0',
      createdAt: '',
      updatedAt: '',
    );

    // Clear storage
    final storage = GetStorage();
    storage.erase();

    // Remove all non-permanent Getx controllers
    Get.deleteAll(force: false);

    // Re-initialize CartController since it was deleted
    Get.put(CartController(), permanent: true);

    // Navigate to login page
    Get.offAllNamed(RoutesName.login);
  }
}
