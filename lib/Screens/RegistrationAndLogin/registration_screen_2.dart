import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:genie_cart_delivery/Utility/useful_methods.dart';
import 'package:image_picker/image_picker.dart';

import 'login_screen.dart';

class RegistrationScreen2 extends StatefulWidget {
  final String email;
  final String password;

  RegistrationScreen2({this.email, this.password});

  @override
  _RegistrationScreen2State createState() => _RegistrationScreen2State();
}

class _RegistrationScreen2State extends State<RegistrationScreen2> {
  bool _showProgressIndicator = false;

  File _passportSizeImage;
  TextEditingController accountNumberEntered = TextEditingController();
  TextEditingController ifscCodeEntered = TextEditingController();
  TextEditingController licenseNumberEntered = TextEditingController();
  TextEditingController panCardEntered = TextEditingController();

  Future _getImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _passportSizeImage = File(image.path);
    });
  }

  Future _uploadImage() async {
    String fileName = 'deliveryPerson/passportPic/${widget.email}';
    StorageReference firebaseStorage =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorage.putFile(_passportSizeImage);

    await uploadTask.onComplete;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Container(height: 200, width:200,child: Image.asset('assets/images/logo.jpeg')),
                SizedBox(height: 30),
                Text('FORM',
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                SizedBox(height: 40),
                inputTextField('Account Number', 80, 1, TextInputType.name,
                    accountNumberEntered),
                inputTextField(
                    'IFSC Code', 80, 1, TextInputType.name, ifscCodeEntered),
                inputTextField('Driving License Number', 80, 1,
                    TextInputType.name, licenseNumberEntered),
                inputTextField(
                    'Pan Card', 80, 1, TextInputType.name, panCardEntered),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      _getImage();
                    },
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(40)),
                      child: _passportSizeImage == null
                          ? Center(
                              child: Text('Upload Passport size Photo',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue)))
                          : Container(
                              padding: EdgeInsets.all(20),
                              height: 150,
                              width: 300,
                              child: Image.file(_passportSizeImage)),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                _showProgressIndicator == false
                    ? GestureDetector(
                        onTap: () async {
                          try {
                            setState(() {
                              _showProgressIndicator = true;
                            });
                            if (accountNumberEntered.text.length > 1 &&
                                ifscCodeEntered.text.length > 1 &&
                                licenseNumberEntered.text.length > 1 &&
                                panCardEntered.text.length > 1 &&
                                _passportSizeImage != null) {
                              await FirebaseFirestore.instance
                                  .collection('deliveryPerson')
                                  .doc(widget.email)
                                  .update({
                                "accountNumber": accountNumberEntered.text,
                                "ifscCode": ifscCodeEntered.text,
                                "drivingLicenseNumber":
                                    licenseNumberEntered.text,
                                "panCard": panCardEntered.text,
                              });

                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: widget.email,
                                      password: widget.password);
                              _uploadImage();
                            } else {
                              UsefulMethods().showToast(_passportSizeImage !=
                                      null
                                  ? 'Please enter correct & complete credentials'
                                  : 'Profile Picture not uploaded');
                            }
                            setState(() {
                              _showProgressIndicator = false;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginScreen()));
                          } catch (e) {
                            UsefulMethods().showToast('$e');
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.blue,
                          ),
                          child: Center(
                            child: Text(
                              'Request',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      )
                    : CircularProgressIndicator(),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
