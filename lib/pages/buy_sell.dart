import 'package:flutter/material.dart';

class BuySell extends StatefulWidget {
  BuySell({Key key}) : super(key: key);

  @override
  _BuySellState createState() => _BuySellState();
}

class _BuySellState extends State<BuySell> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy and Sell Chatroom'),
      ),
      body: Center(child: Text('You have pressed the button  times.')),
    );
  }
}
