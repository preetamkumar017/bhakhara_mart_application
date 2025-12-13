import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

class Utils {


  static void fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus)
  {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        // backgroundColor: AppColors.blackColor
    );
  }

  static void showSnackBar(BuildContext context, String message) {
      Get.snackbar(
      "Alert",
      message,
      snackPosition: SnackPosition.BOTTOM,
      // backgroundColor: AppColors.blackColor,
      // colorText: AppColors.whiteColor,
    );
  }


}
