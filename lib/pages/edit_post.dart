import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/custom_image.dart';
import 'package:fluttershare/widgets/progress.dart';

class EditPost extends StatefulWidget {
  final String currentUserId;
  final String postId;
  final String mediaUrl;

  EditPost({this.currentUserId, this.postId, this.mediaUrl});

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  bool isUploading = false;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController tagController = TextEditingController();

  User user;
  String profileUrl;
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isUploading = true;
    });
    DocumentSnapshot doc = await usersRef.doc(widget.currentUserId).get();
    user = User.fromDocument(doc);
    profileUrl = user.profileUrl;

    setState(() {
      isUploading = false;
    });
  }

  updatePostData() {
    postsRef
        .doc(widget.currentUserId)
        .collection('userPosts')
        .doc(widget.postId)
        .update({
      "description": descriptionController.text,
      "tag": tagController.text,
    });

    timelineLocalRef
        .doc('test')
        .collection('userPosts')
        .doc(widget.postId)
        .update({
      "description": descriptionController.text,
      "tag": tagController.text,
    });
    timelineRef.doc('test').collection('userPosts').doc(widget.postId).update({
      "description": descriptionController.text,
      "tag": tagController.text,
    });

    SnackBar snackbar = SnackBar(content: Text("Post updated!"));
    _scaffoldkey.currentState.showSnackBar(snackbar);
    Navigator.pop(context);
  }

  clearImage() {
    setState(() {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          backgroundColor: Colors.white70,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: clearImage,
          ),
          title: Text(
            "Caption Post",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            FlatButton(
              onPressed: isUploading ? null : () => updatePostData(),
              child: Text(
                "Post",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            isUploading ? linearProgress() : Text(""),
            Container(
                height: 220.0,
                width: MediaQuery.of(context).size.width * 0.8,
                child: cachedNetworkImage(widget.mediaUrl)),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(profileUrl),
              ),
              title: Container(
                width: 250.0,
                child: TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: "Write a caption..",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Divider(),
            ListTile(
                leading: Icon(Icons.tag, color: Colors.orange, size: 35.0),
                title: Container(
                  width: 250.0,
                  child: TextField(
                    controller: tagController,
                    decoration: InputDecoration(
                        hintText: "tag your item#", border: InputBorder.none),
                  ),
                )),
          ],
        ));
  }
}
