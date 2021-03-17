import 'package:flutter/material.dart';

class Wish extends StatefulWidget {
  Wish({Key key}) : super(key: key);

  @override
  _WishState createState() => _WishState();
}

class _WishState extends State<Wish> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text("Wish"),
    ));
  }
}
