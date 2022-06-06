import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macos_ui/macos_ui.dart';

import '../utils/avatar.dart';

class UserInfo extends StatefulWidget {
  final String avatar;
  final String name;

  const UserInfo({Key? key, required this.avatar, required this.name})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserInfoState();
  }
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    var isDark = MacosTheme.of(context).brightness.isDark;
    return Row(
      children: [
        ClipOval(
          child: SizedBox(
            height: 30,
            width: 30,
            child: Image.network(
              getAvatar(widget.avatar),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          widget.name,
          style: TextStyle(color: isDark ? HexColor("#dddede") : Colors.black),
        )
      ],
    );
  }
}
