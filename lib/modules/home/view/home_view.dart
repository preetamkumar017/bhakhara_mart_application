import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bhakharamart/core/themes/app_colors.dart';
import '../../../res/components/custom_button.dart';
import '../controller/home_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Section
            Container(
              color: AppColors.promoYellow.withOpacity(0.3),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  // Delivery Time & Location Row
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Delivery In',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.bolt,
                                color: AppColors.deliveryOrange,
                                size: 16,
                              ),
                              Text(
                                '13 Min',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.deliveryOrange,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'Krishna Nagar, Santoshi Nagar, Raipur...',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Gift Icon
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.card_giftcard,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'GIFT AT ₹1',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      // Profile Icon
                      IconButton(
                        onPressed: controller.openProfile,
                        icon: const Icon(Icons.person_outline),
                        color: AppColors.textPrimary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      onTap: controller.openSearch,
                      decoration: InputDecoration(
                        hintText: "Search for 'Milk'",
                        hintStyle: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.textSecondary,
                        ),
                        suffixIcon: const Icon(
                          Icons.mic,
                          color: AppColors.textSecondary,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Category Tabs
            TabBar(
              controller: controller.tabController,
              isScrollable: true,
              tabs: controller.categories.map((category) {
                return Tab(
                  icon: Icon(category['icon'] as IconData),
                  text: category['name'] as String,
                );
              }).toList(),
            ),
            // Product Sections
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: controller.categories.map((category) {
                  final categoryName = category['name'] as String;
                  final products = controller.getProductsForCategory(categoryName);
                  return CategoryTabBody(products: products);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      // Bottom Cart Bar
      bottomNavigationBar: Obx(
        () => controller.cartItemCount.value > 0
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_up,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${controller.cartItemCount.value} Item',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      CustomButton(
                        label: 'View Cart',
                        onPressed: controller.openCart,
                        fullWidth: false,
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class CategoryTabBody extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const CategoryTabBody({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text('No products in this category yet.'),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(product: product);
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return GestureDetector(
      onTap: () => controller.openProduct(product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.card.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image and Discount
            Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  // You can add an Image.network(product['image']) here
                  // when you have image URLs.
                  child: const Center(
                      child: Icon(Icons.image_outlined, color: Colors.grey)),
                ),
                if (product['discount'] != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      product['discount'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            // Product Details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['weight'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Price and Add Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${product['price']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (product['originalPrice'] != null)
                            Text(
                              '₹${product['originalPrice']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => controller.addToCart(product),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text('ADD'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
