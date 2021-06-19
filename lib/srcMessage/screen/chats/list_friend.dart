import 'package:flutter/material.dart';
import 'package:fluttershare/srcMessage/models/list_friend_model.dart';
import 'package:fluttershare/srcMessage/screen/chats/widgets/conversation_item.dart';
import 'package:fluttershare/srcMessage/widgets/messenger_app_bar/messenger_app_bar.dart';

class ListFriend extends StatefulWidget {
  ListFriend({Key key}) : super(key: key);

  _ListFriendState createState() => _ListFriendState();
}

class _ListFriendState extends State<ListFriend> {
  ScrollController _controller;
  bool _isScroll = false;

  _scrollListener() {
    if (_controller.offset > 0) {
      this.setState(() {
        _isScroll = true;
      });
    } else {
      this.setState(() {
        _isScroll = false;
      });
    }
  }

  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: <Widget>[
            _buildMessengerAppBar(_isScroll),
            _buildRootListView(),
          ],
        ),
      ),
    );
  }

  _buildMessengerAppBar(_isScroll) {
    return (MessengerAppBar(
      isScroll: _isScroll,
      title: 'Message',
      actions: <Widget>[],
    ));
  }

  _buildRootListView() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(top: 10.0),
        controller: _controller,
        itemBuilder: (context, index) {
          return ConversationItem(
            friendItem: friendList[index],
          );
        },
        itemCount: friendList.length,
      ),
    );
  }
}
