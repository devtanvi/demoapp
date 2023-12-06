import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import  'demo/nevigate.dart';
import 'demo/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey:
            // Platform.isIOS
            //     ? "AIzaSyAzhGoDXBfLiKkeONWupbLdO6drXaTvXUg"
            //    :
            'AIzaSyBFDN4I5Xhj931oz2YqWPI5SZ0eADF5zIQ',
        appId:
            // Platform.isIOS
            //     ? "1:1064436075526:ios:381ef332fd713810290787"
            //     :
            "1:949962791384:android:f00137d70779b4eba13aad",
        authDomain: "demoapp-2ff9b.appspot.com",
        messagingSenderId: '949962791384',
        storageBucket: "demoapp-2ff9b.appspot.com",
        projectId: 'demoapp-2ff9b'),
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // Future<void> main() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var status = prefs.getBool('isLoggedIn') ?? false;
  //   print(status);
  //   runApp(MaterialApp(home: status == true ? Login() : Home()));
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    User? result = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      title: Constants.title,
      initialRoute: '/',
      routes: Navigate.routes,
      // home: Lo routes: Navigate.routes,ginScreen(),
      // ProductList(),
    );
  }
}
