import 'package:flutter/material.dart';
import 'package:genie_cart_delivery/Screens/Pay/pay_in_screen.dart';
import 'package:genie_cart_delivery/Screens/Pay/pay_out_screen.dart';
import 'package:genie_cart_delivery/Screens/Profile/profile_screen.dart';
import 'package:genie_cart_delivery/Screens/Order/tab_bar_order.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  @override
  _BottomNavigationBarScreenState createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      TabBarOrder(),
      PayOutScreen(),
      PayInScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        iconSize: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Order'),
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'Pay-Out'),
          BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_filled), label: 'Pay-in'),
          BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_filled), label: 'Profile'),
        ],
      ),
    );
  }
}
