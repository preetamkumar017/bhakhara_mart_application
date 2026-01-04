import 'package:bhakharamart/modules/product/view/product_card.dart';
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
            _buildHeader(),
            _buildCategoryStrip(),
            Expanded(child: _buildProductGrid()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomCartBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onTap: controller.openSearch,
        decoration: const InputDecoration(
          hintText: "Search for products",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildCategoryStrip() {
    return Obx(() {
      if (controller.isCategoryLoading.value) {
        return const SizedBox(
          height: 50,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      return SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length,
          itemBuilder: (_, index) {
            final category = controller.categories[index];
            final isSelected =
                controller.selectedCategoryId.value == category.id;

            return GestureDetector(
              onTap: () => controller.selectCategory(category.id),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    category.name,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildProductGrid() {
    return Obx(() {
      if (controller.isProductLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.products.isEmpty) {
        return const Center(child: Text('No products found'));
      }

      return GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.65,
        ),
        itemCount: controller.products.length,
        itemBuilder: (_, index) {
          final product = controller.products[index];
          return ProductCard(product: product);
        },
      );
    });
  }

  Widget _buildBottomCartBar() {
    return Obx(() {
      if (controller.cartItemCount == 0) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              '${controller.cartItemCount} items',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            CustomButton(
              label: 'View Cart',
              onPressed: controller.openCart,
              fullWidth: false,
            ),
          ],
        ),
      );
    });
  }
}
