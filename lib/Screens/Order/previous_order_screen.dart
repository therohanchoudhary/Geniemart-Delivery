import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:genie_cart_delivery/Screens/Order/tab_bar_order.dart';

class PreviousOrderScreen extends StatefulWidget {
  @override
  _PreviousOrderScreenState createState() => _PreviousOrderScreenState();
}

class _PreviousOrderScreenState extends State<PreviousOrderScreen> {
  List<OrderList> previousOrderList = [];

  bool _noDelivery = false;
  var email = FirebaseAuth.instance.currentUser.email;

  Future _getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("deliveryLog").get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i].data();

      var shopName, shopAddress;
      await FirebaseFirestore.instance
          .collection('registerSeller')
          .doc("${a["sellerEmail"]}")
          .get()
          .then((value) {
        shopName = value.data()["ownerName"];
        shopAddress = value.data()["address"];
      });

      if (a["deliveryStatus"].toString().toLowerCase() == "delivered" &&
          "${a["deliveryPerson"]}" == "$email") {
        var sellerImage;
        try {
          sellerImage = await FirebaseStorage.instance
              .ref()
              .child('seller/profilePic/${a["sellerEmail"]}')
              .getDownloadURL();
        } catch (e) {
          print(e);
        }
        previousOrderList.add(OrderList(
          customerAddress: a["customerAddress"],
          customerName: a["customerName"],
          deliveryPerson: a["deliveryPerson"],
          deliveryStatus: a["deliveryStatus"],
          orderNumber: a["orderNumber"].toString(),
          paymentMode: a["paymentMode"],
          productName: a["productName"],
          sellerImage: sellerImage,
          seller: a["seller"],
          sellerEmail: a["sellerEmail"],
          shopName: shopName,
          shopAddress: shopAddress,
        ));
        setState(() {});
      }
    }
    if (previousOrderList.length == 0)
      setState(() {
        _noDelivery = true;
      });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: _noDelivery == true
          ? Center(child: Text('No Previous Deliveries'))
          : ListView.builder(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: previousOrderList.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: height / 40),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 0.5),
                            borderRadius: BorderRadius.circular(height / 90)),
                        height: height / 2.4,
                        width: width,
                        padding: EdgeInsets.symmetric(
                            vertical: height / 32, horizontal: width / 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                'Order #${previousOrderList[index].orderNumber}',
                                style: TextStyle(
                                    fontSize: height / 90, color: Colors.grey)),
                            SizedBox(height: height / 80),
                            Text('Delivery Date',
                                style: TextStyle(
                                    fontSize: height / 90, color: Colors.grey)),
                            SizedBox(height: height / 80),
                            Text(
                                '${previousOrderList[index].productName.toUpperCase()}',
                                style: TextStyle(
                                    fontSize: height / 60,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: height / 40),
                            Row(children: [
                              previousOrderList[index].sellerImage == null
                                  ? Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black),
                                      padding: EdgeInsets.all(height / 200),
                                      child: Icon(Icons.person,
                                          color: Colors.white,
                                          size: height / 30))
                                  : Container(
                                      height: height / 9,
                                      width: width / 9,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  previousOrderList[index]
                                                      .sellerImage)))),
                              SizedBox(width: width / 30),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${previousOrderList[index].shopName}',
                                        style:
                                            TextStyle(fontSize: height / 85)),
                                    SizedBox(height: height / 80),
                                    Text(
                                        '${previousOrderList[index].shopAddress}',
                                        style:
                                            TextStyle(fontSize: height / 85)),
                                  ]),
                              Flexible(child: SizedBox(width: width / 5)),
                              Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.black, width: 0.1)),
                                  padding: EdgeInsets.all(height / 200),
                                  child: Icon(Icons.phone,
                                      color: Colors.black, size: height / 30)),
                              SizedBox(width: width / 15),
                              Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.black, width: 0.1)),
                                  padding: EdgeInsets.all(height / 200),
                                  child: Icon(Icons.location_on,
                                      color: Colors.black, size: height / 30)),
                            ]),
                            SizedBox(height: height / 40),
                            Text('Delivered to:',
                                style: TextStyle(
                                    fontSize: height / 90, color: Colors.grey)),
                            SizedBox(height: height / 80),
                            Row(children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${previousOrderList[index].customerName}',
                                        style:
                                            TextStyle(fontSize: height / 85)),
                                    SizedBox(height: height / 80),
                                    Text(
                                        '${previousOrderList[index].customerAddress.substring(0, 20)}',
                                        style:
                                            TextStyle(fontSize: height / 85)),
                                  ]),
                              Flexible(child: SizedBox(width: width / 3.1)),
                              Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.black, width: 0.1)),
                                  padding: EdgeInsets.all(height / 200),
                                  child: Icon(Icons.phone,
                                      color: Colors.black, size: height / 30)),
                              SizedBox(width: width / 15),
                              Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.black, width: 0.1)),
                                  padding: EdgeInsets.all(height / 200),
                                  child: Icon(Icons.location_on,
                                      color: Colors.black, size: height / 30)),
                            ]),
                            // 177-3,326
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height / 20),
                  ],
                );
              },
            ),
    );
  }
}
