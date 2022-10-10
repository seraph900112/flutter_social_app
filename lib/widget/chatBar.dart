import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/ui/chatRoom/chatRoom.dart';

import '../model/chat.dart';
import '../ui/main/mainPage.dart';

class ChatBar extends StatefulWidget {
  const ChatBar({Key? key, required this.chat, required this.name}) : super(key: key);
  final String name;
  final Chat chat;

  @override
  State<StatefulWidget> createState() => _ChatBarState();
}

class _ChatBarState extends State<ChatBar> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatRoom(
                        chatName: widget.name,
                        chatId: widget.chat.senderId,
                      )));
        },
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(backgroundImage: AssetImage("assets/images/Miko_2020.webp")),
                Expanded(
                    child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      widget.chat.content,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                )),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(widget.chat.createdAt),
                    Container(
                      alignment: Alignment.center,
                      width: 30,
                      decoration:
                          BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6)),
                      child: const Text(
                        "12",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  ]),
                ),
              ],
            ),
            const Divider(
              color: Colors.black,
            )
          ],
        ));
  }
}
