import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bhakharamart/core/themes/app_colors.dart';
import 'package:bhakharamart/modules/product/view/product_card.dart';
import '../../../res/components/custom_button.dart';
import '../controller/home_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isCategoryLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return DefaultTabController(
        length: controller.tabs.length,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Bhakharamart'),
            actions: [
              /// Profile Icon - Navigate to Profile Screen
              IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: () => Get.toNamed('/profile'),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔍 SEARCH FUNCTIONALITY
                _buildHeader(),
                const SizedBox(height: 8),
                _buildTabBar(),
                Expanded(child: _buildTabBarView()),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomCartBar(),
        ),
      );
    });
  }

  // 🔍 SEARCH FUNCTIONALITY
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: controller.openSearch,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey[600]),
              const SizedBox(width: 12),
              Text(
                "Search for products",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 Category as TAB (UI same chip style)
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TabBar(
        isScrollable: true,
        indicatorColor: Colors.transparent,
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
        tabs: controller.tabs.map((tab) {
          return Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // No boxShadow here (shadow removed)
              ),
              child: Text(tab.name),
            ),
          );
        }).toList(),
        onTap: controller.onTabChanged,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textPrimary,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        dividerColor: Colors.transparent, // Remove the line
      ),
    );
  }

  /// 🔥 Products change with tab
  Widget _buildTabBarView() {
    return TabBarView(
       physics: const NeverScrollableScrollPhysics(), 
      children: controller.tabs.map((tab) {
        return Obx(() {
          if (controller.isProductLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = controller.productsMap[tab.id] ?? [];

          if (products.isEmpty) {
            return const Center(child: Text("No products found"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemCount: products.length,
            itemBuilder: (_, index) {
              return ProductCard(product: products[index]);
            },
          );
        });
      }).toList(),
    );
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
