import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/home.dart';

import 'package:fluttershare/widgets/progress.dart';
import 'package:uuid/uuid.dart';

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
  final String userProfileUrl;

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
      this.ownerId,
      this.userProfileUrl});

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
        ownerId: doc.data()['ownerId'],
        userProfileUrl: doc.data()['userProfileUrl']);
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
      ownerId: this.ownerId,
      userProfileUrl: this.userProfileUrl);
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
  final String userProfileUrl;

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
    this.userProfileUrl,
  });

  handleOfferList(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Decision"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () => acceptOffer(),
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

  acceptOffer() {
    String messageId = Uuid().v4();

    openchatRef.doc(ownerId).collection("chat").doc(messageId).set(
      {
        "name": item,
        "userUrl": userProfileUrl,
        "imageAvatarUrl": mediaUrl,
        "shortDescription": type,
        "postId": postId,
        "timestamp": DateTime.now(),
        "userName": username,
        "postion": "Offer",
        "messageId": messageId
      },
    );

    openchatRef.doc(userId).collection("chat").doc(messageId).set(
      {
        "name": item,
        "userUrl": currentUser.profileUrl,
        "imageAvatarUrl": mediaUrl,
        "shortDescription": type,
        "postId": postId,
        "timestamp": DateTime.now(),
        "userName": currentUser.displayName,
        "postion": "Bid",
        "messageId": messageId
      },
    );

// It need to go to chat screen.
    Navigator.pop(context);
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

  handleItem(String type, String item) {
    if (type == "Item") {
      return ClipOval(
          child: CachedNetworkImage(
        imageUrl: itemUrl,
        placeholder: (context, url) => Padding(
          child: CircularProgressIndicator(),
          padding: EdgeInsets.all(20.0),
        ),
        height: 50,
        width: 50,
        fit: BoxFit.cover,
      ));
    } else {
      return Text(item,
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold));
    }
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
                  handleItem(type, item)
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
