import 'package:get/get.dart';
import '../views/login_view.dart';
import '../views/signup_view.dart';
import '../views/home_view.dart';

/// AppRoutes - Centralized route configuration
/// All navigation routes are defined here for easy management
class AppRoutes {
  // Route name constants - prevents typos when navigating
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';

  // GetX page routes
  static final routes = [
    GetPage(name: login, page: () => LoginView()),
    GetPage(name: signup, page: () => SignupView()),
    GetPage(name: home, page: () => HomeView()),
  ];
}
