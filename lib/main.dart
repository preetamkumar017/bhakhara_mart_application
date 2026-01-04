import 'package:bhakharamart/core/bindings/app_binding.dart';
import 'package:bhakharamart/res/getx_localization/languages.dart';
import 'package:bhakharamart/res/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/themes/app_theme.dart';
import 'res/routes/routes_name.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(), // ✅ IMPORTANT LINE
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: RoutesName.splash,
      translations: Languages(),
      locale: const Locale('hi', 'IN'),
      fallbackLocale: const Locale('en', 'US'),
      getPages: AppRoutes.appRoutes(),
    );
  }
}
