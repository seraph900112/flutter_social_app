import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/post.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  State<StatefulWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late Post post;
  bool like = false;
  int likeCount = 0;

  @override
  Widget build(BuildContext context) {
    post = widget.post;
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/download.jpg'),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text("UserName"), Text(post.createAt)],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(post.text!),
              ],
            ),
            if (post.images.isNotEmpty) ...[
              SizedBox(
                height: 150,
                child: GridView.builder(
                  physics: MediaQuery.of(context).viewInsets.bottom != 0
                      ? null
                      : const NeverScrollableScrollPhysics(),
                  itemCount: post.images.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
                  itemBuilder: (BuildContext context, int index) {
                    return Image.memory(base64Decode(post.images[index]));
                  },
                ),
              )
            ] else ...[
              const Text('noPicture')
            ],
            const Divider(
              height: 10,
            ),
            SizedBox(
              height: 28,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 90) / 3,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.share,
                            color: Colors.grey,
                          ),
                          Text("轉發")
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    color: Colors.green,
                    width: 60,
                  ),
                  InkWell(
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 90) / 3,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.comment,
                            color: Colors.grey,
                          ),
                          Text("評論")
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    color: Colors.green,
                    width: 30,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        like = !like;
                        if (like) {
                          likeCount++;
                        } else {
                          likeCount--;
                        }
                      });
                    },
                    child: SizedBox(
                      width: (MediaQuery.of(context).size.width - 90) / 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.thumb_up,
                            color: like ? Colors.orange : Colors.grey,
                          ),
                          Text(
                            likeCount != 0 ? likeCount.toString() : "點讚",
                            style: TextStyle(color: like ? Colors.orange : Colors.black),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
