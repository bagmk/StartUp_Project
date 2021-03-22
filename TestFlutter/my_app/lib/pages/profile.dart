import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app/login_page.dart';
import 'package:my_app/main.dart';
import 'package:my_app/pages/home_page.dart';

class Profile extends StatefulWidget {
  final Function(User) onSignOut;

  Profile({@required Key key, @required this.onSignOut}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Profile")),
        body: Column(
          children: [
            RaisedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyApp()))
                    .then((value) {
                  setState(() {});
                });

                logout();
              },
              child: Text("Sign Out"),
            )
          ],
        ));
  }
}
