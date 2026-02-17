class RoutesName {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String search = '/search';
  static const String productDetail = '/product';
  static const String cart = '/cart';
  static const String profile = '/profile';
  static const String checkout = '/checkout';
  static const String addressManagement = '/address';
  static const String orders = '/orders';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsConditions = '/terms-conditions';
  static const String helpSupport = '/help-support';
  static String orderDetail(int orderId) => '/orders/$orderId';
}
