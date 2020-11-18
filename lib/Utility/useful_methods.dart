import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UsefulMethods {
  void showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 12.0);
  }
}
inputTextField(String hintText, double height, int maxLines, var keyboardType,
    var controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18.0),
    child: Container(
      height: height,
      child: TextField(
        obscureText: hintText == 'Password',
        maxLines: hintText == 'Address' ? 4 : maxLines,
        controller: controller,
        keyboardType: keyboardType,
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
            hintText: hintText,
            fillColor: Colors.grey[300]),
      ),
    ),
  );
}