import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'package:simple_shark/components/article_info.dart';
import 'package:simple_shark/components/divider.dart';
import 'package:simple_shark/model/user.dart';
import 'package:simple_shark/pages/editor_page.dart';
import 'package:simple_shark/utils/api.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/comment_page.dart';
import '../utils/dialog.dart';

class DetailPage extends StatefulWidget {
  final int id;

  const DetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var isLoading = true;
  var isDeleteLoading = false;
  late Map<String, dynamic> data;
  late Api api;

  @override
  void initState() {
    super.initState();
    var token =
        Provider.of<UserModel>(context, listen: false).userInfo["token"];
    api = Api(token: token);
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

  _deleteTopic() {
    setState(() {
      isDeleteLoading = true;
    });
    api.deleteTopic(widget.id).then((value) {
      setState(() {
        isDeleteLoading = false;
      });
      Navigator.pop(context);

      if (value["code"] != 1) {
        showErrorDialog(context, value["msg"]);
      }
    });
  }

  _delete() {
    //显示对话框
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("删除帖子"),
        content: const Text("确定删除帖子吗？"),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text("取消"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            child: const Text("确定"),
            onPressed: () {
              _deleteTopic();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  _edit() {
    Navigator.of(context).push(CupertinoPageRoute(
      builder: (context) {
        return EditorPage(id: widget.id);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final spinKit = SpinKitRing(
      lineWidth: 2.0,
      color: MacosTheme.of(context).primaryColor,
      size: 30.0,
    );
    //
    var color = Theme.of(context).textTheme.headline1?.color;
    var userInfo = Provider.of<UserModel>(context).userInfo;
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text("帖子详情"),
        actions: [
          ToolBarIconButton(
              icon: const Icon(CupertinoIcons.arrow_2_circlepath),
              onPressed: () {
                _getData();
              },
              label: '刷新',
              showLabel: false),
          ToolBarIconButton(
              icon: const Icon(CupertinoIcons.link_circle),
              onPressed: () {
                launchUrl(
                    Uri.parse("https://simpleui.72wo.com/topic/${widget.id}"));
              },
              label: '网站中打开',
              showLabel: false),
        ],
      ),
      children: [
        ContentArea(builder: (context, constraints) {
          return isLoading
              ? Visibility(visible: true, child: spinKit)
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
                            if ((userInfo.isNotEmpty &&
                                    userInfo["isStaff"] as bool) ||
                                userInfo["id"] == data["user"]["id"])
                              IntrinsicHeight(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        CupertinoButton(
                                            onPressed: _edit,
                                            child: const Text(
                                              "编辑",
                                              style: TextStyle(
                                                  color: Colors.green),
                                            )),
                                        const SizedBox(width: 10),
                                        if (isDeleteLoading)
                                          const CupertinoButton(
                                            onPressed: null,
                                            child: Text("删除中..."),
                                          ),
                                        if (!isDeleteLoading)
                                          CupertinoButton(
                                              onPressed: _delete,
                                              child: const Text(
                                                "删除",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )),
                                      ],
                                    ),
                                    const MacosDivider(),
                                  ],
                                ),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            SelectableHtml(
                              style: {
                                "h1": Style(color: color),
                              },
                              data: data["contentRendered"],
                            ),
                            const SizedBox(
                              height: 10,
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
