class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}

class SignupRequest {
  final String fullName;
  final String email;
  final String password;

  SignupRequest({
    required this.fullName,
    required this.email,
    required this.password,
  });

  // Note: This is for the simulation or if we were sending to a real endpoint
  Map<String, dynamic> toJson() {
    return {'fullName': fullName, 'email': email, 'password': password};
  }
}
