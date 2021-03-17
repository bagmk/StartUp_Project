import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/camera.dart';
import 'package:my_app/pages/profile.dart';
import 'package:my_app/pages/sell.dart';
import 'package:my_app/pages/swipe.dart';
import 'package:my_app/pages/wish.dart';

class HomePage extends StatefulWidget {
  final Function(User) onSignOut;
  HomePage({@required this.onSignOut});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    widget.onSignOut(null);
  }

  PageController _pageController = PageController();
  List<Widget> _screens = [Profile(), Camera(), Swipe(), Sell(), Wish()];

  int _selectedIndex = 0;
  void _onPageChanged(int index) {
    _selectedIndex = index;
  }

  void _onItemTapped(int selectedIndex) {
    setState(() {
      _pageController.jumpToPage(selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: _pageController,
          children: _screens,
          onPageChanged: _onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),

        //body: RaisedButton(
        //onPressed: () {
        //  logout();
        //},
        //child: Text("Log out"),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          iconSize: 30,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('Profile'),
                backgroundColor: Colors.blue),
            BottomNavigationBarItem(
                icon: Icon(Icons.camera),
                title: Text('Camera'),
                backgroundColor: Colors.brown),
            BottomNavigationBarItem(
                icon: Icon(Icons.swipe),
                title: Text('Swipe'),
                backgroundColor: Colors.red),
            BottomNavigationBarItem(
                icon: Icon(Icons.toys),
                title: Text('sell'),
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.shop),
                title: Text('Wish'),
                backgroundColor: Colors.green),
          ],
        ));
  }
}
