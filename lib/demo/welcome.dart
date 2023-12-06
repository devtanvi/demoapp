import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constant.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  User? result = FirebaseAuth.instance.currentUser;

  void initState() {
    super.initState();
    new Future.delayed(
        const Duration(seconds: 2),
        () => result == null
            ? Navigator.pushNamed(context, Constants.signInNavigate)
            : Navigator.pushReplacementNamed(context, Constants.homeNavigate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.kPrimaryColor,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Constants.statusBarColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_grocery_store,
                  size: 150,
                  color: Colors.black,
                ),
                Text(
                  'My STORE',
                  style: TextStyle(fontSize: 22, color: Colors.black),
                )
              ],
            ),
          ),
        ));
  }
}
