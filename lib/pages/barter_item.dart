import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/payment.dart';

import 'KeyPad.dart';
import 'home.dart';

class BarterItem extends StatefulWidget {
  final String currentUserId;
  final String postId;
  final String ownerId;

  BarterItem({
    this.currentUserId,
    this.postId,
    this.ownerId,
  });

  @override
  BarterItemState createState() => BarterItemState(
        currentUserId: this.currentUserId,
        postId: this.postId,
        ownerId: this.ownerId,
      );
}

class BarterItemState extends State {
  TextEditingController itemController = TextEditingController();
  final String currentUserId;
  final String postId;
  final String ownerId;
  bool _itemNameValid = true;
  bool isLoading = false;

  BarterItemState({
    this.currentUserId,
    this.postId,
    this.ownerId,
  });

  handleBarter(String itemName) {
    setState(() {
      itemController.text.trim().length < 3 || itemController.text.isEmpty
          ? _itemNameValid = false
          : _itemNameValid = true;
    });

    if (_itemNameValid) {
      barterRef.doc(ownerId).collection("barter").add({
        "username": currentUser.username,
        "Item": itemName,
        "timestamp": timestamp,
        "userId": currentUser.id,
        "postId": postId,
        "Cash/Item": "Item"
      });

      Navigator.pop(context);
    }
  }

  buildItemNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Item Name",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: itemController,
          decoration: InputDecoration(
              hintText: "Item Name",
              errorText: _itemNameValid ? null : "Item Name too short"),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trade with Item'),
        backgroundColor: Colors.blue,
      ),
      body: Builder(
        builder: (BuildContext context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(16.0), child: buildItemNameField()),
              RaisedButton(
                onPressed: () => handleBarter(itemController.text),
                child: Text("Barter!",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
