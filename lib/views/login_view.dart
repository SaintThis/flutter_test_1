import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/theme_controller.dart';
import '../routes/app_routes.dart';

/// LoginView - Login screen UI
/// This is the VIEW in MVC pattern - only handles UI, no business logic
class LoginView extends StatelessWidget {
  LoginView({super.key});

  // Get controllers using GetX dependency injection
  // Get.find() retrieves the controller that was registered in main.dart
  final AuthController _authController = Get.find<AuthController>();
  final ThemeController _themeController = Get.find<ThemeController>();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Local state for password visibility toggle
  final RxBool _obscurePassword = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        actions: [
          // Theme toggle button
          Obx(
            () => IconButton(
              onPressed: () => _themeController.toggleTheme(),
              icon: Icon(
                _themeController.isDarkMode.value
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              tooltip: 'Toggle Theme',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // App Icon
                Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),

                // Welcome Text
                Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // Username Field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  // Update controller value when text changes
                  onChanged: (value) => _authController.username.value = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password Field with visibility toggle
                Obx(
                  () => TextFormField(
                    obscureText: _obscurePassword.value,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      // Suffix icon to toggle password visibility
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () =>
                            _obscurePassword.value = !_obscurePassword.value,
                      ),
                    ),
                    onChanged: (value) =>
                        _authController.password.value = value,
                    validator: (value) =>
                        _authController.validatePassword(value),
                  ),
                ),
                const SizedBox(height: 24),

                // Login Button
                // Obx rebuilds when isLoading changes
                Obx(
                  () => ElevatedButton(
                    // Disable button when loading
                    onPressed: _authController.isLoading.value
                        ? null
                        : () async {
                            // Validate form first
                            if (_formKey.currentState!.validate()) {
                              final success = await _authController.login();
                              if (success) {
                                // Navigate to home and remove login from stack
                                Get.offAllNamed(AppRoutes.home);
                              }
                            }
                          },
                    child: _authController.isLoading.value
                        // Show loading indicator when loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Login'),
                  ),
                ),
                const SizedBox(height: 16),

                // Sign Up Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.signup),
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),

                // Test Credentials Info
                const SizedBox(height: 40),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Test Credentials',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        const Text('Username: emilys'),
                        const Text('Password: emilyspass'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
