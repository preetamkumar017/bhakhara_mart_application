import 'package:get/get.dart';

class Languages extends Translations{
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'hello': 'Hello',
      'internet_exception':'No Internet Connection',
      'try_again':'Try Again'
    },
    'hi_IN': {
      'hello': 'नमस्ते',
      'internet_exception':'कोई इंटरनेट कनेक्शन नहीं है',
      'try_again':'पुनः प्रयास करें'
    },

  };

}