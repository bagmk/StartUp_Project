import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String photoUrl;
  final String email;
  final String displayName;
  final String bio;
  final double posXuser;
  final double posYuser;
  final String profileUrl;

  User(
      {this.id,
      this.username,
      this.email,
      this.photoUrl,
      this.displayName,
      this.bio,
      this.posXuser,
      this.posYuser,
      this.profileUrl});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        id: doc.data()['id'],
        email: doc.data()['email'],
        username: doc.data()['username'],
        photoUrl: doc.data()['photoUrl'],
        displayName: doc.data()['displayName'],
        bio: doc.data()['bio'],
        posXuser: doc.data()['posXuser'],
        posYuser: doc.data()['posYuser'],
        profileUrl: doc.data()['profileUrl']);
  }
}
