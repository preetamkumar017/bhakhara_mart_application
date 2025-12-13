import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/splash_controller.dart';

class SplashView extends StatelessWidget {
  SplashView({super.key});

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/bhakharamart_logo.png',
              height: 140,
            ),
            const SizedBox(height: 12),
            const SizedBox(height: 8),
            Text('Grocery, fast delivery', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

