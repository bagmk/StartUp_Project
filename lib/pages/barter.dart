import 'package:flutter/material.dart';
import 'package:fluttershare/pages/payment.dart';
import 'package:uuid/uuid.dart';
import 'KeyPad.dart';
import 'home.dart';

class Barter extends StatefulWidget {
  final String currentUserId;
  final String postId;
  final String ownerId;
  final String mediaUrl;

  Barter({this.currentUserId, this.postId, this.ownerId, this.mediaUrl});

  @override
  BarterState createState() => BarterState(
        currentUserId: this.currentUserId,
        postId: this.postId,
        ownerId: this.ownerId,
        mediaUrl: this.mediaUrl,
      );
}

class BarterState extends State {
  TextEditingController pinController = TextEditingController();
  final String currentUserId;
  String bidId = Uuid().v4();
  final String postId;
  final String ownerId;
  final String mediaUrl;

  BarterState({
    this.currentUserId,
    this.postId,
    this.ownerId,
    this.mediaUrl,
  });

  handlePayment() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Payment()));
  }

  handleBarter(String pin) {
    buyRef.doc(currentUser.id).collection("barter").doc(bidId).set(
      {
        "username": currentUser.username,
        "item": pin,
        "timestamp": DateTime.now(),
        "userId": currentUser.id,
        "postId": postId,
        "bidId": bidId,
        "Cash/Item": "Cash",
        "mediaUrl": mediaUrl,
        "ownerId": ownerId
      },
    );

    sellRef.doc(ownerId).collection("barter").doc(bidId).set({
      "username": currentUser.username,
      "item": pin,
      "timestamp": DateTime.now(),
      "userId": currentUser.id,
      "postId": postId,
      "bidId": bidId,
      "Cash/Item": "Cash",
      "mediaUrl": mediaUrl,
      "ownerId": ownerId,
      "userProfileUrl": currentUser.profileUrl
    });

    bool isNotPostOwner = currentUserId != ownerId;
    if (isNotPostOwner) {
      activityFeedRef.doc(ownerId).collection("feedItems").doc(bidId).set({
        "type": "Cash",
        "item": pin,
        "username": currentUser.username,
        "userId": currentUser.id,
        "userProfileImg": currentUser.profileUrl,
        "postId": bidId,
        "mediaUrl": mediaUrl,
        "timestamp": DateTime.now(),
      });
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
