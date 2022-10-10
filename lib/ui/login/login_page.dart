import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/ui/login/login_viewModel.dart';
import 'package:http/http.dart' as http;
import 'package:project/ui/main/mainPage.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';
import 'package:crypto/crypto.dart';

import '../../model/user.dart';
import '../../util/const.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController? emailController;
  TextEditingController? pwdController;
  bool hidePassword = true;
  LoginViewModel viewModel = LoginViewModel();
  late User user;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    pwdController = TextEditingController();
    emailController?.text = "Seraph";
    pwdController?.text = "12345678";
  }

  Future<void> login(String? username, String? pwd) async {
    if (username!.isEmpty) {
      Fluttertoast.showToast(msg: "請輸入用戶名");
      return;
    }
    if (pwd!.isEmpty) {
      Fluttertoast.showToast(msg: "請輸入密碼");
      return;
    }
    User originUser = await viewModel.getUser();
    var url = Uri.http(
        '192.168.1.108:8000', 'api/login', {'name': username, 'password': pwd, 'token': originUser.token});
    var response = await http.get(url);
    print(response.body);
    Map<String, dynamic> userJson = jsonDecode(response.body);
    if (response.statusCode == 200 && mounted) {
      User user = User.getInstance();
      user.formJson(userJson);
      viewModel.addToken(user);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
    } else {
      Fluttertoast.showToast(msg: "Login Failed, Please check your name and pwd!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 80, 20, 0),
              child: Image(image: Image.asset("assets/images/download.jpg").image)),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12,
                  labelText: "Email",
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  hintText: "enter your email...",
                  hintStyle: const TextStyle(fontStyle: FontStyle.italic),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black45, width: 1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black45, width: 1),
                      borderRadius: BorderRadius.circular(8.0)),
                  contentPadding: const EdgeInsets.fromLTRB(20, 24, 20, 24)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: TextFormField(
              controller: pwdController,
              obscureText: !hidePassword,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12,
                  labelText: "Password",
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  hintText: "enter your password...",
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black45, width: 1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black45, width: 1),
                      borderRadius: BorderRadius.circular(8.0)),
                  suffixIcon: InkWell(
                    onTap: () => setState(() => hidePassword = !hidePassword),
                    child: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(20, 24, 20, 24)),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(40, 20, 0, 0),
                child: TextButton(onPressed: () {}, child: Text("Forgot Password?")),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 60, 0),
                child: ElevatedButton(
                  onPressed: () {
                    login(emailController?.text, pwdController?.text);
                  },
                  style: ElevatedButton.styleFrom(onPrimary: Colors.amber, primary: Colors.blue),
                  child: const Text("login"),
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(40, 20, 40, 0),
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.black12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        shadowColor: Colors.transparent,
                        onPrimary: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    onPressed: () {
                      login("123", "123");
                    },
                    child: Row(
                      children: const [
                        Text('Create'),
                        Icon(
                          Icons.arrow_forward,
                          size: 24,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
