import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/login_page.dart';
import 'package:my_app/main.dart';
import 'package:my_app/pages/home_page.dart';

class Profile extends StatefulWidget {
  final Function(User) onSignOut;
  final String currentUserId;

  Profile(
      {@required Key key,
      @required this.onSignOut,
      @required this.currentUserId})
      : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User user;

  final usersRef = FirebaseFirestore.instance.collection('users');

  bool _displayName = true;
  TextEditingController displayNameController = TextEditingController();
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  updateProfileData() {
    setState(() {
      displayNameController.text.trim().length < 3 ||
              displayNameController.text.isEmpty
          ? _displayName = false
          : _displayName = true;
    });

    if (_displayName) {
      usersRef.doc(widget.currentUserId).update({
        "displayName": displayNameController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
                hintText: "Username",
                errorText: _displayName ? null : "display Name too short"),
          ),
          SizedBox(height: 20.0),
          RaisedButton(
            onPressed: updateProfileData,
            child: Text("Save Profile"),
          ),
          RaisedButton(
            onPressed: () {
              logout();
              Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => MyApp()))
                  .then((value) {
                setState(() {});
              });
            },
            child: Text("Sign Out"),
          ),
        ],
      ),
    );
  }
}
