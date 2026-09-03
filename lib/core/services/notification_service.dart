import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../data/network/api_endpoints.dart';
import '../../data/network/network_api_services.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final NetworkApiServices _api = NetworkApiServices();

  /// Register device FCM token with Bhakhra Mart backend
  Future<void> registerDeviceToken(String fcmToken, {String deviceType = 'android'}) async {
    try {
      if (fcmToken.isEmpty) return;

      final res = await _api.postApi(
        ApiEndpoints.fcmToken,
        {
          'fcm_token': fcmToken,
          'device_type': deviceType,
        },
      );

      if (kDebugMode) {
        debugPrint('[NotificationService] Device token registered: ${res['status']}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[NotificationService] Failed to register FCM token: $e');
      }
    }
  }

  /// Show in-app banner alert for order updates
  void showOrderAlert({required String title, required String message}) {
    Fluttertoast.showToast(
      msg: "$title\n$message",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
    );
  }
}
