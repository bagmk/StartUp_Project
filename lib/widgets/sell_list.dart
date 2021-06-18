import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/home.dart';

import 'package:fluttershare/widgets/progress.dart';

class SellList extends StatefulWidget {
  final String postId;
  final String userId;
  final String type;
  final String username;
  final String item;
  final Timestamp timestamp;
  final String itemUrl;
  final String mediaUrl;
  final String bidId;
  final String ownerId;

  SellList(
      {this.postId,
      this.userId,
      this.type,
      this.username,
      this.timestamp,
      this.item,
      this.itemUrl,
      this.mediaUrl,
      this.bidId,
      this.ownerId});

  factory SellList.fromDocument(DocumentSnapshot doc) {
    return SellList(
        postId: doc.data()['postId'],
        userId: doc.data()['userId'],
        timestamp: doc.data()['timestamp'],
        type: doc.data()['Cash/Item'],
        username: doc.data()['username'],
        item: doc.data()['item'],
        itemUrl: doc.data()['itemUrl'],
        mediaUrl: doc.data()['mediaUrl'],
        bidId: doc.data()['bidId'],
        ownerId: doc.data()['ownerId']);
  }

  @override
  _SellListState createState() => _SellListState(
      postId: this.postId,
      userId: this.userId,
      timestamp: this.timestamp,
      type: this.type,
      username: this.username,
      item: this.item,
      itemUrl: this.itemUrl,
      mediaUrl: this.mediaUrl,
      bidId: this.bidId,
      ownerId: this.ownerId);
}

class _SellListState extends State<SellList> {
  final String postId;
  final String userId;
  final Timestamp timestamp;
  final String type;
  final String item;
  final String bidId;
  final String username;
  final String itemUrl;
  final String mediaUrl;
  final String ownerId;
  int _counter = 0;
  _SellListState({
    this.postId,
    this.userId,
    this.bidId,
    this.timestamp,
    this.type,
    this.username,
    this.item,
    this.itemUrl,
    this.mediaUrl,
    this.ownerId,
  });

  handleOfferList(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Decision"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Accept',
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    deleteList();
                  },
                  child: Text(
                    'Decline',
                  )),
            ],
          );
        });
  }

  deleteList() async {
    buyRef.doc(userId).collection('barter').doc(bidId).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    sellRef
        .doc(currentUser.id)
        .collection('barter')
        .doc(bidId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  buildPostHeader() {
    return FutureBuilder(
      future: usersRef.doc(userId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);

        return ListTile(
            title: Dismissible(
                resizeDuration: null,
                onDismissed: (DismissDirection direction) {
                  setState(() {
                    _counter +=
                        direction == DismissDirection.endToStart ? 1 : -1;
                    handleOfferList(context);
                  });
                },
                key: new ValueKey(_counter),
                child: Row(children: [
                  CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(user.profileUrl),
                    backgroundColor: Colors.grey,
                  ),
                  Text(type == "Cash" ? " <BD " : "<BT ",
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
                  ClipOval(
                      child: CachedNetworkImage(
                    imageUrl: itemUrl,
                    placeholder: (context, url) => Padding(
                      child: CircularProgressIndicator(),
                      padding: EdgeInsets.all(20.0),
                    ),
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  )),
                ])));
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
