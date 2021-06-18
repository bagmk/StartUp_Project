import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/activity_feed.dart';

import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/buy_list.dart';
import 'package:fluttershare/widgets/sell_list.dart';

class BuySell extends StatefulWidget {
  final String profileId;

  BuySell({this.profileId});
  @override
  _BuySellState createState() => _BuySellState();
}

class _BuySellState extends State<BuySell> {
  bool isLoading = false;
  final String currentUserId = currentUser?.id;
  int buyCount = 0;
  int sellCount = 0;
  List<BuyList> buyList = [];
  List<SellList> sellList = [];
  String buyOrSell = "buy";

  @override
  void initState() {
    super.initState();
    getBuyList();
    getSellList();
  }

  getBuyList() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await buyRef
        .doc(widget.profileId)
        .collection('barter')
        .orderBy('timestamp', descending: true)
        .get();
    if (mounted) {
      setState(() {
        isLoading = false;
        buyCount = snapshot.docs.length;
        buyList =
            snapshot.docs.map((doc) => BuyList.fromDocument(doc)).toList();
      });
    }
  }

  getSellList() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await sellRef
        .doc(widget.profileId)
        .collection('barter')
        .orderBy('timestamp', descending: true)
        .get();
    if (mounted) {
      setState(() {
        isLoading = false;
        sellCount = snapshot.docs.length;
        sellList =
            snapshot.docs.map((doc) => SellList.fromDocument(doc)).toList();
      });
    }
  }

  buildProfilePost() {
    if (buyOrSell == "buy") {
      return Column(children: buyList);
    } else if (buyOrSell == "sell") {
      return Column(children: sellList);
    }
  }

  setbuyOrSell(String buyOrSell) {
    setState(() {
      this.buyOrSell = buyOrSell;
    });
  }

  buildTogglePostOreintation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TextButton(
            onPressed: () => setbuyOrSell("buy"),
            child: Text("BuyList",
                style: TextStyle(
                    color: buyOrSell == 'buy'
                        ? Theme.of(context).primaryColor
                        : Colors.grey)),
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
            )),
        TextButton(
            onPressed: () => setbuyOrSell("sell"),
            child: Text('sell',
                style: TextStyle(
                    color: buyOrSell == 'sell'
                        ? Theme.of(context).primaryColor
                        : Colors.grey)),
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barter'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ActivityFeed()));
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Divider(),
          buildTogglePostOreintation(),
          Divider(
            height: 0.0,
          ),
          buildProfilePost(),
        ],
      ),
    );
  }
}
