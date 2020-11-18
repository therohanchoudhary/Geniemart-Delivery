import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:genie_cart_delivery/Utility/useful_methods.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePicture extends StatefulWidget {
  @override
  _EditProfilePictureState createState() => _EditProfilePictureState();
}

class _EditProfilePictureState extends State<EditProfilePicture> {
  String profilePicURL;
  bool showSpinner = false;
  File newProfilePic;

  bool noProfilePic = false;

  Future _getImage() async {
    try {
      profilePicURL = await FirebaseStorage.instance
          .ref()
          .child(
              'deliveryPerson/passportPic/${FirebaseAuth.instance.currentUser.email}')
          .getDownloadURL();
      if (mounted) setState(() {});
    } catch (e) {
      setState(() {
        noProfilePic = true;
      });
      print(noProfilePic);
      print(e);
    }
  }

  Future _getImageFile() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      newProfilePic = File(image.path);
    });
  }

  @override
  void initState() {
    super.initState();
    _getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile Picture')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text('Current Profile Picture',
                          style: TextStyle(fontSize: 12)),
                      SizedBox(height: 20),
                      profilePicURL == null
                          ? noProfilePic == true
                              ? Container(
                                  height: 200,
                                  width: 200,
                                  child: Image.network(
                                      'https://moonvillageassociation.org/wp-content/uploads/2018/06/default-profile-picture1.jpg'),
                                )
                              : CircularProgressIndicator()
                          : Container(
                              height: 200,
                              width: 200,
                              child: Image.network(profilePicURL)),
                    ],
                  ),
                  newProfilePic != null
                      ? Column(
                          children: [
                            Text('New Profile Picture',
                                style: TextStyle(fontSize: 12)),
                            SizedBox(height: 20),
                            newProfilePic == null
                                ? CircularProgressIndicator()
                                : Container(
                                    height: 200,
                                    width: 200,
                                    child: Image.file(newProfilePic)),
                          ],
                        )
                      : SizedBox(width: 0),
                ],
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _getImageFile,
                child: Text('Choose new profile picture',
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline)),
              ),
              SizedBox(height: 20),
              showSpinner == false
                  ? GestureDetector(
                      onTap: () async {
                        if (newProfilePic != null) {
                          setState(() {
                            showSpinner = true;
                          });
                          StorageReference firebaseStorage =
                              FirebaseStorage.instance.ref().child(
                                  'deliveryPerson/passportPic/${FirebaseAuth.instance.currentUser.email}');
                          StorageUploadTask uploadTask =
                              firebaseStorage.putFile(newProfilePic);

                          await uploadTask.onComplete;
                          setState(() {
                            showSpinner = false;
                          });
                          UsefulMethods().showToast(
                              "Passport picture changed successfully.");
                        } else {
                          UsefulMethods()
                              .showToast("Passport picture not changed");
                        }
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 60,
                        width: 300,
                        padding: EdgeInsets.all(20),
                        child: Center(
                            child: Text('Upload my new Passport Picture now',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12))),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(1000)),
                      ),
                    )
                  : CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
