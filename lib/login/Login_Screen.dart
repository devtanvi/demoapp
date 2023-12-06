import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/login/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../HomeScreen.dart';
import '../demo/constant.dart';
import '../demo/firebaseservice.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var emailFocus = FocusNode();
  var passwordFocus = FocusNode();

  var loading = false;

  void _loginWithFacebook() async {
    setState(() {
      loading = true;
    });
    try {
      final facebookLoginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();
      final facebookAuthCredential = FacebookAuthProvider.credential(
          facebookLoginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

      await FirebaseFirestore.instance.collection('users').add({
        'email': userData['email'],
        'imageUrl': userData['picture']['data']['url'],
        'name': userData['name'],
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => SignUp()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      var content = '';
      switch (e.code) {
        case 'account-exixts-with-different-credential':
          content = 'This account exists with a different sign in provider';
          break;
        case 'invalid-credential':
          content = 'unknown error has occurred';
          break;
        case 'operation-not-allowed':
          content = 'This operation is not allowed';
          break;
        case 'user-not-found':
          content = 'The user you tried to log into was not found';
          break;
      }
      // showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //           title: Text(content),
      //           actions: [
      //             TextButton(
      //                 onPressed: () {
      //                   Navigator.of(context).pop();
      //                 },
      //                 child: Text('ok'))
      //           ],
      //         ));
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<String?> getToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> logInUser(String? email, String? password,
      {String? DeviceType, String? DeviceId, String? DeviceToken}) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token').toString();
    var url = 'https://nyayasevak.com/NyayaSevak_API/u/_ul';
    final response = await http.post(Uri.parse(url), headers: {
      'Authorization': token,
    }, body: {
      "EmailId": emailController.text,
      "Password": passwordController.text,
      'Token': token,
      "DeviceType": 'Android',
      "DeviceId": '9717cd617e957de2',
      "DeviceToken":
          'f8Xv9s_4TXG_fp-TfRQvJ7%3AAPA91bELOWCosg-uC7KXMzAo7P5iqBN5TnUAWmaT8IOqP1ts32f0NSDJDGMjCBs7ZTF9pxAUGg-BkMdVgoqky7WsZ_pYhr2JuDqejEoJZxQuVP2R5-C5nt84PLJF1vdLJm6-voF9blLi'
    });
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['Success'] == 1) {
        print('tapped');
        getToken(token);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.black38,
              content: Text(
                'Logged in successfully',
                style: TextStyle(color: Colors.white, fontSize: 14),
              )),
        );
        print(response.body);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.black38,
              content: Text(
                'Something went Wrong',
                style: TextStyle(color: Colors.white, fontSize: 14),
              )),
        );
      }
    } else {
      throw Exception('Failed to create album.');
    }
  }

  final String apiUrl = 'https://dealkarde.com/dealkarde_api/p/_al';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Authorization Login',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.blue,
        ),
        body:  loading== true?
        Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        )
        :Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Text(
                      'Welcome',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 26,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Text(
                      'Sign In to Continue',
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: emailController,
                      focusNode: emailFocus,
                      onFieldSubmitted: (value) {
                        passwordFocus.requestFocus();
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Email"),
                      validator: (value) {
                        if (value!.isEmpty ||
                            !value.contains("@") ||
                            !value.contains('.')) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: passwordController,
                      focusNode: passwordFocus,
                      onFieldSubmitted: (value) {},
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Password"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 25.0),
                    child: Center(
                      child: SizedBox(
                        width: width / 1.5,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.lightBlueAccent.shade100),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              print('tap');
                              logInUser(emailController.text,
                                  passwordController.text);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please fill input')),
                              );
                            }
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              _loginWithFacebook();
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Image.asset("asset/image/fb.png",
                                  fit: BoxFit.fill),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GoogleSignIn(),
                          // InkWell(
                          //   onTap: () async {
                          //     GoogleSignIn();
                          //   },
                          //   child: Container(
                          //     height: 50,
                          //     width: 50,
                          //     child: Image.asset("asset/image/google.png",
                          //         fit: BoxFit.fill),
                          //   ),
                          // ),
                        ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DO Not Have Account ? ',
                          style: TextStyle(fontSize: 18, color: Colors.black26),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUp()));
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(fontSize: 18, color: Colors.blue),
                          ),
                        ),
                      ])
                ],
              ),
            ),
          ),
        )
   );
  }
}

class GoogleSignIn extends StatefulWidget {
  GoogleSignIn({Key? key}) : super(key: key);

  @override
  _GoogleSignInState createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return !isLoading
        ? SizedBox(
            width: size.width * 0.8,
            child: OutlinedButton.icon(
              icon: Icon(Icons.account_circle),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                FirebaseService service = new FirebaseService();
                try {
                  await service.signInwithGoogle();
                  Navigator.pushNamedAndRemoveUntil(
                      context, Constants.signUpNavigate, (route) => false);
                } catch (e) {
                  if (e is FirebaseAuthException) {
                    showMessage(e.message!);
                  }
                }
                setState(() {
                  isLoading = false;
                });
              },
              label: Text(
                Constants.textSignInGoogle,
                style: TextStyle(
                    color: Constants.kBlackColor, fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Constants.kGreyColor),
                  side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
            ),
          )
        : CircularProgressIndicator();
  }

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
