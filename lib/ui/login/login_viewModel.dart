import 'package:flutter/cupertino.dart';
import 'package:project/db/userDB.dart';

import '../../model/user.dart';

class LoginViewModel with ChangeNotifier {
  UserDB userDB = UserDB();
  User user = User.getInstance();
  late User dataBaseUser;


  Future<bool> verify(String userName, String pwd) async {
    return await userDB.verify(userName, pwd);
  }

  Future<void> addToken(User user) async {
    userDB.addToken(user);
  }

  Future<User> getUser() async {
    return await userDB.getUser();
  }
}
