import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/auth_request_model.dart';

/// ApiService - Handles all HTTP API calls
/// Separated from controller following MVC pattern (Service layer)
class ApiService {
  // Base URL for DummyJSON API
  static const String _baseUrl = 'https://dummyjson.com';

  /// Login API call
  /// Returns User object on success, throws Exception on failure
  Future<User> login(LoginRequest request) async {
    // Make POST request to login endpoint
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()), // Convert request to JSON
    );

    // Check if request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse JSON response and create User object
      return User.fromJson(jsonDecode(response.body));
    } else {
      // Parse error message from response
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Login failed');
    }
  }

  /// Signup API call
  /// Note: DummyJSON doesn't have real signup endpoint
  /// This is simulated for demo purposes
  Future<User> signup(SignupRequest request) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // For demo: simulate signup by logging in with test credentials
    // In real app, this would POST to a signup endpoint
    final loginRequest = LoginRequest(
      username: 'emilys',
      password: 'emilyspass',
    );
    return login(loginRequest);
  }
}
