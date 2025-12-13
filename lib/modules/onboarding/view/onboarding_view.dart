import 'package:bhakharamart/res/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/components/custom_button.dart';
import '../viewmodel/onboarding_controller.dart';

class OnboardingView extends StatelessWidget {
  OnboardingView({super.key});

  final OnboardingController controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              'assets/images/bhakharamart_logo.png',
              height: 160,
            ),
            const SizedBox(height: 24),
            Text('Fresh groceries at your doorstep',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 12),
            Text('Quality products, fast delivery, best prices.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            CustomButton(label: 'Get Started', onPressed: () => Get.toNamed(RoutesName.home)),
          ],
        ),
      ),
    );
  }
}

