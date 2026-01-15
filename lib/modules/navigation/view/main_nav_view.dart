import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/view/home_view.dart';
import '../../search/view/search_view.dart';
import '../../cart/view/cart_view.dart';
import '../../profile/view/profile_view.dart';
import '../controller/nav_controller.dart';

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
        // bottomNavigationBar: NavigationBar(
        //   selectedIndex: idx,
        //   onDestinationSelected: controller.switchTab,
        //   destinations: const [
        //     NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
        //     NavigationDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search), label: 'Search'),
        //     NavigationDestination(
        //         icon: Icon(Icons.shopping_cart_outlined), selectedIcon: Icon(Icons.shopping_cart), label: 'Cart'),
        //     NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        //   ],
        // ),
      );
    });
  }
}

