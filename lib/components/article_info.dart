import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:simple_shark/components/tag.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:simple_shark/components/user_info.dart';

import '../utils/avatar.dart';

class ArticleInfo extends StatefulWidget {
  final Map<String, dynamic> user;
  final String date;
  final String view;
  final String reply;
  final String nodeName;

  const ArticleInfo(this.user,
      {Key? key,
      required this.date,
      required this.view,
      required this.reply,
      required this.nodeName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ArticleInfoState();
  }
}

class _ArticleInfoState extends State<ArticleInfo> {
  @override
  Widget build(BuildContext context) {
    var isDark = MacosTheme.of(context).brightness.isDark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Tag(widget.nodeName),
            const SizedBox(
              width: 10,
            ),
            UserInfo(
              avatar: widget.user["avatar"],
              name: widget.user["name"],
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.date,
              style: TextStyle(
                color: isDark ? HexColor("#dddede") : Colors.black,
              ),
            ),
          ],
        ),
        Theme(
            data: ThemeData(
              primaryColor: isDark ? HexColor("#dddede") : Colors.black,
            ),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.eye,
                  size: 14,
                  color: isDark ? HexColor("#dddede") : Colors.black,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.view,
                  style: TextStyle(
                    color: isDark ? HexColor("#dddede") : Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.message,
                  size: 14,
                  color: isDark ? HexColor("#dddede") : Colors.black,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.reply,
                  style: TextStyle(
                    color: isDark ? HexColor("#dddede") : Colors.black,
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
