import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/widgets/post.dart';
import 'package:fluttershare/widgets/postL.dart';
import 'package:fluttershare/widgets/post_tile.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:geolocator/geolocator.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class Timeline extends StatefulWidget {
  final User currentUser;

  Timeline({this.currentUser});
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<Post> posts;
  List<PostL> postsLocal;
  double _currentSliderValue = 1;
  List<String> followingList = [];
  String timelineDecision = "local";
  double posXuser;
  double posYuser;
  void initState() {
    super.initState();
    getTimeline();
    getFollowing();
    getUserLocation();
    getTimelineLocal();
  }

  getTimeline() async {
    QuerySnapshot snapshot = await timelineRef
        .doc(widget.currentUser.id)
        .collection('timelinePosts')
        .orderBy('timestamp', descending: true)
        .get();
    List<Post> posts =
        snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    setState(() {
      this.posts = posts;
    });
  }

  getTimelineLocal() async {
    QuerySnapshot snapshotLocal = await timelineLocalRef
        .doc('test')
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .get();

    List<PostL> postsLocal =
        snapshotLocal.docs.map((doc) => PostL.fromDocument(doc)).toList();
    setState(() {
      this.postsLocal = postsLocal;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .doc(currentUser.id)
        .collection('userFollowing')
        .get();
    setState(() {
      followingList = snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 0.621371 * 12742 * asin(sqrt(a));
    //return mile distance
  }

  getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    posXuser = position.latitude;
    posYuser = position.longitude;
  }

  buildTimeline() {
    if (postsLocal == null) {
      return circularProgress();
    } else if (timelineDecision == "follow") {
      return Column(children: posts);
    } else if (timelineDecision == "local") {
      return Column(children: postsLocal);
    }
  }

  buildSlider() {
    return Slider(
      value: _currentSliderValue,
      min: 0,
      max: 5,
      divisions: 5,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }

  setTimeline(String timelineDecision) {
    setState(() {
      this.timelineDecision = timelineDecision;
    });
  }

  buildToggleTimeline() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () => setTimeline("follow"),
          icon: Icon(Icons.person),
          color: timelineDecision == 'follow'
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
        IconButton(
          onPressed: () => setTimeline("local"),
          icon: Icon(Icons.local_activity),
          color: timelineDecision == 'local'
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
      ],
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hot Place'),
      ),
      body: ListView(
        children: <Widget>[
          buildToggleTimeline(),
          Divider(
            height: 0.0,
          ),
          buildSlider(),
          buildTimeline(),
        ],
      ),
    );
  }
}
