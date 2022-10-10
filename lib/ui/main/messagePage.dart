import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../model/chat.dart';
import '../../model/user.dart';
import '../../util/const.dart';
import '../../widget/chatBar.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Chat> chat = <Chat>[];
  List<String> names = <String>[];

  Future<void> onRefresh() async {
    getChat();
  }

  Future<void> getChat() async {
    chat.clear();
    names.clear();
    String token = User.getInstance().token;
    int? id = User.getInstance().id;
    var uri = Uri.http(Const.url, 'api/getchat', {'id': id.toString()});
    var response = await http.get(uri, headers: {'Authorization': 'Bearer $token'});
    List<dynamic> responseList = jsonDecode(response.body);
    print(response.body);
    setState(() {
      responseList.forEach((element) {
        names.add(element['name']);
        chat.add(Chat.fromJson(element, element['sender_id'] == id));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getChat();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.builder(
          itemCount: chat.length,
          itemBuilder: (BuildContext context, int index) {
            return ChatBar(
              name: names[index],
              chat: chat[index],
            );
          },
        ));
  }
}
