// import 'package:demoapp/HomeScreen.dart';
// import 'package:demoapp/login/signup_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class WelcomePage extends StatelessWidget {
//   static const statusBarColor = SystemUiOverlayStyle(
//       statusBarColor: Colors.blue,
//       statusBarIconBrightness: Brightness.dark);
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery
//         .of(context)
//         .size;
//     User? result = FirebaseAuth.instance.currentUser;
//     return Scaffold(
//         backgroundColor:  Colors.blue,
//         body: AnnotatedRegion<SystemUiOverlayStyle>(
//             value: statusBarColor,
//             child:  Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             //Image.asset("assets/images/main-img.png"),
//             SizedBox(
//               width: size.width * 0.8,
//               child: OutlinedButton(
//                 onPressed: () {
//                   result == null
//                       ? Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()))
//                       : Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
//                 },
//                 child: Text("start"),
//                 style: ButtonStyle(
//                     foregroundColor: MaterialStateProperty.all<Color>(
//                        Colors.blueAccent),
//                     backgroundColor: MaterialStateProperty.all<Color>(
//                         Colors.black),
//                     side: MaterialStateProperty.all<BorderSide>(
//                         BorderSide.none)),
//               ),
//             ),
//             SizedBox(
//               width: size.width * 0.8,
//               child: OutlinedButton(
//                 onPressed: () {
//
//                 },
//                 child: Text(
//                  "test test",
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all<Color>(
//                         Colors.grey),
//                     side: MaterialStateProperty.all<BorderSide>(
//                         BorderSide.none)),
//               ),
//             )
//           ],
//         ),
//         )
//     );
//   }
// }