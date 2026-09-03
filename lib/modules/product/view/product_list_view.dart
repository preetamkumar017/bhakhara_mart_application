import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bhakharamart/core/themes/app_colors.dart';
import 'package:bhakharamart/data/models/product_model.dart';
import 'package:bhakharamart/modules/cart/controller/cart_controller.dart';
import 'package:bhakharamart/modules/product/controller/product_controller.dart';
import 'package:bhakharamart/modules/product/view/product_card.dart';
import 'package:bhakharamart/modules/product/widgets/product_filter_bottom_sheet.dart';
import 'package:bhakharamart/res/routes/routes_name.dart';

class ProductListView extends StatelessWidget {
  ProductListView({super.key});

  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map? ?? {};
    final String categoryId = args['categoryId']?.toString() ?? '1';
    final String categoryName = args['categoryName']?.toString() ?? 'Products';

    controller.loadProducts(categoryId);
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(RoutesName.cart),
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart_outlined),
                Obx(() => cartController.totalItems > 0
                    ? Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${cartController.totalItems}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink()),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          /// Filter & Sort Action Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withValues(alpha: 0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                /// Filter Button
                InkWell(
                  onTap: () {
                    ProductFilterBottomSheet.show(
                      context: context,
                      initialOptions: controller.filterOptions.value,
                      onApply: (applied) => controller.applyFilters(applied),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: controller.filterOptions.value.hasActiveFilters
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: controller.filterOptions.value.hasActiveFilters
                            ? AppColors.primary
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.tune,
                          size: 16,
                          color: controller.filterOptions.value.hasActiveFilters
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: controller.filterOptions.value.hasActiveFilters
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                /// Quick Sort Chips
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(() {
                      final curSort = controller.filterOptions.value.sortBy;
                      return Row(
                        children: [
                          _buildQuickSortChip('Price: Low', 'price_asc', curSort, categoryId),
                          const SizedBox(width: 6),
                          _buildQuickSortChip('Price: High', 'price_desc', curSort, categoryId),
                          const SizedBox(width: 6),
                          _buildQuickSortChip('Newest', 'newest', curSort, categoryId),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          /// Products Grid / List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.error.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(controller.error.value, style: const TextStyle(color: AppColors.textSecondary)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => controller.loadProducts(categoryId),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                );
              }

              if (controller.products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      const Text(
                        'No products found in this category',
                        style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.products.length,
                itemBuilder: (_, index) {
                  final ProductModel product = controller.products[index];
                  return ProductCard(product: product);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSortChip(String label, String sortKey, String currentSort, String categoryId) {
    final isSelected = currentSort == sortKey;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.background,
      labelStyle: TextStyle(
        fontSize: 11,
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (selected) {
        final newFilters = controller.filterOptions.value;
        newFilters.sortBy = selected ? sortKey : 'newest';
        controller.applyFilters(newFilters);
      },
    );
  }
}
