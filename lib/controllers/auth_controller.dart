import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';
import '../models/auth_request_model.dart';
import '../services/api_service.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  final GetStorage _storage = GetStorage();

  // Observable state
  final Rx<User?> user = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Form controllers (using simple observable strings)
  final RxString username = ''.obs;
  final RxString password = ''.obs;
  final RxString fullName = ''.obs;
  final RxString email = ''.obs;
  final RxString confirmPassword = ''.obs;

  // Storage keys
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  /// Check if user is already logged in
  Future<void> checkLoginStatus() async {
    final storedToken = _storage.read(_tokenKey);
    final storedUser = _storage.read(_userKey);

    if (storedToken != null && storedUser != null) {
      user.value = User.fromJson(Map<String, dynamic>.from(storedUser));
    }
  }

  /// Validate email format
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email';
    }
    return null;
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

  /// Validate confirm password
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password.value) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validate name
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  /// Login method
  Future<bool> login() async {
    if (username.value.isEmpty || password.value.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter username and password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final request = LoginRequest(
        username: username.value,
        password: password.value,
      );

      final result = await _apiService.login(request);
      user.value = result;

      // Store token and user data
      await _storage.write(_tokenKey, result.token);
      await _storage.write(_userKey, result.toJson());

      Get.snackbar(
        'Success',
        'Welcome back, ${result.firstName}!',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
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
        'Validation Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (password.value != confirmPassword.value) {
      Get.snackbar(
        'Validation Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (password.value.length < 6) {
      Get.snackbar(
        'Validation Error',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final request = SignupRequest(
        fullName: fullName.value,
        email: email.value,
        password: password.value,
      );

      final result = await _apiService.signup(request);
      user.value = result;

      // Store token and user data
      await _storage.write(_tokenKey, result.token);
      await _storage.write(_userKey, result.toJson());

      Get.snackbar(
        'Success',
        'Account created successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout method
  Future<void> logout() async {
    await _storage.remove(_tokenKey);
    await _storage.remove(_userKey);
    user.value = null;

    // Clear form fields
    username.value = '';
    password.value = '';
    fullName.value = '';
    email.value = '';
    confirmPassword.value = '';

    Get.snackbar(
      'Logged Out',
      'You have been logged out successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Check if user is logged in
  bool get isLoggedIn => user.value != null;
}
