import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/pages/message_in.dart';
import 'package:fluttershare/widgets/progress.dart';

class FriendList extends StatefulWidget {
  final String item;
  final String mediaUrl;
  final String type;
  final String postId;
  final Timestamp timestamp;
  final String userName;
  final String postion;
  final String userProfileUrl;
  final String messageId;

  FriendList(
      {this.item,
      this.mediaUrl,
      this.type,
      this.postId,
      this.timestamp,
      this.userName,
      this.postion,
      this.userProfileUrl,
      this.messageId});

  factory FriendList.fromDocument(DocumentSnapshot doc) {
    return FriendList(
        item: doc.data()['name'],
        mediaUrl: doc.data()['imageAvatarUrl'],
        type: doc.data()['shortDescription'],
        postId: doc.data()['postId'],
        timestamp: doc.data()['timestamp'],
        postion: doc.data()['postion'],
        userName: doc.data()['userName'],
        userProfileUrl: doc.data()['userUrl'],
        messageId: doc.data()['messageId']);
  }

  @override
  _FriendListState createState() => _FriendListState(
      item: this.item,
      mediaUrl: this.mediaUrl,
      type: this.type,
      postId: this.postId,
      timestamp: this.timestamp,
      userName: this.userName,
      postion: this.postion,
      userProfileUrl: this.userProfileUrl,
      messageId: this.messageId);
}

class _FriendListState extends State<FriendList> {
  final String item;
  final String mediaUrl;
  final String type;
  final String postId;
  final Timestamp timestamp;
  final String userProfileUrl;
  final String messageId;

  final String userName;
  final String postion;
  int _counter = 0;
  _FriendListState(
      {this.item,
      this.mediaUrl,
      this.type,
      this.postId,
      this.timestamp,
      this.userName,
      this.postion,
      this.userProfileUrl,
      this.messageId});

  handleDeleteList(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove Message?"),
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
    openchatRef
        .doc(currentUser.id)
        .collection('chat')
        .doc(postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleMessage(BuildContext context,
      {String postId, String userName, String messageId, String mediaUrl}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MessageIn(
        postId: postId,
        userName: userName,
        messageId: messageId,
        postMediaUrl: mediaUrl,
      );
    }));
  }

  buildPostHeader() {
    return FutureBuilder(
      future: usersRef.doc(currentUser.id).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }

        return ListTile(
            title: Dismissible(
          resizeDuration: null,
          onDismissed: (DismissDirection direction) {
            setState(() {
              _counter += direction == DismissDirection.endToStart ? 1 : -1;
              handleDeleteList(context);
            });
          },
          key: new ValueKey(_counter),
          child: GestureDetector(
              onTap: () => handleMessage(context,
                  postId: postId,
                  userName: userName,
                  messageId: messageId,
                  mediaUrl: mediaUrl),
              child: Row(children: [
                ClipOval(
                    child: CachedNetworkImage(
                  imageUrl: userProfileUrl,
                  placeholder: (context, url) => Padding(
                    child: CircularProgressIndicator(),
                    padding: EdgeInsets.all(20.0),
                  ),
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                )),
                Text("ID:" + userName,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 30,
                ),
                Text("Item:" + item,
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
              ])),
        ));
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
