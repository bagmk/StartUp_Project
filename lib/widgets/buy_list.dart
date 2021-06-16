import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/progress.dart';

class BuyList extends StatefulWidget {
  final String postId;
  final String userId;
  final String bidId;
  final String type;
  final String username;
  final String item;
  final Timestamp timestamp;
  final String mediaUrl;
  final String ownerId;

  BuyList(
      {this.postId,
      this.userId,
      this.type,
      this.username,
      this.timestamp,
      this.item,
      this.mediaUrl,
      this.bidId,
      this.ownerId});

  factory BuyList.fromDocument(DocumentSnapshot doc) {
    return BuyList(
        postId: doc.data()['postId'],
        userId: doc.data()['userId'],
        type: doc.data()['Cash/Item'],
        username: doc.data()['username'],
        item: doc.data()['item'],
        mediaUrl: doc.data()['mediaUrl'],
        bidId: doc.data()['bidId'],
        ownerId: doc.data()['ownerId']);
  }

  @override
  _BuyListState createState() => _BuyListState(
      postId: this.postId,
      userId: this.userId,
      timestamp: this.timestamp,
      type: this.type,
      username: this.username,
      item: this.item,
      bidId: this.bidId,
      ownerId: this.ownerId,
      mediaUrl: this.mediaUrl);
}

class _BuyListState extends State<BuyList> {
  final String postId;
  final String userId;
  final Timestamp timestamp;
  final String type;
  final String item;
  final String ownerId;
  final String bidId;
  final String username;
  final String mediaUrl;

  _BuyListState({
    this.postId,
    this.userId,
    this.bidId,
    this.ownerId,
    this.timestamp,
    this.type,
    this.username,
    this.item,
    this.mediaUrl,
  });

  handleDeleteList(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this offer?"),
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
    buyRef
        .doc(currentUser.id)
        .collection('barter')
        .doc(bidId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    sellRef.doc(ownerId).collection('barter').doc(bidId).get().then((doc) {
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
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              Text(item,
                  style: TextStyle(
                      color: Colors.pink, fontWeight: FontWeight.bold)),
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
