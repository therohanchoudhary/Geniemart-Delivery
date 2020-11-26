import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:genie_cart_delivery/Screens/Order/previous_order_screen.dart';
import 'package:genie_cart_delivery/Screens/Order/tab_bar_order.dart';

class ActiveOrderScreen extends StatefulWidget {
  @override
  _ActiveOrderScreenState createState() => _ActiveOrderScreenState();
}

class _ActiveOrderScreenState extends State<ActiveOrderScreen> {
  List<OrderList> activeOrderList = [];
  bool _noDelivery = false;
  bool _showSpinner = false;
  var email = FirebaseAuth.instance.currentUser.email;

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

      if (a["deliveryStatus"].toString().toLowerCase() == "active" &&
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
        activeOrderList.add(OrderList(
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
        print(i);
        setState(() {});
      }
    }
    if (activeOrderList.length == 0)
      setState(() {
        _noDelivery = true;
      });
    setState(() {
      _showSpinner = false;
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
          ? Center(child: Text('No Active Orders'))
          : _showSpinner == true
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: activeOrderList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Stack(
                          alignment: Alignment(0, 1.15),
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: height / 40),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 0.5),
                                    borderRadius:
                                        BorderRadius.circular(height / 90)),
                                height: height / 1.9,
                                width: width,
                                padding: EdgeInsets.symmetric(
                                    vertical: height / 32,
                                    horizontal: width / 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        'Order #${activeOrderList[index].orderNumber}',
                                        style: TextStyle(
                                            fontSize: height / 90,
                                            color: Colors.grey)),
                                    SizedBox(height: height / 80),
                                    Row(
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        height)),
                                            height: height / 28,
                                            width: width / 5,
                                            child: Center(
                                                child: Text('Pickup',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            height / 110)))),
                                        SizedBox(width: width / 45),
                                        Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 0.8),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        height)),
                                            height: height / 28,
                                            width: width / 5,
                                            child: Center(
                                                child: Text('Delivery',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize:
                                                            height / 110)))),
                                      ],
                                    ),
                                    SizedBox(height: height / 80),
                                    Text('Delivery Date',
                                        style: TextStyle(
                                            fontSize: height / 90,
                                            color: Colors.grey)),
                                    SizedBox(height: height / 80),
                                    Text(
                                        '${activeOrderList[index].productName.toUpperCase()}',
                                        style: TextStyle(
                                            fontSize: height / 60,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: height / 80),
                                    Text(
                                        'Payment Mode: ${activeOrderList[index].paymentMode}',
                                        style:
                                            TextStyle(fontSize: height / 80)),
                                    SizedBox(height: height / 40),
                                    Row(children: [
                                      activeOrderList[index].sellerImage == null
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.black),
                                              padding:
                                                  EdgeInsets.all(height / 200),
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
                                                          activeOrderList[index]
                                                              .sellerImage)))),
                                      SizedBox(width: width / 30),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${activeOrderList[index].shopName}',
                                                style: TextStyle(
                                                    fontSize: height / 85)),
                                            SizedBox(height: height / 80),
                                            Text(
                                                '${activeOrderList[index].shopAddress}',
                                                style: TextStyle(
                                                    fontSize: height / 85)),
                                          ]),
                                      Flexible(
                                          child: SizedBox(width: width / 5)),
                                      Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 0.1)),
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
                                                  color: Colors.black,
                                                  width: 0.1)),
                                          padding: EdgeInsets.all(height / 200),
                                          child: Icon(Icons.location_on,
                                              color: Colors.black,
                                              size: height / 30)),
                                    ]),
                                    SizedBox(height: height / 40),
                                    Text('Deliver to:',
                                        style: TextStyle(
                                            fontSize: height / 90,
                                            color: Colors.grey)),
                                    SizedBox(height: height / 80),
                                    Row(
                                      children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${activeOrderList[index].customerName}',
                                                  style: TextStyle(
                                                      fontSize: height / 80)),
                                              SizedBox(height: height / 80),
                                              Text(
                                                  '${activeOrderList[index].customerAddress.substring(0, 25)}',
                                                  style: TextStyle(
                                                      fontSize: height / 85)),
                                            ]),
                                        Flexible(child: SizedBox(width: width)),
                                        Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 0.1)),
                                            padding:
                                                EdgeInsets.all(height / 200),
                                            child: Icon(Icons.phone,
                                                color: Colors.black,
                                                size: height / 30)),
                                        SizedBox(width: width / 15),
                                        Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 0.1)),
                                            padding:
                                                EdgeInsets.all(height / 200),
                                            child: Icon(Icons.location_on,
                                                color: Colors.black,
                                                size: height / 30)),
                                      ],
                                    ),
                                    SizedBox(height: height / 50),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  _showSpinner = true;
                                });
                                await FirebaseFirestore.instance
                                    .collection('deliveryLog')
                                    .doc(activeOrderList[index].orderNumber)
                                    .update({"deliveryStatus": "delivered"});
                                QuerySnapshot querySnapshot =
                                    await FirebaseFirestore.instance
                                        .collection("orders")
                                        .get();

                                var queryLen = querySnapshot.docs.length;
                                for (int i = 0; i < queryLen; i++) {
                                  var a =
                                      querySnapshot.docs[i].data()["products"];
                                  if (a.length > 0) {
                                    for (int j = 0; j < a.length; j++) {
                                      if ("${a[j]["orderid"]}" ==
                                          "${activeOrderList[index].orderNumber}") {
                                        await FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc(querySnapshot.docs[i].id)
                                            .update({
                                          "products": FieldValue.arrayUnion([
                                            {
                                              "brand": a[j]["brand"],
                                              "caddress": a[j]["caddress"],
                                              "category": a[j]["category"],
                                              "cname": a[j]["cname"],
                                              "clat": a[j]["clat"],
                                              "clong": a[j]["clong"],
                                              "date": a[j]["date"],
                                              "desc": a[j]["desc"],
                                              "discount": a[j]["discount"],
                                              "freq": a[j]["freq"],
                                              "id": a[j]["id"],
                                              "img": a[j]["img"],
                                              "isveg": a[j]["isveg"],
                                              "life": a[j]["life"],
                                              "marketedby": a[j]["marketedby"],
                                              "manufacturer": a[j]
                                                  ["manufacturer"],
                                              "mprice": a[j]["mprice"],
                                              "name": a[j]["name"],
                                              "olat": a[j]["olat"],
                                              "olong": a[j]["olong"],
                                              "oprice": a[j]["oprice"],
                                              "orderid": a[j]["orderid"],
                                              "paymode": a[j]["paymode"],
                                              "reviews": a[j]["reviews"],
                                              "reviewed": a[j]["reviewed"],
                                              "rnr": a[j]["rnr"],
                                              "sellerid": a[j]["sellerid"],
                                              "seller": a[j]["seller"],
                                              "selected": a[j]["selected"],
                                              "status": "Delivered",
                                              "stars": a[j]["stars"],
                                              "units": a[j]["units"],
                                              "values": a[j]["values"],
                                            }
                                          ])
                                        });

                                        await FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc(querySnapshot.docs[i].id)
                                            .update({
                                          "products": FieldValue.arrayRemove([
                                            {
                                              "brand": a[j]["brand"],
                                              "caddress": a[j]["caddress"],
                                              "category": a[j]["category"],
                                              "cname": a[j]["cname"],
                                              "clat": a[j]["clat"],
                                              "clong": a[j]["clong"],
                                              "date": a[j]["date"],
                                              "desc": a[j]["desc"],
                                              "discount": a[j]["discount"],
                                              "freq": a[j]["freq"],
                                              "id": a[j]["id"],
                                              "img": a[j]["img"],
                                              "isveg": a[j]["isveg"],
                                              "life": a[j]["life"],
                                              "marketedby": a[j]["marketedby"],
                                              "manufacturer": a[j]
                                              ["manufacturer"],
                                              "mprice": a[j]["mprice"],
                                              "name": a[j]["name"],
                                              "olat": a[j]["olat"],
                                              "olong": a[j]["olong"],
                                              "oprice": a[j]["oprice"],
                                              "orderid": a[j]["orderid"],
                                              "paymode": a[j]["paymode"],
                                              "reviews": a[j]["reviews"],
                                              "reviewed": a[j]["reviewed"],
                                              "rnr": a[j]["rnr"],
                                              "sellerid": a[j]["sellerid"],
                                              "seller": a[j]["seller"],
                                              "selected": a[j]["selected"],
                                              "status": a[j]["status"],
                                              "stars": a[j]["stars"],
                                              "units": a[j]["units"],
                                              "values": a[j]["values"],
                                            }
                                          ])
                                        });
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        PreviousOrderScreen()));
                                      }
                                    }
                                  }
                                  setState(() {
                                    _showSpinner = false;
                                  });
                                }
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius:
                                          BorderRadius.circular(height)),
                                  height: height / 15,
                                  width: width / 2,
                                  child: Center(
                                      child: Text('Delivered',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: height / 65)))),
                            ),
                          ],
                        ),
                        SizedBox(height: height / 15),
                      ],
                    );
                  },
                ),
    );
  }
}
