import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genie_cart_delivery/Screens/RegistrationAndLogin/registration_screen.dart';
import 'package:genie_cart_delivery/Screens/RegistrationAndLogin/waiting_screen.dart';
import 'package:genie_cart_delivery/Utility/useful_methods.dart';

import '../bottom_navigation_bar_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailEntered = TextEditingController();
  TextEditingController passwordEntered = TextEditingController();
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 70),
              Container(height: 200, width:200,child: Image.asset('assets/images/logo.jpeg')),
              SizedBox(height: 30),
              Center(
                  child: Text('LOGIN',
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 20,
                          fontWeight: FontWeight.bold))),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  maxLines: 1,
                  controller: emailEntered,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[300], width: 2.0),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      filled: true,
                      isDense: true,
                      contentPadding: EdgeInsets.all(20),
                      hintStyle:
                          TextStyle(color: Colors.grey[500], fontSize: 12),
                      hintText: 'Email ID',
                      fillColor: Colors.grey[300]),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  maxLines: 1,
                  controller: passwordEntered,
                  obscureText: true,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[300], width: 2.0),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      filled: true,
                      isDense: true,
                      contentPadding: EdgeInsets.all(20),
                      hintStyle:
                          TextStyle(color: Colors.grey[500], fontSize: 12),
                      hintText: 'Password',
                      fillColor: Colors.grey[300]),
                ),
              ),
              SizedBox(height: 50),
              showSpinner == false
                  ? GestureDetector(
                      onTap: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: emailEntered.text,
                                  password: passwordEntered.text);

                          setState(() {
                            showSpinner = false;
                          });

                          bool verified = false;
                          await FirebaseFirestore.instance
                              .collection("deliveryPerson")
                              .doc(emailEntered.text)
                              .get()
                              .then((value) {
                            verified = value.data()["verified"];
                          });

                          if (verified == true)
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        BottomNavigationBarScreen()));
                          else
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        WaitingScreen()));
                        } on FirebaseAuthException catch (e) {
                          print(e);

                          UsefulMethods()
                              .showToast("Please enter correct credentials");
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        height: 50,
                        width: 300,
                        child: Center(
                            child: Text('Login',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10))),
                      ),
                    )
                  : CircularProgressIndicator(),
              SizedBox(height: 100),
              Center(
                  child: Text(
                "Don't have an account?",
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
              )),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              RegistrationScreen()));
                },
                child: Center(
                    child: Text(
                  "Create account",
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.blue[300],
                      decoration: TextDecoration.underline),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
