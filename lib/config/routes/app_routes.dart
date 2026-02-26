import 'package:flutter/material.dart';
import '../../presentation/screens/home_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {home: (context) => const HomeScreen()};

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: Center(child: Text('No route defined for ${settings.name}'))),
        );
    }
  }
}
