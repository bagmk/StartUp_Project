import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';

import 'package:fluttershare/pages/activity_feed.dart';

import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/custom_image.dart';

import 'package:fluttershare/widgets/progress.dart';

class BuyList extends StatefulWidget {
  final String postId;
  final String userId;
  final String type;
  final String username;
  final String item;
  final Timestamp timestamp;
  final String mediaUrl;

  BuyList(
      {this.postId,
      this.userId,
      this.type,
      this.username,
      this.timestamp,
      this.item,
      this.mediaUrl});

  factory BuyList.fromDocument(DocumentSnapshot doc) {
    return BuyList(
      postId: doc.data()['postId'],
      userId: doc.data()['userId'],
      type: doc.data()['Cash/Item'],
      username: doc.data()['username'],
      item: doc.data()['item'],
      mediaUrl: doc.data()['mediaUrl'],
    );
  }

  @override
  _BuyListState createState() => _BuyListState(
      postId: this.postId,
      userId: this.userId,
      timestamp: this.timestamp,
      type: this.type,
      username: this.username,
      item: this.item,
      mediaUrl: this.mediaUrl);
}

class _BuyListState extends State<BuyList> {
  final String postId;
  final String userId;
  final Timestamp timestamp;
  final String type;
  final String item;
  final String username;
  final String mediaUrl;

  _BuyListState({
    this.postId,
    this.userId,
    this.timestamp,
    this.type,
    this.username,
    this.item,
    this.mediaUrl,
  });

  buildPostHeader() {
    return FutureBuilder(
      future: usersRef.doc(userId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);

        return ListTile(
            title: Row(children: [
          ClipOval(
              child: CachedNetworkImage(
            imageUrl: mediaUrl,
            placeholder: (context, url) => Padding(
              child: CircularProgressIndicator(),
              padding: EdgeInsets.all(20.0),
            ),
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          )),
          Text(type == "Cash" ? " You bid with \$" : "You barter with ",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          Text(item,
              style:
                  TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
        ]));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(),
      ],
    );
  }
}
