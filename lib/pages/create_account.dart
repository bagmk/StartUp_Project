import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:fluttershare/models/stripeAccountLink.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final stripeUsersRef = FirebaseFirestore.instance.collection('stripeUsers');

class CreateAccount extends StatefulWidget {
  final String userId;

  const CreateAccount({Key key, this.userId}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  String username;

  submit() async {
    final form = _formkey.currentState;
    if (form.validate()) {
      form.save();
      SnackBar snackbar = SnackBar(content: Text("Welcome $username!"));
      _scaffoldkey.currentState.showSnackBar(snackbar);
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, username);
      });
      await createStripeConnectUser();
    }
  }

  createStripeConnectUser() async {
    // Create the user in Stripe Connect through the http request
    // to the Firebase function, createStripeConnectUser.
    // - Pass in user.id as a query parameter
    // final GoogleSignInAccount user = googleSignIn.currentUser;
    final http.Response response = await http.post(Uri.parse(
        'https://us-central1-fluttershare-188bd.cloudfunctions.net/createStripeConnectUser?id=${widget.userId}'));

    var jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = StripeAccountLink.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get response from createStripeConnectUser.');
    }

    // Use the response to redirect to complete Stripe sign up.
    // - Response should be account link object.
    await FlutterWebBrowser.openWebPage(url: '${jsonResponse.url}');
  }

  createStripeCustomer() {}

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: header(context,
            titleText: "Set up your profile", removeBackButton: true),
        body: ListView(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: Center(
                      child: Text(
                        "Create a username",
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      child: Form(
                        key: _formkey,
                        autovalidate: true,
                        child: TextFormField(
                          validator: (val) {
                            if (val.trim().length < 3 || val.isEmpty) {
                              return "Username too short";
                            } else if (val.trim().length > 12) {
                              return "Username too long";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (val) => username = val,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Username",
                            labelStyle: TextStyle(fontSize: 15.0),
                            hintText: "Must be at least 3 characters",
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: submit,
                    child: Container(
                        height: 50.0,
                        width: 350.0,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        child: Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
