import 'package:flutter/material.dart';
import 'package:flutter_application_coop/constants/colors.dart';
import 'package:flutter_application_coop/screens/add_record_screen.dart';
import 'package:flutter_application_coop/screens/home_screen.dart';
import 'package:flutter_application_coop/screens/make_payment_screen.dart';
import 'package:flutter_application_coop/screens/my_collection_screen.dart';
import 'package:flutter_application_coop/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  final String username;
  final String name;
  final String branch;

  const MainScreen({
    super.key,
    required this.username,
    required this.name,
    required this.branch,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentPageIndex = 0;

  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();

    // Initialize the pages list in initState
    pages = [
      HomeScreen(
        username: widget.username,
        name: widget.name,
        branch: widget.branch,
      ), // Pass the username here
      AddRecordScreen(),
      MakePaymentScreen(),
      MyCollectionScreen(
        username: widget.username,
      ),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: kWhite,
        selectedItemColor: kGreen,
        unselectedItemColor: kGrey,
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_add),
            label: "Record",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: "Payment",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_shared),
            label: "Collections",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
      body: pages[_currentPageIndex],
    );
  }
}
