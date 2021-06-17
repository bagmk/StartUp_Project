import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/edit_profile.dart';
import 'package:fluttershare/pages/follower_following.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/post.dart';
import 'package:fluttershare/widgets/post_tile.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class Profile extends StatefulWidget {
  final String profileId;

  Profile({this.profileId});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isUploading = false;
  File file;
  bool isFollowing = false;
  final String currentUserId = currentUser?.id;
  bool _profileImage = false;
  bool isLoading = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  String profileUrl;

  List<Post> posts = [];
  String postOrientation = "grid";
  String profileId = Uuid().v4();
  Future<String> uploadImage(imageFile) async {
    UploadTask uploadTask =
        storageRef.child("profile_$profileId.jpg").putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  void initState() {
    print('0');
    super.initState();

    getProfilePost();
    getFollowers();
    getFollowing();
    checkIfFollowing();
    print('1');
  }

  getFollowers() async {
    QuerySnapshot snapshot = await followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .get();
    setState(() {
      followerCount = snapshot.docs.length;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .doc(widget.profileId)
        .collection('userFollowing')
        .get();
    setState(() {
      followingCount = snapshot.docs.length;
    });
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId)
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  getProfilePost() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postsRef
        .doc(widget.profileId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      isLoading = false;
      postCount = snapshot.docs.length;
      posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    });
  }

  Column buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Column buildCountColumnFollower(String label, int count) {
    bool isProfileOwner = currentUserId == widget.profileId;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => isProfileOwner ? seeFollowInfo() : "",
          child: Text(
            count.toString(),
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
            onTap: () => isProfileOwner ? seeFollowInfo() : "",
            child: Container(
              margin: EdgeInsets.only(top: 4.0),
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )),
      ],
    );
  }

  seeFollowInfo() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                FollowerFollowing(currentUserId: currentUserId)));
  }

  Column buildCountColumnFollowing(String label, int count) {
    bool isProfileOwner = currentUserId == widget.profileId;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => isProfileOwner ? seeFollowInfo() : "",
          child: Text(
            count.toString(),
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          onTap: () => isProfileOwner ? seeFollowInfo() : "",
          child: Container(
            margin: EdgeInsets.only(top: 4.0),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        )
      ],
    );
  }

  Container buildButton({String text, Function function}) {
    return Container(
        padding: EdgeInsets.only(top: 2.0),
        child: FlatButton(
          onPressed: function,
          child: Container(
            width: 200.0,
            height: 27.0,
            child: Text(
              text,
              style: TextStyle(
                  color: isFollowing ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: isFollowing ? Colors.white : Colors.blue,
                border:
                    Border.all(color: isFollowing ? Colors.grey : Colors.blue),
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ));
  }

  Container buildButton1({String text, Function function}) {
    return Container(
        padding: EdgeInsets.only(top: 2.0),
        child: FlatButton(
          onPressed: function,
          child: Container(
            width: 200.0,
            height: 27.0,
            child: Text(
              text,
              style: TextStyle(
                  color: isFollowing ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: isFollowing ? Colors.white : Colors.blue,
                border:
                    Border.all(color: isFollowing ? Colors.grey : Colors.blue),
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ));
  }

  editProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfile(currentUserId: currentUserId)));
  }

  buildProfileButton() {
    //viwing own profile -show edit profile
    print('4');
    bool isProfileOwner = currentUserId == widget.profileId;
    if (isProfileOwner) {
      return buildButton(text: "Edit Profile", function: editProfile);
    } else if (isFollowing) {
      return buildButton(text: "Unfollow", function: handleUnfollowUser);
    } else if (!isFollowing) {
      return buildButton1(
        text: "Follow",
        function: handleFollowUser,
      );
    }
  }

  handleUnfollowUser() {
    setState(() {
      isFollowing = false;
    });
    // remove follower
    followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // remove following
    followingRef
        .doc(currentUserId)
        .collection('userFollowing')
        .doc(widget.profileId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // delete activity feed item for them
    activityFeedRef
        .doc(widget.profileId)
        .collection('feedItems')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleFollowUser() async {
    print('6');
    setState(() {
      isFollowing = true;
    });
    print('7');
    // Make auth user follower of THAT user (update THEIR followers collection)
    followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId)
        .set({
      "username": currentUser.username,
      "timestamp": timestamp,
      "userProfileImg": currentUser.photoUrl,
      "ownerId": widget.profileId,
    });
    // Put THAT user on YOUR following collection (update your following collection)

    DocumentSnapshot doc = await usersRef.doc(widget.profileId).get();
    User user = User.fromDocument(doc);

    followingRef
        .doc(currentUserId)
        .collection('userFollowing')
        .doc(widget.profileId)
        .set({
      "timestamp": timestamp,
      "ownerId": widget.profileId,
      "username": user.displayName,
      "userProfileImg": user.photoUrl,
    });

    // add activity feed item for that user to notify about new follower (us)
    activityFeedRef
        .doc(widget.profileId)
        .collection('feedItems')
        .doc(currentUserId)
        .set({
      "type": "follow",
      "ownerId": widget.profileId,
      "username": currentUser.username,
      "userId": currentUserId,
      "userProfileImg": currentUser.photoUrl,
      "timestamp": timestamp,
    });
  }

  createPostInFirestore({String profileUrl}) async {
    await usersRef.doc(currentUserId).update({"profileUrl": profileUrl});
    setState(() {
      file = null;
      profileId = Uuid().v4();
      isUploading = false;
    });
  }

  hadleSumit() async {
    setState(() {
      isUploading = true;
      _profileImage = true;
    });

    await compressImage();

    String profileUrl = await uploadImage(file);
    createPostInFirestore(
      profileUrl: profileUrl,
    );
  }

  Scaffold buildUploadForm(file) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white70,
          actions: [
            FlatButton(
              onPressed: isUploading ? null : () => hadleSumit(),
              child: Text(
                "Post",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            )
          ],
          title: Text(
            "Profile Picture",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ListView(
          children: <Widget>[
            isUploading ? linearProgress() : Text(""),
            Container(
              height: 550.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                  child: AspectRatio(
                aspectRatio: 1 / 1.5,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(file),
                  )),
                ),
              )),
            ),
          ],
        ));
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$profileId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 20));
    setState(() {
      file = compressedImageFile;
    });
  }

  handleTakePhoto() async {
    Navigator.pop(context);

    PickedFile fileSelect = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    File file = File(fileSelect.path);
    setState(() {
      this.file = file;
    });
  }

  handleChooseFromGallory() async {
    Navigator.pop(context);
    PickedFile fileSelect =
        await ImagePicker().getImage(source: ImageSource.gallery);
    File file = File(fileSelect.path);
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentContext) async {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Create Post"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Photo with Camera"),
                onPressed: handleTakePhoto,
              ),
              SimpleDialogOption(
                child: Text("Image from Gallery"),
                onPressed: handleChooseFromGallory,
              ),
            ],
          );
        });
  }

  buildProfileHeader() {
    return FutureBuilder(
      future: usersRef.doc(widget.profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);

        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  GestureDetector(
                    onTap: () => selectImage(context),
                    child: CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            CachedNetworkImageProvider(user.profileUrl)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildCountColumn("posts", postCount),
                            buildCountColumnFollower(
                              "followers",
                              followerCount,
                            ),
                            buildCountColumnFollowing(
                                "following", followingCount),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[buildProfileButton()],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    user.displayName,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                  )),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 2.0),
                  child: Text(
                    user.bio,
                  ))
            ],
          ),
        );
      },
    );
  }

  buildProfilePost() {
    if (isLoading) {
      return circularProgress();
    } else if (posts.isEmpty) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/no_content.svg',
              height: 260.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "No Posts",
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    } else if (postOrientation == "grid") {
      List<GridTile> gridTiles = [];
      posts.forEach((post) {
        gridTiles.add(GridTile(child: PostTile(post)));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTiles,
      );
    } else if (postOrientation == "list") {
      return Column(children: posts);
    }
  }

  setPostOrientation(String postOrientation) {
    setState(() {
      this.postOrientation = postOrientation;
    });
  }

  buildTogglePostOreintation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () => setPostOrientation("grid"),
          icon: Icon(Icons.grid_on),
          color: postOrientation == 'grid'
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
        IconButton(
          onPressed: () => setPostOrientation("list"),
          icon: Icon(Icons.list),
          color: postOrientation == 'list'
              ? Theme.of(context).primaryColor
              : Colors.grey,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null
        ? Scaffold(
            appBar: header(context, titleText: "Profile"),
            body: ListView(
              children: <Widget>[
                buildProfileHeader(),
                Divider(),
                buildTogglePostOreintation(),
                Divider(
                  height: 0.0,
                ),
                buildProfilePost(),
              ],
            ),
          )
        : buildUploadForm(file);
  }
}
