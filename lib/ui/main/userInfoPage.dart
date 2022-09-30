import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/ui/main/homePage.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';
import '../../model/user.dart';

class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.add_reaction_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.qr_code),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {},
            ),
          ],
        ),
        InkWell(
          onTap: (){
            print("123");
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/Miko_2020.webp")),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("UserName",style: TextStyle(color: Colors.black87,fontSize: 18,fontWeight: FontWeight.bold),),
                  Text("Des:null",style: TextStyle(color: Colors.grey),)
                ],
              )
            ],
          ),
        ),
        Row(
          children: [

          ],
        ),

      ],
    );
  }
}
