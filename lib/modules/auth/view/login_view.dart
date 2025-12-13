import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/components/custom_button.dart';
import '../../../res/components/custom_textfield.dart';
import '../controller/login_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Welcome back', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 24),
            CustomTextField(
              controller: controller.emailController,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: controller.passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 24),
            Obx(() => CustomButton(
                  label: 'Continue',
                  loading: controller.isLoading.value,
                  onPressed: controller.login,
                )),
          ],
        ),
      ),
    );
  }
}

