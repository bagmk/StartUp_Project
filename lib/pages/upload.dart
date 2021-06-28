import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

class Upload extends StatefulWidget {
  final User currentUser;
  final String itemName;

  Upload({
    this.currentUser,
    this.itemName,
  });
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload>
    with AutomaticKeepAliveClientMixin<Upload> {
  File file;
  final String itemName;

  bool isUploading = false;
  String postId = Uuid().v4();
  TextEditingController captionController1 = TextEditingController();
  TextEditingController captionController2 = TextEditingController();
  TextEditingController captionController3 = TextEditingController();
  TextEditingController locationController = TextEditingController();
  double posX;
  double posY;
  Future<String> uploadImage(imageFile) async {
    UploadTask uploadTask =
        storageRef.child("post_$postId.jpg").putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  _UploadState({this.itemName});

  createPostInFirestore(
      {String mediaUrl,
      double posX,
      double posY,
      String description,
      String location,
      String tag,
      String itemName}) {
    postsRef
        .doc(widget.currentUser.id)
        .collection("userPosts")
        .doc(postId)
        .set({
      "postId": postId,
      "ownerId": widget.currentUser.id,
      "item": itemName,
      "username": widget.currentUser.username,
      "mediaUrl": mediaUrl,
      "description": description,
      "tag": tag,
      "posX": posX,
      "posY": posY,
      "location": location,
      "timestamp": DateTime.now(),
      "likes": {},
      "reports": {},
    });
    timelineLocalRef.doc('test').collection("userPosts").doc(postId).set({
      "postId": postId,
      "ownerId": widget.currentUser.id,
      "item": itemName,
      "username": widget.currentUser.username,
      "mediaUrl": mediaUrl,
      "description": description,
      "tag": tag,
      "posX": posX,
      "posY": posY,
      "location": location,
      "timestamp": DateTime.now(),
      "likes": {},
      "reports": {},
    });
    locationController.clear();
    captionController1.clear();
    captionController2.clear();
    captionController3.clear();
    setState(() {
      file = null;
      isUploading = false;
      postId = Uuid().v4();
    });
  }

  hadleSumit() async {
    setState(() {
      isUploading = true;
    });

    await compressImage();
    await getUserLocation();

    String mediaUrl = await uploadImage(file);
    createPostInFirestore(
      mediaUrl: mediaUrl,
      posX: posX,
      posY: posY,
      location: locationController.text,
      description: captionController2.text,
      tag: captionController3.text,
      itemName: captionController1.text,
    );
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Upload done"),
          content: new Text("Your item is uploaded"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
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

  selectImage(parentContext) {
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
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  Container buildSplashScreen() {
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            'assets/images/upload.svg',
            height: 260.0,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                "Upload Image",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              ),
              color: Colors.deepOrange,
              onPressed: () => selectImage(context),
            ),
          )
        ],
      ),
    );
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  Scaffold buildUploadForm(file) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white70,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: clearImage,
          ),
          title: Text(
            "Descript Item",
            style: TextStyle(color: Colors.black),
          ),
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
        ),
        body: ListView(
          children: <Widget>[
            isUploading ? linearProgress() : Text(""),
            Container(
              height: 220.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                  child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(file),
                  )),
                ),
              )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            ListTile(
              leading: Icon(Icons.title, color: Colors.black, size: 20.0),
              title: Container(
                width: 250.0,
                child: TextField(
                  controller: captionController1,
                  decoration: InputDecoration(
                    hintText: "Write item name",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.short_text, color: Colors.black, size: 20.0),
              title: Container(
                width: 250.0,
                child: TextField(
                  controller: captionController2,
                  decoration: InputDecoration(
                    hintText: "Write a description..",
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
                    controller: captionController3,
                    decoration: InputDecoration(
                        hintText: "tag your item#", border: InputBorder.none),
                  ),
                )),
          ],
        ));
  }

  getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    posX = position.latitude;
    posY = position.longitude;
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String address = '${placemark.locality},${placemark.country}';
    locationController.text = address;
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return file == null ? buildSplashScreen() : buildUploadForm(file);
  }
}
