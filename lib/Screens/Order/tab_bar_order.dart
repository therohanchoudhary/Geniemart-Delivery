import 'package:flutter/material.dart';
import 'package:genie_cart_delivery/Screens/Order/active_order_screen.dart';
import 'package:genie_cart_delivery/Screens/Order/new_order_screen.dart';
import 'package:genie_cart_delivery/Screens/Order/previous_order_screen.dart';

class TabBarOrder extends StatefulWidget {
  @override
  _TabBarOrderState createState() => _TabBarOrderState();
}

class _TabBarOrderState extends State<TabBarOrder> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    textTab(String text) {
      return Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: width / 45, color: Colors.black));
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: height / 15),
            Center(
                child: Text('Welcome User',
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 15,
                        fontWeight: FontWeight.bold))),
            SizedBox(height: height / 60),
            TabBar(
              tabs: [
                Tab(child: textTab('New Orders')),
                Tab(child: textTab('Active Orders')),
                Tab(child: textTab('Previous Orders')),
              ],
            ),
            Container(
                color: Colors.grey[600], width: double.infinity, height: 2),
            Expanded(
              child: TabBarView(
                children: [
                  NewOrderScreen(),
                  ActiveOrderScreen(),
                  PreviousOrderScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderList {
  final String customerName;
  final String customerAddress;
  final String deliveryPerson;
  final String deliveryStatus;
  final orderNumber;
  final String paymentMode;
  final String productName;
  final String seller;
  final String sellerEmail;
  final String sellerImage;
  final String shopName;
  final String shopAddress;

  OrderList(
      {this.orderNumber,
      this.paymentMode,
      this.seller,
      this.productName,
      this.customerAddress,
      this.customerName,
      this.deliveryPerson,
      this.sellerImage,
      this.deliveryStatus,
      this.sellerEmail,
      this.shopAddress,
      this.shopName});
}
