import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/search.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'home.dart';
import 'package:fluttershare/pages/user_rating.dart';

class MessageIn extends StatefulWidget {
  final String postId;
  final String userName;
  final String messageId;
  final String postMediaUrl;

  MessageIn({this.postId, this.messageId, this.postMediaUrl, this.userName});
  @override
  MessageInState createState() => MessageInState(
        postId: this.postId,
        messageId: this.messageId,
        postMediaUrl: this.postMediaUrl,
        userName: this.userName,
      );
}

class MessageInState extends State<MessageIn> {
  TextEditingController messageController = TextEditingController();
  final String postId;
  final String messageId;
  final String postMediaUrl;
  final String userName;

  MessageInState(
      {this.postId, this.messageId, this.postMediaUrl, this.userName});

  buildMessages() {
    return StreamBuilder(
      stream: message
          .doc(messageId)
          .collection('message')
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<MessageS> messages = [];
        snapshot.data.docs.forEach((doc) {
          messages.add(MessageS.fromDocument(doc));
        });
        return ListView(
          children: messages,
        );
      },
    );
  }

  addMessage() {
    message.doc(messageId).collection("message").add({
      "username": currentUser.username,
      "comment": messageController.text,
      "timestamp": DateTime.now(),
      "avatarUrl": currentUser.profileUrl,
      "userId": currentUser.id,
    });
    messageController.clear();
  }

  buildSellerRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TextButton(
          onPressed: _showRatingAppDialog,
          // onPressed: () => Navigator.push(
          // context, MaterialPageRoute(builder: (context) => DemoScreen())),
          child: Text('Dealt',
              style: TextStyle(color: Theme.of(context).primaryColor)),
          // timelineDecision == 'follow'
          // ? Theme.of(context).primaryColor
          // : Colors.grey)),
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }

  void _showRatingAppDialog() {
    final _ratingDialog = RatingDialog(
      ratingColor: Colors.amber,
      title: 'How was trading with $userName?',
      message:
          // 'Rating this app and tell others what you think.'
          ' Add more description here if you want.',
      image: Image.asset(
        "assets/images/devs.jpg",
        height: 100,
      ),
      submitButton: 'Submit',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        print('rating: ${response.rating}, '
            'comment: ${response.comment}');

        if (response.rating < 3.0) {
          print('response.rating: ${response.rating}');
        } else {
          Container();
        }
      },
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ratingDialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(
          context,
          titleText: userName,
        ),
        body: Column(
          children: <Widget>[
            buildSellerRating(),
            Expanded(
              child: buildMessages(),
            ),
            Divider(),
            ListTile(
              title: TextFormField(
                controller: messageController,
                decoration: InputDecoration(labelText: "Aa..."),
              ),
              trailing: OutlineButton(
                onPressed: addMessage,
                borderSide: BorderSide.none,
                child: Text("Post"),
              ),
            )
          ],
        ));
  }
}

class MessageS extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;

  MessageS({
    this.username,
    this.userId,
    this.avatarUrl,
    this.comment,
    this.timestamp,
  });

  factory MessageS.fromDocument(DocumentSnapshot doc) {
    return MessageS(
      username: doc.data()['username'],
      userId: doc.data()['userId'],
      comment: doc.data()['comment'],
      timestamp: doc.data()['timestamp'],
      avatarUrl: doc.data()['avatarUrl'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(avatarUrl),
          ),
          subtitle: Text(timeago.format(timestamp.toDate())),
        ),
        Divider()
      ],
    );
  }
}
