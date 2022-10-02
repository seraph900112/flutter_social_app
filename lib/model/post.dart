import 'dart:typed_data';

class Post {
  late int id;
  late int posterId;
  late bool hasText;
  late bool hasPhoto;
  late String createAt;
  late int likeTimes;
  late int commentTimes;
  late int shareTimes;
  String? text;
  List<String> images = <String>[];

  Post(this.posterId, this.text, this.images, this.likeTimes, this.commentTimes) {
    hasText = true;
    hasPhoto = true;
  }
  Post.empty();

  Post.text(this.posterId, this.text, this.likeTimes, this.commentTimes) {
    hasText = true;
    hasPhoto = false;
  }

  void fromJson(Map<String, dynamic> json){
    id = json['id'];
    posterId = json['posterId'];
    hasText = json['hasText'] == 1 ? true : false;
    hasPhoto = json['hasPhoto'] == 1 ? true : false;
    createAt = json['created_at'];
    likeTimes = json['likeTimes'];
    commentTimes = json['commentTimes'];
    shareTimes = json['shareTimes'];
    text = json['text'];
    if(json['picture']!=null){
      images.add(json['picture']);
    }

  }
}
