import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_shark/utils/api.dart';
import 'package:macos_ui/macos_ui.dart';

class MyTabbar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyTabbarState();
  }
}

class _MyTabbarState extends State<MyTabbar> {
  var tabs = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    Api.getCategory().then((res) {
      setState(() {
        tabs = res;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      for (var item in tabs)
        CupertinoButton(
          child: Text("${item["title"]}"),
          onPressed: () {},
        ),
    ]);
  }
}
