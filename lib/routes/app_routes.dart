import 'package:get/get.dart';
import '../views/login_view.dart';
import '../views/signup_view.dart';
import '../views/home_view.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';

  static final routes = [
    GetPage(name: login, page: () => LoginView()),
    GetPage(name: signup, page: () => SignupView()),
    GetPage(name: home, page: () => HomeView()),
  ];
}
