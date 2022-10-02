import 'package:synchronized/synchronized.dart';

class User {
  static User? user;
  static var lock = Lock();
  late String? name;
  late String? gender;
  String token = 'default';
  late String? email;
  late int? id;
  late int? phoneNumber;

  User(this.name, this.gender, this.email);

  User.empty();

  static User getInstance() {
    lock.synchronized(() {
      user ??= User.empty();
    });
    return user!;
  }

  void formJson(Map<String, dynamic> user) {
    setId(user['id']);
    setGender(user['gender']);
    setEmail(user['email']);
    setPhone(user['phone_Number']);
    setName(user['name']);
    setToken(user['api_token']);
  }

  void setToken(String token) {
    this.token = token;
  }

  void setId(int? id) {
    this.id = id;
  }

  void setName(String? name) {
    this.name = name;
  }

  void setEmail(String? email) {
    this.email = email;
  }

  void setGender(String? gender) {
    this.gender = gender;
  }

  void setPhone(int? phoneNumber) {
    this.phoneNumber = phoneNumber;
  }
}
