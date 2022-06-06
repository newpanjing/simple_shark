import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_shark/utils/api.dart';
import 'package:macos_ui/macos_ui.dart';

typedef ChangeCallback = void Function(int index);

class MyTabBar extends StatefulWidget {
  final ChangeCallback onChange;

  const MyTabBar({Key? key, required this.onChange}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyTabBarState();
  }
}

class _MyTabBarState extends State<MyTabBar> {
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
      for (var i=0;i<tabs.length;i++)
        CupertinoButton(
          child: Text("${tabs[i]["title"]}"),
          onPressed: () => widget.onChange(i),
        ),
    ]);
  }
}
