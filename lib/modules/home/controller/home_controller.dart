import 'package:bhakharamart/core/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/routes/routes_name.dart';

class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  final selectedCategoryIndex = 0.obs;
  final cartItemCount = 1.obs; // Dummy cart count

  late TabController tabController;

  final categories = [
    {'name': 'All', 'icon': Icons.shopping_basket},
    {'name': 'Kirana', 'icon': Icons.agriculture},
    {'name': 'Body Care', 'icon': Icons.face},
    {'name': 'Categories', 'icon': Icons.grid_view},
    {'name': 'Deals', 'icon': Icons.local_offer},
  ];

  final noodlesProducts = [
    {
      'id': 1,
      'name': 'Maggi 2 Minute Noodles Masala',
      'price': 87,
      'originalPrice': 90,
      'discount': '₹3 OFF',
      'weight': '420 g',
      'image': '',
      'category': 'Kirana',
    },
    {
      'id': 2,
      'name': "Ching's Hot & Sour Soup",
      'price': 30,
      'originalPrice': 60,
      'discount': '50% OFF',
      'weight': '55 g',
      'image': '',
      'category': 'Kirana',
    },
    {
      'id': 3,
      'name': 'Panda Treats Hakka Plain Noodles',
      'price': 137,
      'originalPrice': 180,
      'discount': '24% OFF',
      'weight': '1.2 kg',
      'image': '',
      'category': 'Kirana',
    },
    {
      'id': 4,
      'name': "Ching's Chutney",
      'price': 70,
      'originalPrice': 85,
      'discount': '18% OFF',
      'weight': '200 g',
      'image': '',
      'category': 'Kirana',
    },
  ];

  final handpickedProducts = [
    {
      'id': 5,
      'name': 'Amul Cow Pasteurized Milk',
      'price': 28,
      'offerPrice': 19,
      'weight': '500 ml',
      'image': '',
      'hasOffer': true,
      'category': 'Deals',
    },
    {
      'id': 6,
      'name': 'Amul Fresh Paneer',
      'price': 92,
      'offerPrice': 84,
      'weight': '200 g',
      'image': '',
      'hasOffer': true,
      'category': 'Deals',
    },
    {
      'id': 7,
      'name': 'Amul Masti Dahi',
      'price': 77,
      'weight': '1 kg',
      'image': '',
      'hasOffer': false,
      'category': 'Body Care',
    },
  ];

  final allProducts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: categories.length, vsync: this);
    allProducts.addAll(noodlesProducts);
    allProducts.addAll(handpickedProducts);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
    tabController.animateTo(index);
  }

  List<Map<String, dynamic>> getProductsForCategory(String categoryName) {
    if (categoryName == 'All') {
      return allProducts;
    }
    return allProducts.where((product) => product['category'] == categoryName).toList();
  }

  void openProduct(Map<String, dynamic> product) {
    Get.toNamed(RoutesName.productDetail, arguments: product);
  }

  void openCart() => Get.toNamed(RoutesName.cart);
  void openProfile() => Get.toNamed(RoutesName.profile);
  void openSearch() => Get.toNamed(RoutesName.search);

  void addToCart(Map<String, dynamic> product) {
    cartItemCount.value++;
    SnackBarUtils.showSuccess('${product['name']} has been added to your cart.');
  }
}
