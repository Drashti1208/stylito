import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/app_bindings.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

import 'services/hive_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveStorageService.init();
  runApp(const StylishApp());
}

class StylishApp extends StatelessWidget {
  const StylishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Stylish',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
