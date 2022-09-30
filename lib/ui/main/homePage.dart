import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../model/user.dart';
import '../../model/post.dart';
import '../../widget/postWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> postList = <Post>[];

  Future<void> onRefresh() async {
    String? token = User.getInstance().token;
    var uri = Uri.http('192.168.1.106:8000', 'api/getpost');
    var response = await http.get(uri, headers: {'Authorization': 'Bearer $token'});
    print(response.statusCode);
    List<dynamic> responseList = jsonDecode(response.body);
    setState(() {
      responseList.forEach((element) {
        Post post = Post.empty();
        post.fromJson(element);
        postList.add(post);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: onRefresh,
        displacement: 5,
        notificationPredicate: defaultScrollNotificationPredicate,
        child: ListView.builder(
          itemCount: postList.length,
          itemBuilder: (BuildContext context, int index) {
            return PostWidget(post: postList[index]);
          },
        ));
  }
}
