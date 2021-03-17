import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  final Function(User) onSignIn;
  LoginPage({@required this.onSignIn});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerpassword = TextEditingController();

  String error = "";
  bool login = true;

  Future<void> loginUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _controllerEmail.text, password: _controllerpassword.text);
      print(userCredential.user);
      widget.onSignIn(userCredential.user);
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message;
      });
    }
  }

  Future<void> createUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _controllerEmail.text, password: _controllerpassword.text);
      print(userCredential.user);
      widget.onSignIn(userCredential.user);
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Login Page")),
        body: Column(
          children: [
            RaisedButton(
              onPressed: () {
                loginUser();
              },
              child: Text("Sign In"),
            ),
            TextFormField(
                controller: _controllerEmail,
                decoration: InputDecoration(hintText: "Email")),
            TextFormField(
              controller: _controllerpassword,
              decoration: InputDecoration(hintText: "Password"),
            ),
            Text(error),
            RaisedButton(
              onPressed: () {
                login ? loginUser() : createUser();
              },
              child: Text(login ? "Login into Account" : "Create User"),
            ),
            OutlineButton(
              onPressed: () {
                setState(() {
                  login = !login;
                });
              },
              child: Text("Switch Login/Create Account"),
            )
          ],
        ));
  }
}
