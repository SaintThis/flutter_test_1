import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'controllers/auth_controller.dart';
import 'controllers/theme_controller.dart';
import 'routes/app_routes.dart';

/// Main entry point of the application
void main() async {
  // Ensure Flutter is initialized before async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage for local data persistence
  await GetStorage.init();

  // Register controllers using GetX dependency injection
  // Get.put() makes the controller available globally via Get.find()
  Get.put(ThemeController());
  Get.put(AuthController());

  runApp(const MyApp());
}

/// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the theme controller to watch for theme changes
    final themeController = Get.find<ThemeController>();

    // Obx rebuilds when isDarkMode changes
    return Obx(
      () => GetMaterialApp(
        title: 'Flutter Auth Demo',
        debugShowCheckedModeBanner: false,

        // Light theme configuration
        theme: ThemeController.lightTheme,

        // Dark theme configuration
        darkTheme: ThemeController.darkTheme,

        // Current theme mode based on controller state
        themeMode: themeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,

        // Initial route - check if user is already logged in
        initialRoute: _getInitialRoute(),

        // All available routes
        getPages: AppRoutes.routes,
      ),
    );
  }

  /// Determine initial route based on login status
  String _getInitialRoute() {
    final authController = Get.find<AuthController>();
    // If user is logged in, go to home; otherwise go to login
    return authController.isLoggedIn ? AppRoutes.home : AppRoutes.login;
  }
}
