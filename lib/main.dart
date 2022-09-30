import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:project/ui/login/login_page.dart';
import 'package:project/util/const.dart';
import 'package:pusher_client/pusher_client.dart';

import 'model/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}
