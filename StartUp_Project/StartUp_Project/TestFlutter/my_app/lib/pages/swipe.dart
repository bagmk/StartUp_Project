import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class Swipe extends StatefulWidget {
  Swipe({Key key}) : super(key: key);

  @override
  _SwipeState createState() => _SwipeState();
}

class _SwipeState extends State<Swipe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Swipe"),
        ),
        body: new Swiper(
          itemBuilder: (BuildContext context, int index) {
            return new Image.network(
              "http://via.placeholder.com/288x188",
              fit: BoxFit.fill,
            );
          },
          itemCount: 10,
          itemWidth: 300.0,
          itemHeight: 400.0,
          layout: SwiperLayout.TINDER,
        ));
  }
}
