import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  final Function(User) onSignInAno;
  LoginPage({@required this.onSignInAno});

  loginAno() async {
    UserCredential userCredenntial =
        await FirebaseAuth.instance.signInAnonymously();
    onSignInAno(userCredenntial.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Login Page")),
        body: RaisedButton(
          onPressed: () {
            loginAno();
          },
          child: Text("Sign In Ano"),
        ));
  }
}
