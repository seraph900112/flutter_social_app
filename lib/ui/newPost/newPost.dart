import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../model/user.dart';

class NewPost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewPostState();
}

class NewPostState extends State<NewPost> {
  TextEditingController controller = TextEditingController();
  double iconSize = 50.0;

  Future<void> post() async {
    String? token = User.getInstance().token;
    var url = Uri.http('192.168.1.106:8000', 'api/addpost');
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $token',
    }, body: {
      'posterId': User.getInstance().id.toString(),
      'hasText': '1',
      'hasPhoto': '0',
      'text': controller.text,
    });
    print(controller.text);
    print(token);
    print(response.body);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Add a New Post'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Color(0xFFFFA726), alignment: Alignment.center),
                  onPressed: () {
                    post();
                  },
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10, left: 2, right: 2),
          child: Column(
            children: [
              Expanded(
                  child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                autofocus: true,
                controller: controller,
                decoration: const InputDecoration(
                    hintText: 'Share something new !',
                    enabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder:
                        UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent))),
                cursorColor: Colors.orange,
              )),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.photo, size: iconSize)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.tag, size: iconSize)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.gif_outlined, size: iconSize)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.face, size: iconSize)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.add, size: iconSize)),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
