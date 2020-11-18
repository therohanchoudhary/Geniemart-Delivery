import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genie_cart_delivery/Utility/useful_methods.dart';

class EditProfileStrings extends StatefulWidget {
  final String attribute;
  final String hintText;
  final TextInputType keyboardType;
  final int length;

  EditProfileStrings({this.attribute, this.hintText, this.keyboardType,this.length});

  @override
  _EditProfileStringsState createState() => _EditProfileStringsState();
}

class _EditProfileStringsState extends State<EditProfileStrings> {
  TextEditingController controller = TextEditingController();
  bool showSpinner = false;
  var currentValue;

  Future _getData() async {
    await FirebaseFirestore.instance
        .collection("deliveryPerson")
        .doc("${FirebaseAuth.instance.currentUser.email}")
        .get()
        .then((value) {
      setState(() {
        currentValue = value.data()[widget.attribute];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hintText),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current ${widget.attribute.toUpperCase()} is '),
            currentValue != null
                ? Text(currentValue,
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold))
                : CircularProgressIndicator(),
            SizedBox(height: 40),
            TextField(
              maxLines: widget.attribute == "address" ? 4 : 1,
             maxLength:widget.length,
              controller: controller,
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300], width: 5.0),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  filled: true,
                  isDense: true,
                  contentPadding: EdgeInsets.all(20),
                  hintStyle: TextStyle(color: Colors.grey[800], fontSize: 12),
                  hintText: widget.hintText,
                  fillColor: Colors.grey[300]),
            ),
            SizedBox(height: 40),
            showSpinner == false
                ? GestureDetector(
                    onTap: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      if (controller.text != "" && controller.text != null) {
                        await FirebaseFirestore.instance
                            .collection('deliveryPerson')
                            .doc(FirebaseAuth.instance.currentUser.email)
                            .update({"${widget.attribute}": controller.text});
                        UsefulMethods().showToast(
                            "${widget.attribute.toUpperCase()} changed successfully to ${controller.text}.");
                      } else {
                        UsefulMethods().showToast(
                            "${widget.attribute.toUpperCase()} not changed because no value was entered.");
                      }
                      print(controller.text);
                      setState(() {
                        showSpinner = false;
                      });

                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 80,
                      width: 300,
                      padding: EdgeInsets.all(20),
                      child: Center(
                          child: Text(
                              'Change my ${widget.attribute.toUpperCase()} now',
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
    );
  }
}
