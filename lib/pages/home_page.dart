import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_shark/components/article_list.dart';
import 'package:simple_shark/components/banner.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/mytabbar.dart';
import '../components/scroll_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var articleList=ArticleList(-1,isLazyLoading: false,);
    return MacosApp(
      home: MacosScaffold(
        toolBar: ToolBar(
          title: Text("Simple社区"),
          actions: [

            ToolBarIconButton(
                icon: Icon(CupertinoIcons.home),
                onPressed: () {
                  launchUrl(Uri.parse("https://simpleui.72wo.com"));
                },
                label: '主页',
                showLabel: false),
            ToolBarIconButton(label: "刷新", icon: Icon(CupertinoIcons.arrow_2_circlepath), showLabel: false,onPressed: (){
              articleList.refreshPage();
            }),
            ToolBarIconButton(label: "发布", icon: Icon(Icons.edit), showLabel: false,onPressed: (){
              // Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>const EditorPage()));
            }),
          ],
        ),
        children: [
          ContentArea(builder: (context, constraints) {
            return LoadingMoreScrollView(
              onLoadingMore: ()  {
                articleList.nextPage();
              },
              child: Column(
                children: [
                  BannerWidget(),
                  MyTabbar(),
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
