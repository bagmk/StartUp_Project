import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/activity_feed.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/buy_list.dart';
import 'package:fluttershare/widgets/sell_list.dart';

class FollowerFollowing extends StatefulWidget {
  final String profileId;

  FollowerFollowing({this.profileId});
  @override
  _FollowerFollowingState createState() => _FollowerFollowingState();
}

class _FollowerFollowingState extends State<FollowerFollowing> {
  bool isLoading = false;
  final String currentUserId = currentUser?.id;
  int followerCount = 0;
  int followingCount = 0;
  List<FollowerFollowing> followerList = [];
  List<FollowerFollowing> followingList = [];
  String followerOrFollowering = "follower";

  @override
  void initState() {
    super.initState();
    getBuyList();
    getSellList();
  }

  getBuyList() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await buyRef
        .doc(widget.profileId)
        .collection('barter')
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

  getSellList() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await sellRef
        .doc(widget.profileId)
        .collection('barter')
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
        IconButton(
          onPressed: () => setFollowerOrFollowering("follower"),
          icon: Icon(Icons.dangerous),
          color: followerOrFollowering == 'follower'
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
        IconButton(
          onPressed: () => setFollowerOrFollowering("following"),
          icon: Icon(Icons.shop),
          color: followerOrFollowering == 'following'
              ? Theme.of(context).primaryColor
              : Colors.grey,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barter'),
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
