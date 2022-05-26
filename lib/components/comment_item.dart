import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:simple_shark/components/divider.dart';
import 'package:macos_ui/macos_ui.dart';

import '../utils/avatar.dart';

class CommentItem extends StatefulWidget {
  final Map<String, dynamic> data;

  const CommentItem({Key? key, required this.data}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CommentItemState();
  }
}

class _CommentItemState extends State<CommentItem> {
  @override
  Widget build(BuildContext context) {
    print(widget.data);
    var isDark = MacosTheme.of(context).brightness.isDark;
    var data = widget.data;
    var user = data["user"];
    return Column(
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              ClipOval(
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Image.network(
                    getAvatar(user["avatar"]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                user['name'],
                style:
                TextStyle(color: isDark ? HexColor("#dddede") : Colors.black),
              )
            ],),
            Row(children: [
              Text(data["createTime"]),
            ],)
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: SelectableHtml(
            data: data["contentRendered"],
          ),
        ),
        LayoutBuilder(builder: (context, constraints) {
          var children = data["children"] as List;
          if (children.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                    color: HexColor("#eeeeee"),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: List.generate(
                        children.length,
                            (index) => CommentItem(
                          data: children[index],
                        )),
                  ),
                ),
              ),
            );
          }
          return const SizedBox(
            height: 0,
          );
        }),
      ],
    );
  }
}
