import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';

import 'package:fluttershare/pages/activity_feed.dart';

import 'package:fluttershare/pages/home.dart';

import 'package:fluttershare/widgets/progress.dart';

class BuyList extends StatefulWidget {
  final String postId;
  final String userId;
  final String type;
  final String username;
  final String item;
  final Timestamp timestamp;

  BuyList({
    this.postId,
    this.userId,
    this.type,
    this.username,
    this.timestamp,
    this.item,
  });

  factory BuyList.fromDocument(DocumentSnapshot doc) {
    return BuyList(
        postId: doc.data()['postId'],
        userId: doc.data()['userId'],
        type: doc.data()['Cash/Item'],
        username: doc.data()['username'],
        item: doc.data()['item']);
  }

  @override
  _BuyListState createState() => _BuyListState(
      postId: this.postId,
      userId: this.userId,
      timestamp: this.timestamp,
      type: this.type,
      username: this.username,
      item: this.item);
}

class _BuyListState extends State<BuyList> {
  final String postId;
  final String userId;
  final Timestamp timestamp;
  final String type;
  final String item;
  final String username;

  _BuyListState({
    this.postId,
    this.userId,
    this.timestamp,
    this.type,
    this.username,
    this.item,
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
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.photoUrl),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            child: Text(user.username,
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        );
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
