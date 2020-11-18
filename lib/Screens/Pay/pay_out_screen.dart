import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PayOutScreen extends StatefulWidget {
  @override
  _PayOutScreenState createState() => _PayOutScreenState();
}

class PayOutList {
  var moneyRecieved;
  var paymentMode;

  var orderNumber;

  PayOutList({this.moneyRecieved, this.paymentMode, this.orderNumber});
}

class _PayOutScreenState extends State<PayOutScreen> {
  bool noProfilePic = false;
  bool showSpinner = false;
  bool showListSpinner = false;
  String profilePicURL;
  List<PayOutList> payOutList = [];

  Future _getData() async {
    setState(() {
      showListSpinner = true;
    });
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("deliveryLog").get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i].data();
      if (a["deliveryStatus"].toString().toLowerCase() == "delivered" &&
          a["deliveryPerson"] == FirebaseAuth.instance.currentUser.email) {
        payOutList.add(PayOutList(
            orderNumber: a["orderNumber"],
            moneyRecieved: a["price"],
            paymentMode: a["paymentMode"]));
      }
    }
    setState(() {
      showListSpinner = false;
    });
  }

  Future _getImage() async {
    setState(() {
      showSpinner = true;
    });
    try {
      profilePicURL = await FirebaseStorage.instance
          .ref()
          .child(
              'deliveryPerson/passportPic/${FirebaseAuth.instance.currentUser.email}')
          .getDownloadURL();
    } catch (e) {
      setState(() {
        noProfilePic = true;
      });
      print(noProfilePic);
      print(e);
    }
    setState(() {
      showSpinner = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getImage();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height / 30),
            showSpinner == true
                ? Center(child: CircularProgressIndicator())
                : Center(
                    child: Container(
                        width: height / 6,
                        height: height / 6,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(noProfilePic == false
                                    ? profilePicURL
                                    : "https://moonvillageassociation.org/wp-content/uploads/2018/06/default-profile-picture1.jpg")))),
                  ),
            SizedBox(height: height / 20),
            showListSpinner == true
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: payOutList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Recieved ₹${payOutList[index].moneyRecieved} from Order# ${payOutList[index].orderNumber}',
                                style: TextStyle(
                                    fontSize: width / 35,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: width / 45),
                            Text(
                                'Payment Mode: ${payOutList[index].paymentMode}',
                                style: TextStyle(fontSize: width / 45)),
                            SizedBox(height: width / 25),
                            Container(
                                height: 0.2,
                                width: double.infinity,
                                color: Colors.blue),
                            SizedBox(height: width / 25),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    ));
  }
}
