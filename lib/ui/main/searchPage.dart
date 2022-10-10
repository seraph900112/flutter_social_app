import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thumbnailer/thumbnailer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Thumbnail(
      dataResolver: () async {
        return ( await DefaultAssetBundle.of(context).load('assets/images/download.jpg'))
            .buffer
            .asUint8List();
      },
      mimeType: 'image/jpg',
      onlyIcon: true,
      decoration: WidgetDecoration(
        wrapperBgColor: Colors.deepOrange,
        wrapperSize: 110,
      ),
      widgetSize: 100,
    );
  }
}
