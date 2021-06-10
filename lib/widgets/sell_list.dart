import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';

import 'package:fluttershare/pages/activity_feed.dart';

import 'package:fluttershare/pages/home.dart';

import 'package:fluttershare/widgets/progress.dart';

class SellList extends StatefulWidget {
  final String postId;
  final String userId;
  final String type;
  final String username;
  final String item;
  final Timestamp timestamp;
  final String mediaUrl;
  final String bidId;

  SellList(
      {this.postId,
      this.userId,
      this.type,
      this.username,
      this.timestamp,
      this.item,
      this.mediaUrl,
      this.bidId});

  factory SellList.fromDocument(DocumentSnapshot doc) {
    return SellList(
        postId: doc.data()['postId'],
        userId: doc.data()['userId'],
        timestamp: doc.data()['timestamp'],
        type: doc.data()['Cash/Item'],
        username: doc.data()['username'],
        item: doc.data()['item'],
        mediaUrl: doc.data()['mediaUrl'],
        bidId: doc.data()['bidId']);
  }

  @override
  _SellListState createState() => _SellListState(
      postId: this.postId,
      userId: this.userId,
      timestamp: this.timestamp,
      type: this.type,
      username: this.username,
      item: this.item,
      mediaUrl: this.mediaUrl,
      bidId: this.bidId);
}

class _SellListState extends State<SellList> {
  final String postId;
  final String userId;
  final Timestamp timestamp;
  final String type;
  final String item;
  final String bidId;
  final String username;
  final String mediaUrl;

  _SellListState(
      {this.postId,
      this.userId,
      this.bidId,
      this.timestamp,
      this.type,
      this.username,
      this.item,
      this.mediaUrl});

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
            title: Row(children: [
              Text(type == "Cash" ? " <- bid " : "<- barter ",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
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
              Text(type == "Cash" ? " with \$" : " with ",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              Text(item,
                  style: TextStyle(
                      color: Colors.pink, fontWeight: FontWeight.bold)),
              FlatButton(
                onPressed: () => print('handlechatting'),
                child: Container(
                  width: 60.0,
                  height: 40.0,
                  child: Text(
                    "Accept",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
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
