import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:fluttershare/pages/home.dart';

import 'package:fluttershare/widgets/Message_list.dart';

class Message extends StatefulWidget {
  final String profileId;

  Message({this.profileId});
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  bool isLoading = false;
  List<FriendList> friendList = [];
  int friendCount = 0;
  final String currentUserId = currentUser?.id;
  @override
  void initState() {
    super.initState();
    getFreindList();
  }

  getFreindList() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await openchatRef
        .doc(widget.profileId)
        .collection('chat')
        .orderBy('timestamp', descending: true)
        .get();
    if (mounted) {
      setState(() {
        isLoading = false;
        friendCount = snapshot.docs.length;
        friendList =
            snapshot.docs.map((doc) => FriendList.fromDocument(doc)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
      ),
      body: ListView(
        children: <Widget>[
          Divider(
            height: 0.0,
          ),
          Column(children: friendList),
        ],
      ),
    );
  }
}
