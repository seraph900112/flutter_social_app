import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:project/ui/main/homePage.dart';
import 'package:project/ui/main/messagePage.dart';
import 'package:project/ui/main/searchPage.dart';
import 'package:project/ui/main/userInfoPage.dart';
import 'package:project/ui/newPost/newPost.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';

import '../../model/user.dart';
import '../../util/const.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectIndex = 0;
  late User user;
  final List<Widget> bodyWidget = [HomePage(), SearchPage(), MessagePage(), UserInfoPage()];
  late Echo echo;

  void _onItemTap(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    user = User.getInstance();
    webSockets();
  }

  void webSockets() {
    int? id = User.getInstance().id;
    PusherOptions options = PusherOptions(
      host: Const.broadcastUrl,
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
    echo = Echo(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MainPage"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DatabaseList()));
              },
              icon: const Icon(Icons.dataset))
        ],
      ),
      body: IndexedStack(
        index: _selectIndex,
        children: bodyWidget,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewPost()));
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      _selectIndex = 0;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home, color: _selectIndex == 0 ? Colors.orange : Colors.black),
                      Text(
                        "首頁",
                        style: TextStyle(color: _selectIndex == 0 ? Colors.orange : Colors.black),
                      ),
                      //const Padding(padding: EdgeInsets.all(10))
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    _onItemTap(1);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_rounded,
                          color: _selectIndex == 1 ? Colors.orange : Colors.black),
                      Text(
                        "發現",
                        style: TextStyle(color: _selectIndex == 1 ? Colors.orange : Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 2,
                child: InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      _onItemTap(2);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mail, color: _selectIndex == 2 ? Colors.orange : Colors.black),
                        Text(
                          "訊息",
                          style: TextStyle(color: _selectIndex == 2 ? Colors.orange : Colors.black),
                        ),
                        //const Padding(padding: EdgeInsets.only(right: 10))
                      ],
                    )),
              ),
              Expanded(
                flex: 2,
                child: InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    _onItemTap(3);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, color: _selectIndex == 3 ? Colors.orange : Colors.black),
                      Text(
                        "我",
                        style: TextStyle(color: _selectIndex == 3 ? Colors.orange : Colors.black),
                      )
                      //const Padding(padding: EdgeInsets.only(left: 10))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    echo.disconnect();
  }
}
