import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PayInScreen extends StatefulWidget {
  @override
  _PayInScreenState createState() => _PayInScreenState();
}

class PayInList {
  var moneyRecieved;
  var date;

  PayInList({this.moneyRecieved, this.date});
}

class _PayInScreenState extends State<PayInScreen> {
  bool noProfilePic = false;
  bool showSpinner = false;
  String profilePicURL;
  PayInList payInListItem = PayInList(
    date: '03/11/2020',
    moneyRecieved: '3453.43',
  );

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
  }

  @override
  Widget build(BuildContext context) {
    List<PayInList> payInList = [
      payInListItem,
      payInListItem,
      payInListItem,
      payInListItem,
      payInListItem,
      payInListItem,
      payInListItem,
      payInListItem,
      payInListItem
    ];
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height / 30),
            showSpinner == true
                ? CircularProgressIndicator()
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
            ListView.builder(
              itemCount: payInList.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Recieved ₹${payInList[index].moneyRecieved} Salary',
                          style: TextStyle(
                              fontSize: width / 35,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: width / 45),
                      Text('Date: ${payInList[index].date}',
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
            )
          ],
        ),
      ),
    ));
  }
}
