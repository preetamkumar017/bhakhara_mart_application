class ApiEndpoints {
  static const String domain = "https://bhakharamart.com";
  static const String baseUrl = "$domain/api/";

  // Auth
  static const String login = "${baseUrl}customer/login";
  static const String register = "${baseUrl}customer/register";
  static const String refreshToken = "${baseUrl}customer/refresh";
  static const String logout = "${baseUrl}customer/logout";

  // Customer Profile
  static const String customerProfile = "${baseUrl}customer/profile";

  // Products & Categories
  static const String products = "${baseUrl}products";
  static const String categories = "${baseUrl}categories";
  static String categoryProducts(int categoryId) => "${baseUrl}categories/$categoryId/products";

  static String productsByCategory(String categoryId) {
    return '$baseUrl/categories/$categoryId/products';
  }

  // Search & Suggestions
  static const String productsSuggest = "${baseUrl}products/suggest";
  static String productsSearch(String query, int page, int limit) =>
      "${baseUrl}products/search?q=$query&page=$page&limit=$limit";

  // Inventory
  static const String inventory = "${baseUrl}inventory";
  static String inventoryProduct(int productId) => "${baseUrl}inventory/product/$productId";

  // Cart
  static const String cart = "${baseUrl}cart";
  static const String cartAdd = "${baseUrl}cart/add";
  static const String cartUpdate = "${baseUrl}cart/update";
  static const String cartRemove = "${baseUrl}cart/remove";

  // Orders
  static const String orderPlace = "${baseUrl}order/place";
  static const String orders = "${baseUrl}orders";
  static String orderDetail(int orderId) => "${baseUrl}orders/$orderId";

  // Order Tracking & Invoices
  static String orderStatus(int orderId) => "${baseUrl}order/$orderId/status";
  static String orderInvoice(int orderId) => "${baseUrl}order/$orderId/invoice";
  static String orderInvoicePdf(int orderId) => "${baseUrl}order/$orderId/invoice-pdf";

  // Address Management
  static const String addresses = "${baseUrl}addresses";
  static const String addressAdd = "${baseUrl}addresses/add";
  static const String addressUpdate = "${baseUrl}addresses/update";
  static const String addressSetDefault = "${baseUrl}addresses/set-default";
  static const String addressDelete = "${baseUrl}addresses/delete";
}
