import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:genie_cart_delivery/Screens/RegistrationAndLogin/registration_screen_2.dart';
import 'package:genie_cart_delivery/Utility/useful_methods.dart';

import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _showProgressIndicator = false;

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameEntered = TextEditingController();
    TextEditingController emailEntered = TextEditingController();
    TextEditingController mobileNumberEntered = TextEditingController();
    TextEditingController passwordEntered = TextEditingController();
    TextEditingController addressEntered = TextEditingController();
    TextEditingController idProofEntered = TextEditingController();

    final databaseReference = FirebaseFirestore.instance;
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
                inputTextField(
                    'User Name', 80, 1, TextInputType.name, usernameEntered),
                inputTextField('Email Id', 80, 1, TextInputType.emailAddress,
                    emailEntered),
                inputTextField('Mobile Number', 80, 1, TextInputType.number,
                    mobileNumberEntered),
                inputTextField('Password', 80, 1, TextInputType.visiblePassword,
                    passwordEntered),
                inputTextField(
                    'Address', 160, 4, TextInputType.multiline, addressEntered),
                SizedBox(height: 20),
                inputTextField(
                    'ID Proof', 80, 1, TextInputType.name, idProofEntered),
                SizedBox(height: 30),
                _showProgressIndicator == false
                    ? GestureDetector(
                        onTap: () async {
                          var allUsers = await FirebaseFirestore.instance
                              .collection('deliveryPerson')
                              .get();

                          try {
                            setState(() {
                              _showProgressIndicator = true;
                            });

                            if (passwordEntered.text.length > 6 &&
                                usernameEntered.text.length > 1 &&
                                emailEntered.text.length > 1 &&
                                mobileNumberEntered.text.length == 10 &&
                                addressEntered.text.length > 1 &&
                                idProofEntered.text.length > 1) {
                              await databaseReference
                                  .collection('deliveryPerson')
                                  .doc(emailEntered.text.toString())
                                  .set({
                                "name": usernameEntered.text,
                                "email": emailEntered.text,
                                "mobileNumber": mobileNumberEntered.text,
                                "address": addressEntered.text,
                                "password": passwordEntered.text,
                                "verified": false,
                                "id":
                                    "${(allUsers.docs.length * 5) + 30000009}",
                                "idProof":idProofEntered.text,
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          RegistrationScreen2(
                                              email: emailEntered.text,
                                              password: passwordEntered.text)));
                            } else {
                              if (passwordEntered.text.length < 7)
                                UsefulMethods().showToast(
                                    'Please enter a strong password');
                              else
                                UsefulMethods().showToast(
                                    'Please enter complete credentials');
                            }
                          } catch (e) {
                            UsefulMethods()
                                .showToast("Please enter correct credentials.");
                          }
                          setState(() {
                            _showProgressIndicator = false;
                          });
                        },
                        child: Container(
                            height: 50,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.blue,
                            ),
                            child: Center(
                                child: Text('Continue',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15)))))
                    : CircularProgressIndicator(),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen())),
                  child: Text(
                    'Already have an account? Login',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
