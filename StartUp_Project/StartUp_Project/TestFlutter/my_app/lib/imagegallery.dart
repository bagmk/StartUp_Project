import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ImageGalley extends StatefulWidget {
  @override
  _ImageGalleyState createState() => _ImageGalleyState();
}

class _ImageGalleyState extends State<ImageGalley>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                'Image Gallery',
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
        body: new StreamBuilder(
            stream:
                FirebaseDatabase.instance.reference().child("images").onValue,
            builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
              if (snapshot.hasData) {
                Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                map.forEach((dynamic, v) => print(v["image"]));
                return new GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: map.values.toList().length,
                  padding: const EdgeInsets.all(2.0),
                  itemBuilder: (BuildContext context, int index) {
                    return new Container(
                      child: Image.network(
                        map.values.toList()[index]["image"],
                        fit: BoxFit.cover,
                      ),
                      padding: const EdgeInsets.all(2.0),
                    );
                  },
                );
              } else {
                return new Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.white70,
                    child: new Center(child: new CircularProgressIndicator()));
              }
            }));
  }
}
