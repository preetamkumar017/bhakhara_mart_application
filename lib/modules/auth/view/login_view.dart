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
      backgroundColor: const Color(0xFFF6F8FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // App logo or illustration
                    Center(
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(.1),
                        child: Icon(
                          Icons.lock_outline_rounded,
                          size: 48,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Welcome Back!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Login to your account",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 28),

                    /// MOBILE NUMBER
                    CustomTextField(
                      controller: controller.mobileController..text = '9999999999',
                      hintText: 'Mobile Number',
                      keyboardType: TextInputType.phone,
                      // RESOLVED: Remove unsupported prefixIcon, instead wrap in InputDecoration
                      // decoration: InputDecoration(
                      //   prefixIcon: const Icon(Icons.phone_android_rounded),
                      // ),
                    ),

                    const SizedBox(height: 16),

                    /// PASSWORD
                    CustomTextField(
                      controller: controller.passwordController..text = 'password',
                      hintText: 'Password',
                      obscureText: true,
                      // RESOLVED: Remove unsupported prefixIcon, instead wrap in InputDecoration
                      // decoration: InputDecoration(
                      //   prefixIcon: const Icon(Icons.lock_outline_rounded),
                      // ),
                    ),

                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          // Add logic for forgot password (if available)
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// LOGIN BUTTON
                    Obx(() => CustomButton(
                          label: 'Continue',
                          loading: controller.isLoading.value,
                          onPressed: controller.login,
                          fullWidth: true,
                          // RESOLVED: Remove unsupported style param. Add borderRadius inside button if needed.
                        ),
                    ),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            // Navigate to register page
                            Get.toNamed('/register');
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
