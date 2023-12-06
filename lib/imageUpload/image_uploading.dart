import 'dart:convert';
import 'dart:io';
import 'package:demoapp/login/Login_Screen.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? imageFile;
  bool isLoading = false;

  // This function will be called when the button gets pressed
  _startLoading() {}

  //final picker = ImagePicker();

  Future cameraImage() async {
    // try {
    //   final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    //
    //   if (image == null) return;
    //
    //   final imageTemp = File(image.path);
    //
    //   setState(() => this.image = imageTemp);
    // } on PlatformException catch (e) {
    //   print('Failed to pick image: $e');
    // }
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future galleryImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // Future<void> uploadImage() async {
  //   var imagePath = imageFile.toString();
  //   print('imagePath:${imagePath}');
  //   final url = Uri.parse(
  //       'https://aticsdigital.com/add-FDS-info'); // Replace with your API endpoint URL
  //   var token = '6d2286301265512f019781cc0ce7a39f';
  //   //String selectedImage = base64Encode(File(image!.path).readAsBytesSync());
  //
  //   // var bytes = await rootBundle.load(image!.path);
  //   // var buffer = bytes.buffer;
  //   // var imageBytes =
  //   //     buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  //
  //   // Encode the bytes
  //   // var base64Image = base64Encode(imageBytes);
  //   // print(base64Image);
  //   //  if (image == null) return;
  //   // String base64Image = base64Encode(image!.readAsBytesSync());
  //   // String fileName = image!.path;
  //   // var takenPicture = await http.MultipartFile.fromPath("image", image!.path);
  //   //  request.files.add(takenPicture);
  //
  //   // Map<String, dynamic> mapData = {
  //   //
  //   // };
  //
  //   final response = await http.post(url, headers: {
  //     'Authorization': token, // Adjust the headers as needed
  //   }, body: {
  //     "FDS_id": "3081",
  //     "bin_id": "3224",
  //     "client_id": "0",
  //     "user_id": "11",
  //     "shift_id": "89",
  //     "inTime": "08-28-2022 18:35:44",
  //     "outTime": "08-28-2022 18:55:44",
  //     "BinInNo": "1234",
  //     "BinOutNo": "6789",
  //     "work_type": "1,4",
  //     "other": "524",
  //     "notes": "notes",
  //     "signature": dio.MultipartFile.fromFile(imagePath).toString(),
  //     "latitude": "21.1930366",
  //     "longitude": "72.7987687",
  //     "feedback": "GOOD",
  //     "feedbackTime": "0000-00-00 00:00:00",
  //     "created_at": "2023-10-12 11:16:22",
  //   });
  //
  //   if (response.statusCode == 200) {
  //     print('dio image:${dio.MultipartFile.fromFile(imagePath).toString()}');
  //     print(imageFile);
  //     final result = json.decode(response.body);
  //
  //     if (result['Success'] == 1) {
  //       print('Response data: ${response.body}');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //             backgroundColor: Colors.black38,
  //             content: Text(
  //               'UPLOADED successfully',
  //               style: TextStyle(color: Colors.white, fontSize: 14),
  //             )),
  //       );
  //       print(response.body);
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => LoginScreen()));
  //     } else {
  //       print('dio image${dio.MultipartFile.fromFile(imagePath).toString()}');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //             backgroundColor: Colors.black38,
  //             content: Text(
  //               'something wrong',
  //               style: TextStyle(color: Colors.white, fontSize: 14),
  //             )),
  //       );
  //       print('error');
  //       print('Response data: ${response.body}');
  //     }
  //     // return result;
  //   }
  // }

  Future<void> uploadFile() async {
    setState(() {
      isLoading = true;
    });
    String path = imageFile!.path;
    print('tap');
    Map<String, String> data = {
      "FDS_id": "3081",
      "bin_id": "3224",
      "client_id": "0",
      "user_id": "11",
      "shift_id": "89",
      "inTime": "08-28-2022 18:35:44",
      "outTime": "08-28-2022 18:55:44",
      "BinInNo": "1234",
      "BinOutNo": "6789",
      "work_type": "1,4",
      "other": "524",
      "notes": "notes",
      "latitude": "21.1930366",
      "longitude": "72.7987687",
      "signature": path,
      "feedback": "",
      "feedbackTime": "0000-00-00 00:00:00",
      "created_at": "2023-10-12 11:16:22",
    };

    String token = '6d2286301265512f019781cc0ce7a39f';
    Map<String, String> headers = {'authorization': token};

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://aticsdigital.com/add-FDS-info'),
    );
    request.fields.addAll(data);
    request.headers.addAll(headers);
    var multipartFile = await http.MultipartFile.fromPath('signature', path);
    request.files.add(multipartFile);
    http.StreamedResponse response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      print('tapped');
      var jsonData = json.decode(respStr);
      print(respStr);
      print('successfully uploaded');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.black38,
            content: Text(
              'UPLOADED successfully',
              style: TextStyle(color: Colors.white, fontSize: 14),
            )),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.black38,
            content: Text(
              'Something wrong',
              style: TextStyle(color: Colors.white, fontSize: 14),
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Image Uploading Screen'),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
              ))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      cameraImage();
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50.0, vertical: 5),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black26)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Select Image from Camera',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Icon(
                                Icons.camera_alt,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      galleryImage();
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50.0, vertical: 5),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black26)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Select Image from Gallery',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Icon(
                                Icons.photo,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  imageFile != null
                      ? Container(
                          height: 400,
                          width: 600,
                          child: Image.file(imageFile!))
                      : Text("No image selected"),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: SizedBox(
                      width: width / 1.8,
                      height: 60,
                      child: ElevatedButton(
                        style: imageFile != null
                            ? ElevatedButton.styleFrom(
                                primary: Colors.lightBlueAccent.shade100)
                            : ElevatedButton.styleFrom(
                                primary: Colors.grey.shade500),
                        onPressed: () {
                          if (imageFile != null) {
                            isLoading
                                ? const CircularProgressIndicator()
                                : uploadFile();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  backgroundColor: Colors.black38,
                                  content: Text(
                                    'Please Select Image First',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  )),
                            );
                          }
                        },
                        child: const Text(
                          'Upload',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }
}
