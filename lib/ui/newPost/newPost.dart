import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker/multi_image_picker.dart';
import '../../model/user.dart';

class NewPost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewPostState();
}

class NewPostState extends State<NewPost> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  double iconSize = 50.0;
  List<Asset> photo = <Asset>[];

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
                focusNode: focusNode,
                controller: controller,
                decoration: const InputDecoration(
                    hintText: 'Share something new !',
                    enabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder:
                        UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent))),
                cursorColor: Colors.orange,
              )),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom != 0
                    ? 120
                    : 120 * ((photo.length - 1) ~/ 3 + 1),
                child: photo.isEmpty
                    ? null
                    : GridView.builder(
                        physics: MediaQuery.of(context).viewInsets.bottom != 0
                            ? null
                            : const NeverScrollableScrollPhysics(),
                        itemCount: photo.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
                        itemBuilder: (BuildContext context, int index) {
                          return photoGrid(
                              AssetThumb(
                                asset: photo[index],
                                width: 300,
                                height: 300,
                              ),
                              index);
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          uploadImages();
                        },
                        icon: Icon(Icons.photo, size: iconSize)),
                    IconButton(
                        onPressed: () async {
                          ByteData bytedata = await photo[0].getByteData();
                          print('HIHI');
                          print(bytedata.buffer.asInt32List());
                        },
                        icon: Icon(Icons.alternate_email, size: iconSize)),
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

  Future<void> post() async {
    String? token = User.getInstance().token;
    List<String> photo_base64 = <String>[];
    for (int i = 0; i < photo.length; i++) {
      // 获取 ByteData
      ByteData byteData = await photo[i].getByteData(quality: 1);
      photo_base64.add(base64Encode(byteData.buffer.asUint8List()));
    }
    var url = Uri.http('192.168.1.106:8000', 'api/addpost');
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $token',
    }, body: {
      'posterId': User.getInstance().id.toString(),
      'hasText': '1',
      'hasPhoto': photo.isEmpty ? '0' : '1',
      'text': controller.text.isEmpty ? 'Share photos' : controller.text,
      'photo': jsonEncode(photo_base64)
    });
    print(response.body); /*
    if (mounted) {
      Navigator.pop(context);
    }*/
  }

  Future<void> uploadImages() async {
    try {
      var tmp = await MultiImagePicker.pickImages(
        // 可选参数， 若resultList不为空，再次打开选择界面的适合，可以显示之前选中的图片信息。
        selectedAssets: photo,
        // 选择图片的最大数量
        maxImages: 9,
        // 是否支持拍照
        enableCamera: true,
        materialOptions: const MaterialOptions(
            // 显示所有照片，值为 false 时显示相册
            startInAllView: true,
            allViewTitle: '所有照片',
            actionBarColor: '#2196F3',
            textOnNothingSelected: '没有选择照片'),
      );
      if (tmp.isNotEmpty) {
        photo = tmp;
        setState(() {});
      }
    } on Exception catch (e) {
      e.toString();
    }
  }

  Widget photoGrid(widget, index) {
    return Stack(
      children: [
        widget,
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              focusNode.unfocus();
              setState(() {
                photo.removeAt(index);
              });
            },
            child: const Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
        )
      ],
    );
  }
}
