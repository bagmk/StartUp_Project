import 'package:flutter/material.dart';

class Sell extends StatefulWidget {
  Sell({Key key}) : super(key: key);

  @override
  _SellState createState() => _SellState();
}

class _SellState extends State<Sell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text("Sell"),
    ));
  }
}
