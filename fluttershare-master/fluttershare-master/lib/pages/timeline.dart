import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/progress.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  void initState() {
/*     getUsers(); */
    getUsersById();
    super.initState();
  }

/*   getUsers() {
    usersRef.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        print(doc.data);
        print(doc.id);
        print(doc.exists);
      });
    });
  } */

  getUsersById() {
    final String id = '41ZB0bpATig5s7rrPKcq';
    usersRef.doc(id).get().then((DocumentSnapshot doc) {
      print(doc.data);
      print(doc.id);
      print(doc.exists);
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: circularProgress(),
    );
  }
}
