import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:fluttershare/pages/home.dart';

import 'package:fluttershare/widgets/follower_list.dart';
import 'package:fluttershare/widgets/following_list.dart';

class FollowerFollowing extends StatefulWidget {
  final String currentUserId;

  FollowerFollowing({this.currentUserId});
  @override
  _FollowerFollowingState createState() => _FollowerFollowingState();
}

class _FollowerFollowingState extends State<FollowerFollowing> {
  bool isLoading = false;
  final String currentUserId = currentUser?.id;
  int followerCount = 0;
  int followingCount = 0;
  List<FollowerList> followerList = [];
  List<FollowingList> followingList = [];
  String followerOrFollowering = "following";

  @override
  void initState() {
    super.initState();

    getFollowerList();
    getFollowingList();
  }

  getFollowerList() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await followersRef
        .doc(currentUserId)
        .collection('userFollowers')
        .orderBy('timestamp', descending: true)
        .get();

    if (mounted) {
      setState(() {
        isLoading = false;
        followerCount = snapshot.docs.length;
        followerList =
            snapshot.docs.map((doc) => FollowerList.fromDocument(doc)).toList();
      });
    }
  }

  getFollowingList() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await followingRef
        .doc(currentUserId)
        .collection('userFollowing')
        .orderBy('timestamp', descending: true)
        .get();

    if (mounted) {
      setState(() {
        isLoading = false;
        followingCount = snapshot.docs.length;
        followingList = snapshot.docs
            .map((doc) => FollowingList.fromDocument(doc))
            .toList();
      });
    }
  }

  buildProfilePost() {
    if (followerOrFollowering == "follower") {
      return Column(children: followerList);
    } else if (followerOrFollowering == "following") {
      return Column(children: followingList);
    }
  }

  setFollowerOrFollowering(String followerOrFollowering) {
    setState(() {
      this.followerOrFollowering = followerOrFollowering;
    });
  }

  buildTogglePostOreintation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TextButton(
          onPressed: () => setFollowerOrFollowering("follower"),
          child: Text('Follower',
              style: TextStyle(
                  color: followerOrFollowering == 'follower'
                      ? Theme.of(context).primaryColor
                      : Colors.grey)),
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
          ),
        ),
        TextButton(
            onPressed: () => setFollowerOrFollowering("following"),
            child: Text('following',
                style: TextStyle(
                    color: followerOrFollowering == 'following'
                        ? Theme.of(context).primaryColor
                        : Colors.grey)),
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info'),
      ),
      body: ListView(
        children: <Widget>[
          Divider(),
          buildTogglePostOreintation(),
          Divider(
            height: 0.0,
          ),
          buildProfilePost(),
        ],
      ),
    );
  }
}
