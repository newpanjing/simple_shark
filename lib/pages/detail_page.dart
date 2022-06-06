import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:simple_shark/components/article_info.dart';
import 'package:simple_shark/components/divider.dart';
import 'package:simple_shark/utils/api.dart';
import 'package:macos_ui/macos_ui.dart';

import '../components/comment_page.dart';
import '../model/user.dart';

class DetailPage extends StatefulWidget {
  final int id;

  const DetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var isLoading = true;

  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    isLoading = true;
    Api.getTopic(widget.id).then((value) {
      setState(() {
        isLoading = false;
        data = Map<String, dynamic>.from(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final spinkit = SpinKitRing(
      lineWidth: 2.0,
      color: MacosTheme.of(context).primaryColor,
      size: 30.0,
    );
    //
    var color = Theme.of(context).textTheme.headline1?.color;

    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text("帖子详情"),
        actions: [
          ToolBarIconButton(
              icon: const Icon(CupertinoIcons.arrow_2_circlepath),
              onPressed: () {
                // launchUrl(Uri.parse("https://simpleui.72wo.com"));
                _getData();
              },
              label: '刷新',
              showLabel: false),
        ],
      ),
      children: [
        ContentArea(builder: (context, constraints) {
          return isLoading
              ? Visibility(visible: true, child: spinkit)
              : Column(
                  children: [
                    Expanded(
                        child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(
                              data["title"],
                              cursorColor: Colors.blue,
                              showCursor: true,
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      ?.fontSize),
                              maxLines: 2,
                            ),
                            ArticleInfo(
                              data["user"],
                              date: data["lastReplied"].toString(),
                              view: data["view"].toString(),
                              reply: data["reply"].toString(),
                              nodeName: data["node"]["title"].toString(),
                            ),
                            const MacosDivider(),
                            SelectableHtml(
                              style: {
                                "h1": Style(color: color),
                              },
                              data: data["contentRendered"],
                            ),
                            CommentPage(
                              id: int.parse(data["id"].toString()),
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                );
        }),
      ],
    );
  }
}
