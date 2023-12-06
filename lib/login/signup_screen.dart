import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../HomeScreen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final _signupFormKey = GlobalKey<FormState>();
  var emailFocus = FocusNode();
  var nameFocus = FocusNode();
  var passwordFocus = FocusNode();
  var mobileFocus = FocusNode();
  User? user = FirebaseAuth.instance.currentUser;

  // Future<Map<String, dynamic>> registerUser({
  //   String? fullName,
  //   String? email,
  //   String? contactNo,
  //   String? state,
  //   String? socialType,
  //   String? token,
  // }) async {
  //   Map<String, dynamic> data = {
  //     "FullName": nameController.text,
  //     "EmailId": emailController.text,
  //     "ContactNo": mobileNumberController.text,
  //     "State": 'Gujarat',
  //     "SocialType": '0',
  //     "Token": 'dgrtgbrtkrjsds',
  //   };
  //
  //   String jsonBody = jsonEncode(data);
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonBody,
  //     );
  //     print(data);
  //
  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> responseData = jsonDecode(response.body);
  //       print(response.body);
  //       return responseData;
  //     } else {
  //       print('error');
  //       throw Exception(
  //           'Failed to register. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Error: $e');
  //   }
  // }

  Future<void> storeAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<String?> getToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void newSignup({
    String? fullName,
    String? email,
    String? password,
    String? contactNo,
    String? state,
    String? Oauth,
    String? SocialType,
    String? DeviceId,
    String? DeviceToken,
    String? DeviceType,
    String? token,
  }) async {
    var token = 'iaw252TxPXy1R6a6cb778db06e76670e495718db148be9';
    var url = 'https://nyayasevak.com/NyayaSevak_API/u/_ur';
    if (SocialType == 'google' || SocialType == 'facebook') {
      emailController.text = email ?? '';
      nameController.text = fullName ?? '';
      mobileNumberController.text = contactNo ?? "";
    }
    final response = await http.post(
      Uri.parse(url),
      headers: {'Authorization': token},
      body: {
        "FullName": nameController.text,
        "EmailId": emailController.text,
        "Password": passwordController.text,
        "ContactNo": mobileNumberController.text,
        "State": 'gujarat',
        "Oauth": "",
        "SocialType": SocialType ?? '0',
        "DeviceId": "hjjbjb",
        "DeviceToken": "hdhdhhfh",
        "DeviceType": "android",
        'Token': 'bhvbhbhbhbhbh',
      },
    );
    print("Response: ${response.body}");
    if (response.statusCode == 200) {
      try {
        var res = json.decode(response.body);
        storeAuthToken(token);
        if (res['Success'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.black38,
              content: Text(
                'Signed up successfully',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.black38,
              content: Text(
                'Error: ${res['ErrorMessage']}',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          );
        }
      } catch (e) {
        print("Error decoding JSON: $e");
      }
    } else {
      print("Failed to create album. Status Code: ${response.statusCode}");
      throw Exception('Failed to create album.');
    }
  }

  // Future<UserData> fetchData() async {
  //   final response = await http.get(Uri.parse('YOUR_API_ENDPOINT_HERE'));
  //
  //   if (response.statusCode == 200) {
  //     return UserData.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }

  //
  // Future<UserData?> candidateAuth({required Map map}) async {
  //   String url = 'http://10.0.2.2:3000/v1/api/auth/candidate';
  //   var token = await getToken();
  //   await http
  //       .post(url as Uri,
  //       headers: {
  //         'Content-type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode(map))
  //       .then((response) {
  //     if (response.statusCode == 201) {
  //       token = UserData.fromJson(json.decode(response.body)).token;
  //       // Storage.setAuthToken(response.data["token"]);
  //       //setUser(UserData.fromJson(response.data["user"]));
  //       //UserData.setToken(token);
  //       return UserData.fromJson(json.decode(response.body));
  //     } else {
  //       throw Exception('Failed auth');
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    bool showPasswordField = !(user != null &&
        (user?.providerData[0].providerId == 'google.com' ||
            user?.providerData[0].providerId == 'facebook.com'));
    if (user != null &&
        (user?.providerData[0].providerId == 'google.com' ||
            user?.providerData[0].providerId == 'facebook.com')) {
      nameController.text = user?.displayName ?? '';
      emailController.text = user?.email ?? '';
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Sign up',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: InkWell(
          onTap: () {
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Form(
        key: _signupFormKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: nameController,
                    focusNode: nameFocus,
                    enabled: !(user != null &&
                        (user?.providerData[0].providerId == 'google.com' ||
                            user?.providerData[0].providerId ==
                                'facebook.com')),
                    onFieldSubmitted: (value) {
                      emailFocus.requestFocus();
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Full Name"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: emailController,
                    focusNode: emailFocus,
                    enabled: !(user != null &&
                        (user?.providerData[0].providerId == 'google.com' ||
                            user?.providerData[0].providerId ==
                                'facebook.com')),
                    onFieldSubmitted: (value) {
                      passwordFocus.requestFocus();
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Email"),
                    validator: (value) {
                      bool emailValid = RegExp(
                              r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                          .hasMatch(emailController.text);

                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      // if (emailValid) {
                      //   return 'Verify your EmailId';
                      // }
                      return null;
                    },
                  ),
                ),
                if (showPasswordField)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: passwordController,
                      focusNode: passwordFocus,
                      onFieldSubmitted: (value) {
                        mobileFocus.requestFocus();
                      },
                      // obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Password"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                // Padding(
                //   padding:
                //   const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                //   child: TextFormField(
                //     controller: confirmPasswordController,
                //     obscureText: true,
                //     decoration: const InputDecoration(
                //         border: OutlineInputBorder(),
                //         labelText: "Confirm Password"),
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'Please re-enter your password';
                //       }
                //       return null;
                //     },
                //   ),
                // ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: mobileNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Contact Number"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your contact Number';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                  child: Center(
                    child: SizedBox(
                      width: width / 1.5,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlueAccent.shade100),
                        onPressed: () {
                          if (_signupFormKey.currentState!.validate()) {
                            newSignup();
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
