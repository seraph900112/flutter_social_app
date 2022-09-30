import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/ui/chatRoom/chatRoom.dart';

import '../ui/main/mainPage.dart';

class ChatBar extends StatefulWidget {
  const ChatBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatBarState();
}

class _ChatBarState extends State<ChatBar> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context,  MaterialPageRoute(builder: (context)=>const ChatRoom()));
      },
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                    backgroundImage: AssetImage("assets/images/Miko_2020.webp")),
                Expanded(
                    child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "NanaKawa Miko",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      "你好帅<3",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Text("15:33"),
                    Container(
                      alignment: Alignment.center,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6)),
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
