import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';
import '../models/auth_request_model.dart';
import '../services/api_service.dart';

/// AuthController - Handles all authentication logic
/// Extends GetxController for GetX state management
class AuthController extends GetxController {
  // API service instance for making HTTP requests
  final ApiService _apiService = ApiService();

  // GetStorage for local storage (saving token)
  final GetStorage _storage = GetStorage();

  // ============ OBSERVABLE STATE ============
  // These use .obs to make them reactive
  // When these values change, any Obx() widget watching them will rebuild

  // Current logged in user (null if not logged in)
  final Rx<User?> user = Rx<User?>(null);

  // Loading state - true when API call is in progress
  final RxBool isLoading = false.obs;

  // ============ FORM INPUT VALUES ============
  // Using RxString to store form input values reactively
  final RxString username = ''.obs;
  final RxString password = ''.obs;
  final RxString fullName = ''.obs;
  final RxString email = ''.obs;
  final RxString confirmPassword = ''.obs;

  // ============ STORAGE KEYS ============
  // Constants for storage keys - good practice to avoid typos
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  @override
  void onInit() {
    super.onInit();
    // Check if user is already logged in when app starts
    checkLoginStatus();
  }

  /// Check if user has saved session (auto-login feature)
  Future<void> checkLoginStatus() async {
    final storedToken = _storage.read(_tokenKey);
    final storedUser = _storage.read(_userKey);

    // If both token and user data exist, restore the session
    if (storedToken != null && storedUser != null) {
      user.value = User.fromJson(Map<String, dynamic>.from(storedUser));
    }
  }

  // ============ VALIDATION METHODS ============

  /// Validate email format
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Simple check: must contain @ and .
    if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email';
    }
    return null; // null means valid
  }

  /// Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validate confirm password matches
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password.value) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validate name is not empty
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  // ============ AUTHENTICATION METHODS ============

  /// Login method - calls API and saves session
  Future<bool> login() async {
    // Validate inputs first
    if (username.value.isEmpty || password.value.isEmpty) {
      // Show error snackbar using GetX
      Get.snackbar(
        'Error',
        'Please enter username and password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // Set loading to true - this will show loading indicator
    isLoading.value = true;

    try {
      // Create request object
      final request = LoginRequest(
        username: username.value,
        password: password.value,
      );

      // Call API
      final result = await _apiService.login(request);

      // Save user to state
      user.value = result;

      // Save to local storage for auto-login
      await _storage.write(_tokenKey, result.token);
      await _storage.write(_userKey, result.toJson());

      // Show success message
      Get.snackbar(
        'Success',
        'Welcome back, ${result.firstName}!',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      // Show error message
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      // Always set loading to false when done
      isLoading.value = false;
    }
  }

  /// Signup method
  Future<bool> signup() async {
    // Validate all fields
    if (fullName.value.isEmpty ||
        email.value.isEmpty ||
        password.value.isEmpty ||
        confirmPassword.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (password.value != confirmPassword.value) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    isLoading.value = true;

    try {
      final request = SignupRequest(
        fullName: fullName.value,
        email: email.value,
        password: password.value,
      );

      final result = await _apiService.signup(request);
      user.value = result;

      await _storage.write(_tokenKey, result.token);
      await _storage.write(_userKey, result.toJson());

      Get.snackbar(
        'Success',
        'Account created successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout - clear session data
  Future<void> logout() async {
    // Remove from local storage
    await _storage.remove(_tokenKey);
    await _storage.remove(_userKey);

    // Clear user state
    user.value = null;

    // Clear form fields
    username.value = '';
    password.value = '';
    fullName.value = '';
    email.value = '';
    confirmPassword.value = '';

    Get.snackbar(
      'Logged Out',
      'You have been logged out',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Check if user is currently logged in
  bool get isLoggedIn => user.value != null;
}
