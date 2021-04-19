import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_app/pages/home_page.dart';
import 'package:my_app/login_page.dart';
import 'package:my_app/tree.dart';

class SplashScrren extends StatefulWidget {
  @override
  _SplashScrrenState createState() => _SplashScrrenState();
}

class _SplashScrrenState extends State<SplashScrren> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(
          milliseconds: 2000,
        ), () {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (_) => Tree()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: new Stack(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            child: Image.asset(
              'assets/images/Splash.png',
              height: double.infinity,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
