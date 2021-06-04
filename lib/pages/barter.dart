import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/payment.dart';

import 'KeyPad.dart';
import 'home.dart';

class Barter extends StatefulWidget {
  final String currentUserId;
  final String postId;
  final String ownerId;

  Barter({
    this.currentUserId,
    this.postId,
    this.ownerId,
  });

  @override
  BarterState createState() => BarterState(
        currentUserId: this.currentUserId,
        postId: this.postId,
        ownerId: this.ownerId,
      );
}

class BarterState extends State {
  TextEditingController pinController = TextEditingController();
  final String currentUserId;
  final String postId;
  final String ownerId;

  BarterState({
    this.currentUserId,
    this.postId,
    this.ownerId,
  });

  handlePayment() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Payment()));
  }

  handleBarter(String pin) {
    barterRef.doc(ownerId).collection("barter").add({
      "username": currentUser.username,
      "price": pin,
      "timestamp": timestamp,
      "userId": currentUser.id,
      "postId": postId,
      "Cash/Item": "Cash"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bid Money'),
        backgroundColor: Colors.blue,
      ),
      body: Builder(
        builder: (BuildContext context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'How much do you want to pay?',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                      // fontFamily: AppTextStyle.robotoBold
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 50, right: 50, bottom: 15),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.orangeAccent,
                      border:
                          Border.all(color: Colors.orangeAccent, width: 1.5)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: TextField(
                      controller: pinController,
                      readOnly: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        // fontWeight: FontWeight.bold
                        // fontFamily: AppTextStyle.robotoBold
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '\$\$\$',
                      ),
                      // controller: userDisplayName,
                    ),
                  ),
                ),
              ),
              KeyPad(
                pinController: pinController,
                isPinLogin: false,
                onChange: (String pin) {
                  pinController.text = pin;
                  print('${pinController.text}');
                  setState(() {});
                },
                onSubmit: (String pin) {
                  pinController.text = pin;
                  print('submit \$ ${pinController.text}');
                  handleBarter(pinController.text);

/*                   Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                    (Route<dynamic> route) => false,
                  ); */
                  handlePayment();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
