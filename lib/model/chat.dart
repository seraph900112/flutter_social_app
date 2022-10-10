import 'package:project/model/user.dart';

class Chat {
  late bool isSender;
  late int senderId;
  late String type;
  late String content;
  late String createdAt;

  Chat(this.isSender, this.type, this.content);

  Chat.fromJson(Map<String, dynamic> json, this.isSender) {
    type = 'text';
    content = json['content'];
    senderId = json['sender_id'];
    createdAt = json['created_at'];
  }
}
