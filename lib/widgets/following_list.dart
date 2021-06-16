import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/progress.dart';

class FollowingList extends StatefulWidget {
  final String username;
  final Timestamp timestamp;
  final String mediaUrl;
  final String ownerId;

  FollowingList({this.username, this.timestamp, this.mediaUrl, this.ownerId});

  factory FollowingList.fromDocument(DocumentSnapshot doc) {
    return FollowingList(
        username: doc.data()['username'],
        timestamp: doc.data()['timestamp'],
        mediaUrl: doc.data()['userProfileImg'],
        ownerId: doc.data()['ownerId']);
  }

  @override
  _FollowingListState createState() => _FollowingListState(
      timestamp: this.timestamp,
      username: this.username,
      mediaUrl: this.mediaUrl,
      ownerId: this.ownerId);
}

class _FollowingListState extends State<FollowingList> {
  final Timestamp timestamp;
  final String username;
  final String mediaUrl;
  final String ownerId;

  _FollowingListState({
    this.timestamp,
    this.username,
    this.ownerId,
    this.mediaUrl,
  });

  handleDeleteList(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this following?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    deleteList();
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'cancel',
                  )),
            ],
          );
        });
  }

  deleteList() async {
    followingRef
        .doc(currentUser.id)
        .collection('userFollowing')
        .doc(ownerId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

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
            trailing: IconButton(
                onPressed: () => handleDeleteList(context),
                icon: Icon(Icons.more_vert)));
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
