import 'package:demoapp/demo/constant.dart';
import 'package:demoapp/product/product_Listing.dart';
import 'package:flutter/material.dart';
import 'demo/firebaseservice.dart';
import 'imageUpload/image_uploading.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        FirebaseService service = new FirebaseService();
        await service.signOutFromGoogle();
        Navigator.pushReplacementNamed(context, Constants.signInNavigate);
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully Logout'),
          ),
        );
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Are you sure Want to LogOut?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("HomeScreen"),
          backgroundColor: Colors.blue,
          leading: Icon(
            Icons.menu_outlined,
            size: 25,
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout,
                size: 25,
              ),
              color: Colors.black,
              onPressed: () async {
                showAlertDialog(context);
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    Text("USER EMAIL:${user!.email!}"),
                    Text("USER NAME:${user!.displayName!}"),
                    // Text("USER CONTACT:${user!.phoneNumber}"),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(user!.photoURL!),
                  radius: 20,
                )
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductList()
                          // ImageUploadScreen()
                          ));
                },
                child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    color: Colors.blue,
                    child: Text("Product List")),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageUploadScreen()));
                },
                child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    color: Colors.blue,
                    child: Text("Image upload")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
