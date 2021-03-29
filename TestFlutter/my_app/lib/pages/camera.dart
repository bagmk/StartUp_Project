import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/imagegallery.dart';
import 'package:my_app/uploadfile.dart';

class Camera extends StatefulWidget {
  Camera({Key key}) : super(key: key);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _clear() {
    setState(() => _image = null);
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _image.path,
        toolbarColor: Colors.purple,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Crop it');

    setState(() {
      _image = cropped ?? _image;
    });
  }

  Future pickImage() async {
    ImagePicker picker = ImagePicker();
    final SelectFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (SelectFile != null) {
        _image = File(SelectFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new RaisedButton(
            onPressed: () async {
              PickedFile selectedFile =
                  await ImagePicker().getImage(source: ImageSource.gallery);
              File file = File(selectedFile.path);

              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new ImageUploadPage(
                          file,
                        )),
              );
            },
            child: new Text(
              "Upload Image from Gallery",
              style: new TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            color: new Color.fromRGBO(0, 153, 145, 1.0),
          ),
          new Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: new RaisedButton(
                onPressed: () async {
                  PickedFile selectedFile =
                      await ImagePicker().getImage(source: ImageSource.camera);
                  File file = File(selectedFile.path);

                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ImageUploadPage(
                              file,
                            )),
                  );
                },
                child: new Text(
                  "Capture Image",
                  style: new TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                color: new Color.fromRGBO(0, 153, 145, 1.0)),
          ),
          new Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: new RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ImageGalley()),
                  );
                },
                child: new Text(
                  "View Images",
                  style: new TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                color: new Color.fromRGBO(0, 153, 145, 1.0)),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return new AppBar(
      centerTitle: true,
      title: const Text(
        'Image Demo',
        style: const TextStyle(
            color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.w300),
      ),
      backgroundColor: const Color.fromRGBO(217, 217, 217, 1.0),
      elevation: 0.0,
    );
  }
}
