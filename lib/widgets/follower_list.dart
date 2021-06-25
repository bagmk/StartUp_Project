import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/progress.dart';

class FollowerList extends StatefulWidget {
  final String username;
  final String mediaUrl;

  final Timestamp timestamp;
  final String ownerId;

  FollowerList({this.username, this.mediaUrl, this.timestamp, this.ownerId});

  factory FollowerList.fromDocument(DocumentSnapshot doc) {
    return FollowerList(
        username: doc.data()['username'],
        timestamp: doc.data()['timestamp'],
        mediaUrl: doc.data()['userProfileImg'],
        ownerId: doc.data()['ownerId']);
  }

  @override
  _FollowerListState createState() => _FollowerListState(
      timestamp: this.timestamp,
      username: this.username,
      mediaUrl: this.mediaUrl,
      ownerId: this.ownerId);
}

class _FollowerListState extends State<FollowerList> {
  final Timestamp timestamp;
  final String username;
  final String mediaUrl;
  final String ownerId;

  _FollowerListState(
      {this.timestamp, this.username, this.mediaUrl, this.ownerId});
  buildPostHeader() {
    return FutureBuilder(
      future: usersRef.doc(ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }

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
            Text(username,
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ]),
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
