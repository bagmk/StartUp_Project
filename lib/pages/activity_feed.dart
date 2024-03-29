import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/pages/post_screen.dart';
import 'package:fluttershare/pages/profile.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  Future userNotifications;

  void initState() {
    super.initState();
    userNotifications = getActivityFeed();
  }

  getActivityFeed() async {
    QuerySnapshot snapshot = await activityFeedRef
        .doc(currentUser.id)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get();

    List<ActivityFeedItem> feedItems = [];
    snapshot.docs.forEach((doc) {
      feedItems.add(ActivityFeedItem.fromDocument(doc));
      // print('Activity Feed Item: ${doc.data}');
    });
    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: header(context, titleText: "Activity Feed"),
      body: Container(
          child: FutureBuilder(
        future: userNotifications,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return ListView(
            children: snapshot.data,
          );
        },
      )),
    );
  }
}

Widget mediaPreview;
String activityItemText;

class ActivityFeedItem extends StatelessWidget {
  final String username;
  final String userId;
  final String type; // 'like', 'follow', 'comment'
  final String mediaUrl;
  final String postId;
  final String userProfileImg;
  final String commentData;
  final String item;
  final Timestamp timestamp;
  int _counter = 0;

  ActivityFeedItem(
      {this.username,
      this.userId,
      this.type,
      this.mediaUrl,
      this.postId,
      this.userProfileImg,
      this.commentData,
      this.timestamp,
      this.item});

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
      username: doc.data()['username'],
      userId: doc.data()['userId'],
      type: doc.data()['type'],
      postId: doc.data()['postId'],
      userProfileImg: doc.data()['userProfileImg'],
      commentData: doc.data()['commentData'],
      timestamp: doc.data()['timestamp'],
      mediaUrl: doc.data()['mediaUrl'],
      item: doc.data()['item'],
    );
  }

  showPost(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PostScreen(
                  postId: postId,
                  userId: userId,
                )));
  }

  configureMediaPreview(context) {
    if (type == "like" || type == 'comment') {
      mediaPreview = GestureDetector(
        onTap: () => showPost(context),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(mediaUrl))),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = Text('');
    }
    if (type == 'like') {
      activityItemText = "liked your post";
    } else if (type == 'follow') {
      activityItemText = "is following you";
    } else if (type == 'comment') {
      activityItemText = 'replied: $commentData';
    } else if (type == 'Cash') {
      activityItemText = 'bid your item with: \$ $item';
    } else if (type == 'Item') {
      activityItemText = 'barter with $item';
    } else {
      activityItemText = "Error: Unknown type '$type'";
    }
  }

  deleteList() async {
    activityFeedRef
        .doc(currentUser.id)
        .collection('feedItems')
        .doc(postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
          color: Colors.white54,
          child: Dismissible(
            resizeDuration: null,
            onDismissed: (DismissDirection direction) {
              _counter += direction == DismissDirection.endToStart ? 1 : -1;
              deleteList();
            },
            key: new ValueKey(_counter),
            child: ListTile(
              title: GestureDetector(
                onTap: () => showProfile(
                  context,
                  profileId: userId,
                ),
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: username,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' $activityItemText',
                        ),
                      ]),
                ),
              ),
              //errors are showing here
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(userProfileImg),
              ),
              subtitle: Text(
                timeago.format(timestamp.toDate()),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: mediaPreview,
            ),
          )),
    );
  }
}

showProfile(BuildContext context, {String profileId}) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Profile(
                profileId: profileId,
              )));
}
