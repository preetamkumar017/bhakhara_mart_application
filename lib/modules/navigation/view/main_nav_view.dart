import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/view/home_view.dart';
import '../../search/view/search_view.dart';
import '../../cart/view/cart_view.dart';
import '../../profile/view/profile_view.dart';
import '../controller/nav_controller.dart';
import '../../../core/themes/app_colors.dart';

class MainNavView extends StatelessWidget {
  MainNavView({super.key});

  final NavController controller = Get.put(NavController());
  final pages = [HomeView(), SearchView(), CartView(), ProfileView()];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final idx = controller.currentIndex.value;
      return Scaffold(
        body: IndexedStack(
          index: idx,
          children: pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: NavigationBar(
            selectedIndex: idx,
            onDestinationSelected: controller.switchTab,
            backgroundColor: Colors.white,
            indicatorColor: AppColors.primary.withValues(alpha: 0.12),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home, color: AppColors.primary),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search, color: AppColors.primary),
                label: 'Search',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_cart_outlined),
                selectedIcon: Icon(Icons.shopping_cart, color: AppColors.primary),
                label: 'Cart',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person, color: AppColors.primary),
                label: 'Profile',
              ),
            ],
          ),
        ),
      );
    });
  }
}

