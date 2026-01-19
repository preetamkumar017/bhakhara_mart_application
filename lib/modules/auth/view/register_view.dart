import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/components/custom_button.dart';
import '../../../res/components/custom_textfield.dart';
import '../controller/register_controller.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final RegisterController controller = Get.put(RegisterController());

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
                    // Back button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back_rounded),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // App logo or illustration
                    Center(
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(.1),
                        child: Icon(
                          Icons.person_add_alt_1_outlined,
                          size: 48,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Create Account!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Sign up to get started",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 28),

                    /// NAME
                    CustomTextField(
                      controller: controller.nameController,
                      hintText: 'Full Name',
                      keyboardType: TextInputType.name,
                    ),

                    const SizedBox(height: 16),

                    /// MOBILE NUMBER
                    CustomTextField(
                      controller: controller.mobileController,
                      hintText: 'Mobile Number',
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 16),

                    /// PASSWORD
                    CustomTextField(
                      controller: controller.passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),

                    const SizedBox(height: 16),

                    /// CONFIRM PASSWORD
                    CustomTextField(
                      controller: controller.confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true,
                    ),

                    const SizedBox(height: 24),

                    /// REGISTER BUTTON
                    Obx(() => CustomButton(
                          label: 'Create Account',
                          loading: controller.isLoading.value,
                          onPressed: controller.register,
                          fullWidth: true,
                        ),
                    ),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: controller.navigateToLogin,
                          child: Text(
                            'Login',
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

