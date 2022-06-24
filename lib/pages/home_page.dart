import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'package:simple_shark/components/article_list.dart';
import 'package:simple_shark/components/banner.dart';
import 'package:simple_shark/components/title_text.dart';
import 'package:simple_shark/model/user.dart';
import 'package:simple_shark/utils/api.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/scroll_view.dart';
import '../components/user_info.dart';
import 'editor_page.dart';

late BuildContext bodyContext;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }

  BuildContext getContext() {
    return bodyContext;
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    print("build");
    //获取用户
    var userInfo = Provider.of<UserModel>(context).userInfo;

    var articleList = ArticleList(
      -1,
      isLazyLoading: false,
    );
    return MacosApp(
      debugShowCheckedModeBanner: false,
      home: MacosScaffold(
        toolBar: ToolBar(
          title: const Text("Simple社区"),
          actions: [
            ToolBarIconButton(
                icon: const Icon(Icons.public_sharp),
                onPressed: () {
                  launchUrl(Uri.parse("https://simpleui.72wo.com"));
                },
                label: '主页',
                showLabel: false),
            ToolBarIconButton(
                label: "刷新",
                icon: const Icon(CupertinoIcons.arrow_2_circlepath),
                showLabel: false,
                onPressed: () {
                  articleList.refreshPage();
                }),
          ],
        ),
        children: [
          ContentArea(builder: (context, constraints) {
            bodyContext = context;
            return LoadingMoreScrollView(
              onLoadingMore: () {
                articleList.nextPage();
              },
              child: Column(
                children: [
                  BannerWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TitleText("帖子列表"),
                      SizedBox(
                        // width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CupertinoButton(
                                child: const Text("发布"),
                                onPressed: () {
                                  if (userInfo.isEmpty) {
                                    //提示要登陆
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: const Text("提示"),
                                          content: const Text("请先登陆"),
                                          actions: [
                                            CupertinoButton(
                                              child: const Text("确定"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    return;
                                  }
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (context) =>
                                          const EditorPage()));
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                  articleList,
                  // Expanded(child:ArticleList()),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
    var userInfo = Provider.of<UserModel>(context).userInfo;
    print(userInfo);
    if (userInfo.isNotEmpty && Platform.isMacOS) {
      _registerNotice(userInfo['token']);
    }
  }

  _registerNotice(userToken) async {
    var api = Api(token: userToken);
    print("Macos");
    //获取deviceToken
    const MethodChannel('com.github.panjing.MethodChannel')
        .invokeMethod("getToken")
        .then((res) {
      var token = res["token"];
      print("deviceToken:$token");
      //注册到服务器上

      //两种情况，一种是登陆后处理，切换账号，退出登陆的时候，要注销通知
      api.registerDeviceToken(token).then((res) {
        debugPrint("通知注册结果：$res");
      });
      //一种是登陆前处理

      //判断用户是否登陆了
    });
  }
}
