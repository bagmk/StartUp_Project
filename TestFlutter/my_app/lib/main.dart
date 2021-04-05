import 'package:flutter/material.dart';
import 'tree.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:my_app/pages/camera.dart';
import 'package:my_app/pages/home_page.dart';
import 'package:my_app/pages/SplashScreen.dart';

//List<CameraDescription> camera ; //new

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //camera = await availableCameras(); //new
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(7, 94, 84, 1.0),
        secondaryHeaderColor: Color.fromRGBO(37, 211, 102, 1.0),
        highlightColor: Color.fromRGBO(18, 140, 126, 1.0),
        cardColor: Color.fromRGBO(250, 250, 250, 1.0),
        accentColor: Color.fromRGBO(236, 229, 221, 1.0),
      ),
      home: SplashScrren(),
    );
  }
}

// class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//       home: Tree(),
//    );
//  }
// }
