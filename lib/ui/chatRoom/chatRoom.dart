import 'dart:convert';

import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:http/http.dart' as http;
import '../../model/chat.dart';
import '../../model/user.dart';
import '../../util/const.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _textEditingController = TextEditingController();
  ScrollController controller = ScrollController();
  List<Chat> chatContent = <Chat>[];


  @override
  void initState() {
    super.initState();
    _textEditingController.text = "5168415";

    print('456');
  }
  void webSockets(){
    int? id = User.getInstance().id;
    PusherOptions options = PusherOptions(
      host: '192.168.1.106',
      wsPort: 6001,
      encrypted: false,
    );
    // Create pusher client
    PusherClient pusherClient = PusherClient(
      Const.PUSHER_KEY,
      options,
      autoConnect: false,
      enableLogging: false,
    );
    // Create echo instance
    Echo echo = Echo(
      broadcaster: EchoBroadcasterType.Pusher,
      client: pusherClient,
    );
    // Listening public channel
    echo.channel('chat.$id').listen('Chat', (e) {
      print(e.data);
    });
    // Accessing pusher instance
    echo.connector.pusher.onConnectionStateChange((state) {
      print(state!.currentState.toString());
    });
  }

  void showToast(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  @override
  Widget build(BuildContext context) {
    webSockets();
    return Scaffold(
      appBar: AppBar(title: const Text("HIII123")),
      body: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  chatList(),
                  MessageBar(
                    onSend: (message) async {
                      setState(() {
                        chatContent.insert(0, Chat(true, "text", message));
                      });
                      var url = Uri.http('192.168.1.106:8000', 'api/chat');
                      var response = await http.post(url, body: {
                        'sender_id': '2',
                        'receive_id': '2',
                        'content': message
                      });
                      print(response.body);
                    },
                    actions: [
                      InkWell(
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 24,
                        ),
                        onTap: () {},
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: InkWell(
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.green,
                            size: 24,
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget chatList() {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        reverse: true,
        itemCount: chatContent.length,
        itemBuilder: (BuildContext context, int index) {
          return chatContent.elementAt(index).isSender
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (chatContent.elementAt(index).type == "text") ...[
                      BubbleSpecialThree(
                        text: chatContent.elementAt(index).content,
                        color: const Color(0xFF1B97F3),
                        isSender: chatContent.elementAt(index).isSender,
                        tail: true,
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/Miko_2020.webp")),
                    ]
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                        backgroundImage:
                            AssetImage("assets/images/Miko_2020.webp")),
                    BubbleSpecialThree(
                      text: chatContent.elementAt(index).content,
                      color: const Color(0xFF1B97F3),
                      isSender: chatContent.elementAt(index).isSender,
                      tail: true,
                      textStyle:
                          const TextStyle(color: Colors.white, fontSize: 16),
                    )
                  ],
                );
        },
      ),
    );
  }
}
