import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'package:simple_shark/components/article_list.dart';
import 'package:simple_shark/components/banner.dart';
import 'package:simple_shark/components/title_text.dart';
import 'package:simple_shark/model/user.dart';
import 'package:simple_shark/pages/search_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/scroll_view.dart';
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
    //获取用户
    var userInfo=Provider.of<UserModel>(context).userInfo;

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
                                  if(userInfo.isEmpty){
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
}
