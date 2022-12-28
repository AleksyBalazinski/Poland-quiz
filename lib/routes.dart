import 'package:flutter/material.dart';
import 'package:poland_quiz/pages/home_page.dart';
import 'package:poland_quiz/pages/login_screen.dart';
import 'package:poland_quiz/pages/register_screen.dart';

class AppRoutes {
  AppRoutes();

  static const String authLogin = '/auth-login';
  static const String authRegister = '/auth-register';
  static const String homePage = '/home';

  static Map<String, WidgetBuilder> define() {
    return {
      authLogin: (context) => const Login(),
      authRegister: (context) => const Register(),
      homePage: (context) => const HomePage(),
    };
  }
}
