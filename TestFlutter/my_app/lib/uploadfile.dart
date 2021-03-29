import 'dart:async';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:my_app/pages/camera.dart';

import 'package:firebase_database/firebase_database.dart';

class ImageUploadPage extends StatefulWidget {
  File file;

  ImageUploadPage(this.file);
  @override
  _ImageUploadPageState createState() => new _ImageUploadPageState(file);
}

class _ImageUploadPageState extends State<ImageUploadPage>
    with SingleTickerProviderStateMixin {
  bool loading = false;
  FirebaseDatabase database;

  DatabaseReference reference;

  List<String> filesSub, filesSubSub;
  String filtype;
  String fileName;
  double fileSize = 0.0;
  File file;

  _ImageUploadPageState(this.file);

  void getFileSize() async {
    int length = await file.length();
    print("FILE SIZE" + length.toString());

    fileSize = (length / 1024);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    database = FirebaseDatabase.instance;
    reference = database.reference().child("images/");

    fileName = file.path;
    filesSub = fileName.split("/");
    filesSubSub = filesSub[filesSub.length - 1].split(".");
    filtype = filesSubSub[filesSubSub.length - 1]
        .replaceAll(new RegExp("[0-9]*"), "");
    print("FILE TYPE" + filtype);

    getFileSize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _uploadData(BuildContext context) async {
    int r = new Random().nextInt(100000);
    FirebaseStorage storage = FirebaseStorage.instance;

    Reference ref = storage.ref().child(r.toString() + "." + filtype);
    UploadTask uploadTask = ref.putFile(file);

    String url;
    uploadTask.whenComplete(() async {
      url = await ref.getDownloadURL();
    }).catchError((onError) {
      print(onError);
    });

    print(url.toString());

    reference.push().set({"image": url.toString()});

    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Upload Image',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w300),
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(217, 217, 217, 1.0),
        elevation: 0.0,
      ),
      body: new Container(
        color: new Color.fromRGBO(255, 255, 255, 1.0),
        child: new Stack(
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Container(
                  margin: new EdgeInsets.all(18.0),
                  height: 220.0,
                  color: new Color.fromRGBO(229, 228, 228, 1.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        margin: new EdgeInsets.only(
                            top: 20.0, left: 30.0, right: 30.0),
                        height: 100.0,
                        child: new Image.file(file),
                      ),
                      new Container(
                        margin: new EdgeInsets.only(
                            top: 30.0, left: 30.0, right: 30.0),
                        child: new TextField(
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: new InputDecoration.collapsed(
                              hintText:
                                  filesSub[filesSub.length - 1].split(".")[0],
                              hintStyle: new TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14.0,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                      new Container(
                        margin: new EdgeInsets.only(
                            top: 3.0, left: 30.0, right: 30.0),
                        height: 3.0,
                        color: new Color.fromRGBO(21, 160, 103, 1.0),
                      ),
                      new Container(
                        margin: new EdgeInsets.only(top: 5.0, left: 30.0),
                        child: new Text(
                          fileSize.toStringAsFixed(2) + " KB",
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                              color: Colors.black87,
                              fontSize: 14.0,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
                new GestureDetector(
                  onTap: () {
                    setState(() {
                      loading = true;
                    });
                    _uploadData(context);
                  },
                  child: new ClipRRect(
                    borderRadius: new BorderRadius.only(
                        bottomLeft: new Radius.circular(10.0),
                        bottomRight: new Radius.circular(10.0),
                        topLeft: new Radius.circular(10.0),
                        topRight: new Radius.circular(10.0)),
                    child: new Container(
                      alignment: Alignment.center,
                      margin: new EdgeInsets.only(top: 50.0),
                      height: 40.0,
                      width: 150.0,
                      color: new Color.fromRGBO(0, 153, 145, 1.0),
                      child: new Text(
                        "UPLOAD",
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
            loading
                ? new Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.white70,
                    child: new Center(child: new CircularProgressIndicator()),
                  )
                : new Container()
          ],
        ),
      ), //new
    );
  }
}
