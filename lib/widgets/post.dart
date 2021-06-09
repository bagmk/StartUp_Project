import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/barter.dart';

import 'package:fluttershare/pages/activity_feed.dart';
import 'package:fluttershare/pages/barter_item.dart';

import 'package:fluttershare/pages/comments.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/custom_image.dart';
import 'package:fluttershare/widgets/progress.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final dynamic likes;
  final dynamic reports;

  Post({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.mediaUrl,
    this.description,
    this.likes,
    this.reports,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
        postId: doc.data()['postId'],
        ownerId: doc.data()['ownerId'],
        username: doc.data()['username'],
        location: doc.data()['location'],
        mediaUrl: doc.data()['mediaUrl'],
        description: doc.data()['description'],
        likes: doc.data()['likes'],
        reports: doc.data()['reports']);
  }

  int getLikeCount(likes) {
    //if there are no like return 0
    if (likes == null) {
      return 0;
    }
    int count = 0;
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  int getReportCount(likes) {
    //if there are no like return 0
    if (reports == null) {
      return 0;
    }
    int count = 0;
    reports.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _PostState createState() => _PostState(
        postId: this.postId,
        ownerId: this.ownerId,
        username: this.username,
        location: this.location,
        description: this.description,
        mediaUrl: this.mediaUrl,
        likes: this.likes,
        reports: this.reports,
        likeCount: getLikeCount(this.likes),
        reportCount: getLikeCount(this.reports),
      );
}

class _PostState extends State<Post> {
  final String currentUserId = currentUser?.id;
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  int likeCount;
  Map likes;
  bool isLiked;

  int reportCount;
  Map reports;
  bool isReported;
  bool showHeart = false;

  _PostState({
    this.postId,
    this.ownerId,
    this.username,
    this.location,
    this.mediaUrl,
    this.description,
    this.likes,
    this.likeCount,
    this.reports,
    this.reportCount,
  });

  buildPostHeader() {
    return FutureBuilder(
      future: usersRef.doc(ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);
        bool isPostOwner = currentUserId == ownerId;
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.photoUrl),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            onTap: () => showProfile(context, profileId: user.id),
            child: Text(user.username,
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          subtitle: Text(location),
          trailing: isPostOwner
              ? IconButton(
                  onPressed: () => handleDeletePost(context),
                  icon: Icon(Icons.more_vert))
              : Text(''),
        );
      },
    );
  }

  handleDeletePost(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this post?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    deletePost();
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

  //Note to delete post ownerId and currentuserId must be equal, so they can be used interchangly
  deletePost() async {
    postsRef.doc(ownerId).collection('userPosts').doc(postId).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    storageRef.child("post_$postId.jpg").delete();

    QuerySnapshot activityFeedSanpshot = await activityFeedRef
        .doc(ownerId)
        .collection("feedItems")
        .where('postId', isEqualTo: postId)
        .get();
    activityFeedSanpshot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    QuerySnapshot commentsSnapshot =
        await commentsRef.doc(postId).collection('comments').get();
    commentsSnapshot.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  addLikeToActivityFeed() {
    //add notification from only other peope
    //

    bool isNotPostOwner = currentUserId != ownerId;
    if (isNotPostOwner) {
      activityFeedRef.doc(ownerId).collection("feedItems").doc(postId).set({
        "type": "like",
        "username": currentUser.username,
        "userId": currentUser.id,
        "userProfileImg": currentUser.photoUrl,
        "postId": postId,
        "mediaUrl": mediaUrl,
        "timestamp": timestamp,
      });
    }
  }

  removeLikeFromActivityFeed() {
    bool isNotPostOwner = currentUserId != ownerId;
    if (isNotPostOwner) {
      activityFeedRef
          .doc(ownerId)
          .collection("feedItems")
          .doc(postId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }

  handleLikePost() {
    bool _isLiked = likes[currentUserId] == true;

    if (_isLiked) {
      postsRef
          .doc(ownerId)
          .collection('userPosts')
          .doc(postId)
          .update({'likes.$currentUserId': false});
      removeLikeFromActivityFeed();
      setState(() {
        likeCount -= 1;
        isLiked = false;
        likes[currentUserId] = false;
      });
    } else if (!_isLiked) {
      postsRef
          .doc(ownerId)
          .collection('userPosts')
          .doc(postId)
          .update({'likes.$currentUserId': true});
      addLikeToActivityFeed();
      setState(() {
        likeCount += 1;
        isLiked = true;
        likes[currentUserId] = true;
        showHeart = true;
      });
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  handleReportPost() {
    bool _isReported = reports[currentUserId] == true;

    if (_isReported) {
      postsRef
          .doc(ownerId)
          .collection('userPosts')
          .doc(postId)
          .update({'reports.$currentUserId': false});
      removeLikeFromActivityFeed();
      setState(() {
        reportCount -= 1;
        isReported = false;
        reports[currentUserId] = false;
      });
    } else if (!_isReported) {
      postsRef
          .doc(ownerId)
          .collection('userPosts')
          .doc(postId)
          .update({'reports.$currentUserId': true});
      addLikeToActivityFeed();
      setState(() {
        reportCount += 1;
        isReported = true;
        reports[currentUserId] = true;
      });
    }
  }

  buildPostImage() {
    return GestureDetector(
        onDoubleTap: () => handleLikePost(),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            cachedNetworkImage(mediaUrl),
            showHeart
                ? Animator(
                    duration: Duration(milliseconds: 300),
                    tween: Tween(begin: 0.8, end: 1.4),
                    curve: Curves.elasticOut,
                    cycles: 0,
                    builder: (anim) => Transform.scale(
                      scale: anim.value,
                      child: Icon(
                        Icons.favorite,
                        size: 80.0,
                        color: Colors.red,
                      ),
                    ),
                  )
                : Text("")
          ],
        ));
  }

  handleBarter(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("How do you want to Barter?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Barter(
                              currentUserId: currentUserId,
                              postId: postId,
                              ownerId: ownerId),
                        ));
                  },
                  child: Text(
                    'I want to bid Cash!',
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BarterItem(
                              currentUserId: currentUserId,
                              postId: postId,
                              ownerId: ownerId),
                        ));
                  },
                  child: Text(
                    'I want to trade my Item!',
                  )),
            ],
          );
        });
  }

  buildPostFooter() {
    return Column(
      children: <Widget>[
        Text(description),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
            GestureDetector(
              onTap: () => handleLikePost(),
              child: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
                  size: 28.0, color: Colors.pink),
            ),
            Container(
              margin: EdgeInsets.only(left: 3),
              child: Text(
                "$likeCount",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            GestureDetector(
              onTap: () => showComments(context,
                  postId: postId, ownerId: ownerId, mediaUrl: mediaUrl),
              child: Icon(Icons.chat, size: 28.0, color: Colors.blue[900]),
            ),
            Padding(padding: EdgeInsets.only(right: 10.0)),
            Container(
                padding: EdgeInsets.only(top: 2.0),
                child: FlatButton(
                  onPressed: () => handleBarter(context),
                  child: Container(
                    width: 140.0,
                    height: 45.0,
                    child: Text(
                      "Barter",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                )),
            Padding(padding: EdgeInsets.only(right: 10.0)),
            GestureDetector(
              onTap: () => handleReportPost(),
              child: Icon(Icons.report,
                  size: 35.0,
                  color: isReported ? Colors.red[900] : Colors.grey[900]),
            ),
          ],
        ),
      ],
    );
  }

  showComments(BuildContext context,
      {String postId, String ownerId, String mediaUrl}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Comments(
        postId: postId,
        postOwnerId: ownerId,
        postMediaUrl: mediaUrl,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (likes[currentUserId] == true);
    isReported = (reports[currentUserId] == true);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(),
        buildPostImage(),
        buildPostFooter(),
      ],
    );
  }
}
