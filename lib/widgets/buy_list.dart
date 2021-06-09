import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/progress.dart';

class BuyList extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String type;
  final String price;
  final String username;
  final String item;

  BuyList({
    this.postId,
    this.ownerId,
    this.type,
    this.price,
    this.username,
    this.item,
  });

  factory BuyList.fromDocument(DocumentSnapshot doc) {
    return BuyList(
        postId: doc.data()['postId'],
        ownerId: doc.data()['ownerId'],
        type: doc.data()['Cash/Item'],
        price: doc.data()['price'],
        username: doc.data()['username'],
        item: doc.data()['Item']);
  }

  @override
  _BuyListState createState() => _BuyListState(
      postId: this.postId,
      ownerId: this.ownerId,
      type: this.type,
      price: this.price,
      username: this.username,
      item: this.item);
}

class _BuyListState extends State<BuyList> {
  final String currentUserId = currentUser?.id;
  final String postId;
  final String ownerId;
  final String type;
  final String price;
  final String item;
  final String username;

  _BuyListState({
    this.postId,
    this.ownerId,
    this.type,
    this.price,
    this.username,
    this.item,
  });

  buildPostHeader() {
    return FutureBuilder(
      future: usersRef.doc(ownerId).get(),
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
