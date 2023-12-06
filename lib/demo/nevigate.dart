import 'package:demoapp/demo/welcome.dart';
import 'package:demoapp/login/signup_screen.dart';
import 'package:flutter/material.dart';
import '../HomeScreen.dart';
import '../login/Login_Screen.dart';

class Navigate {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => WelcomePage(),
    '/Sign-up':(context)=>SignUp(),
    '/sign-in': (context) => LoginScreen(),
    '/home': (context) => HomeScreen()
  };
}
