import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constants {
  static const kPrimaryColor = Color(0xFFFFFFFF);
  static const kGreyColor = Color(0xFFEEEEEE);
  static const kBlackColor = Color(0xFF000000);
  static const kDarkGreyColor = Color(0xFF9E9E9E);
  static const kDarkBlueColor = Color(0xFF6057FF);
  static const kBorderColor = Color(0xFFEFEFEF);
  static const title = "Google Sign In";
  static const textSignInGoogle = "Sign In With Google";
  static const signInNavigate = '/sign-in';
  static const homeNavigate = '/home';
  static const signUpNavigate = '/Sign-up';

  static const statusBarColor = SystemUiOverlayStyle(
      statusBarColor: Constants.kPrimaryColor,
      statusBarIconBrightness: Brightness.dark);
}
