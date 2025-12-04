import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/auth_request_model.dart';

class ApiService {
  static const String _baseUrl = 'https://dummyjson.com';

  /// Login using the DummyJSON API
  Future<User> login(LoginRequest request) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Login failed');
    }
  }

  /// Signup - simulated since DummyJSON doesn't have a real signup endpoint
  /// For demo purposes, we'll just return a success if the fields are valid
  Future<User> signup(SignupRequest request) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // For demo, we'll simulate a successful signup by logging in with a test user
    // In a real app, this would POST to a signup endpoint
    final loginRequest = LoginRequest(
      username: 'emilys',
      password: 'emilyspass',
    );
    return login(loginRequest);
  }
}
