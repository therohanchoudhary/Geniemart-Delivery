import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genie_cart_delivery/Screens/Order/tab_bar_order.dart';

class NewOrderScreen extends StatefulWidget {
  @override
  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  List<OrderList> newOrderList = [];

  var email = FirebaseAuth.instance.currentUser.email;
  bool _showSpinner = false;

  bool _noDelivery = false;

  Future _getData() async {
    setState(() {
      _showSpinner = true;
    });
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
      var emails = List.from(a['rejectedBy']);
      bool rejected = false;

      for (int i = 0; i < emails.length; i++) {
        if (emails[i] == "$email") {
          rejected = true;
          break;
        }
      }

      if (a["deliveryStatus"].toString().toLowerCase() == "new" &&
          a["deliveryPerson"].toString() == "0" &&
          rejected == false) {
        newOrderList.add(OrderList(
          customerAddress: a["customerAddress"],
          customerName: a["customerName"],
          deliveryPerson: a["deliveryPerson"],
          deliveryStatus: a["deliveryStatus"],
          orderNumber: a["orderNumber"],
          paymentMode: a["paymentMode"],
          productName: a["productName"],
          seller: a["seller"],
          sellerEmail: a["sellerEmail"],
          shopName: shopName,
          shopAddress: shopAddress,
        ));
      }
      if (mounted) setState(() {});
    }
    setState(() {
      _showSpinner = false;
    });
    if (newOrderList.length == 0)
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
          ? Center(child: Text('No New Orders'))
          : _showSpinner == true
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: newOrderList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: height / 40),
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 0.5),
                                borderRadius:
                                    BorderRadius.circular(height / 90)),
                            height: height / 3.5,
                            width: width,
                            padding: EdgeInsets.symmetric(
                                vertical: height / 32, horizontal: width / 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    'Order #${newOrderList[index].orderNumber}',
                                    style: TextStyle(
                                        fontSize: height / 90,
                                        color: Colors.grey)),
                                SizedBox(height: height / 80),
                                Text(
                                    '${newOrderList[index].productName.toUpperCase()}',
                                    style: TextStyle(
                                        fontSize: height / 60,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: height / 40),
                                Row(children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('${newOrderList[index].shopName}',
                                            style: TextStyle(
                                                fontSize: height / 85)),
                                        SizedBox(height: height / 80),
                                        Text(
                                            '${newOrderList[index].shopAddress}',
                                            style: TextStyle(
                                                fontSize: height / 85)),
                                      ]),
                                  Flexible(child: SizedBox(width: width / 3)),
                                  Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.black, width: 0.1)),
                                      padding: EdgeInsets.all(height / 200),
                                      child: Icon(Icons.phone,
                                          color: Colors.black,
                                          size: height / 30)),
                                  SizedBox(width: width / 15),
                                  Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.black, width: 0.1)),
                                      padding: EdgeInsets.all(height / 200),
                                      child: Icon(Icons.location_on,
                                          color: Colors.black,
                                          size: height / 30)),
                                ]),
                                SizedBox(height: height / 40),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          _showSpinner = true;
                                        });
                                        await FirebaseFirestore.instance
                                            .collection('deliveryLog')
                                            .doc(newOrderList[index]
                                                .orderNumber
                                                .toString())
                                            .update({
                                          "deliveryStatus": "active",
                                          "deliveryPerson": email
                                        });
                                        newOrderList.removeAt(index);
                                        setState(() {
                                          _showSpinner = false;
                                        });
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      height)),
                                          height: height / 22,
                                          width: width / 2.9,
                                          child: Center(
                                              child: Text('Accept',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: height / 90)))),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          _showSpinner = true;
                                        });
                                        await FirebaseFirestore.instance
                                            .collection('deliveryLog')
                                            .doc(
                                                newOrderList[index].orderNumber)
                                            .update({
                                          "rejectedBy":
                                              FieldValue.arrayUnion([email]),
                                        });
                                        newOrderList.removeAt(index);
                                        setState(() {
                                          _showSpinner = false;
                                        });
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 0.2),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      height)),
                                          height: height / 22,
                                          width: width / 2.9,
                                          child: Center(
                                              child: Text('Reject',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: height / 90)))),
                                    ),
                                  ],
                                )
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
