import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'home.dart';

class BarterItem extends StatefulWidget {
  final String currentUserId;
  final String postId;
  final String ownerId;
  final String mediaUrl;

  BarterItem({
    this.currentUserId,
    this.postId,
    this.ownerId,
    this.mediaUrl,
  });

  @override
  BarterItemState createState() => BarterItemState(
        currentUserId: this.currentUserId,
        postId: this.postId,
        ownerId: this.ownerId,
        mediaUrl: this.mediaUrl,
      );
}

class BarterItemState extends State {
  TextEditingController itemController = TextEditingController();
  final String currentUserId;
  final String postId;
  final String ownerId;
  final String mediaUrl;
  bool _itemNameValid = true;
  bool isLoading = false;
  String barterId = Uuid().v4();

  BarterItemState(
      {this.currentUserId, this.postId, this.ownerId, this.mediaUrl});

  handleBarter(String itemName) {
    setState(() {
      itemController.text.trim().length < 3 || itemController.text.isEmpty
          ? _itemNameValid = false
          : _itemNameValid = true;
    });

    if (_itemNameValid) {
      buyRef.doc(currentUser.id).collection("barter").doc(barterId).set({
        "username": currentUser.username,
        "item": itemName,
        "timestamp": timestamp,
        "userId": currentUser.id,
        "postId": postId,
        "bidId": barterId,
        "Cash/Item": "Item",
        "mediaUrl": mediaUrl,
        "ownerId": ownerId
      });

      sellRef.doc(ownerId).collection("barter").doc(barterId).set({
        "username": currentUser.username,
        "item": itemName,
        "timestamp": timestamp,
        "userId": currentUser.id,
        "postId": postId,
        "bidId": barterId,
        "Cash/Item": "Item",
        "mediaUrl": mediaUrl,
      });

      bool isNotPostOwner = currentUserId != ownerId;
      if (isNotPostOwner) {
        activityFeedRef.doc(ownerId).collection("feedItems").doc(barterId).set({
          "type": "Item",
          "item": itemName,
          "username": currentUser.username,
          "userId": currentUser.id,
          "userProfileImg": currentUser.photoUrl,
          "postId": postId,
          "mediaUrl": mediaUrl,
          "timestamp": timestamp,
        });
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
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
