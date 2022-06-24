import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:simple_shark/pages/detail_page.dart';
import 'package:macos_ui/macos_ui.dart';

import 'article_info.dart';

class ArticleItem extends StatefulWidget {
  final Map<String, dynamic> data;

  const ArticleItem({required this.data, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ArticleItemState();
  }
}

class _ArticleItemState extends State<ArticleItem> {
  @override
  Widget build(BuildContext context) {
    var h1 = Theme.of(context).textTheme.headline6;
    var body = Theme.of(context).textTheme.bodyText1;
    var isDark = MacosTheme.of(context).brightness.isDark;

    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: MacosTheme(
                data: MacosThemeData.fallback(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: h1?.fontWeight,
                        color: isDark ? HexColor("#dddede") : Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        (widget.data["subject"] as String)
                            .replaceAll("\n|\r|\t|\s", ""),
                        style: TextStyle(
                          fontSize: body?.fontSize,
                          fontWeight: body?.fontWeight,
                          letterSpacing: body?.letterSpacing,
                          color: HexColor("#838387"),
                        ),
                        // strutStyle: const StrutStyle(
                        //   forceStrutHeight: true,
                        //   height: 1,
                        //   leading: 1,
                        // ),
                        maxLines: 3,
                      ),
                    ),
                    ArticleInfo(
                      widget.data["user"],
                      view: widget.data["view"].toString(),
                      reply: widget.data["reply"].toString(),
                      date: widget.data["lastReplied"].toString(),
                      nodeName: widget.data["node"]["title"].toString(),
                      isDark: isDark,
                    ),
                    // ArticleInfo(Map<String,dynamic>.from(widget.data["user"]), date: "", view: "view", reply: "reply"),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => DetailPage(id: widget.data["id"]),
                ),
              );
            },
          ),
          Divider(
            height: 1,
            color: MacosTheme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }
}
