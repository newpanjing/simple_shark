import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

import '../components/article_list.dart';
import '../components/scroll_view.dart';

class CategoryPage extends StatefulWidget {
  final int id;
  final String title;
  var state = _CategoryPageState();

  CategoryPage({Key? key, required this.id, required this.title})
      : super(key: key);

  @override
  State<CategoryPage> createState() => state;
}

class _CategoryPageState extends State<CategoryPage> {
  late ArticleList articleList;
  lazyLoading() {
    articleList.state.lazyLoadData();
  }

  @override
  void initState() {
    articleList = ArticleList(
      widget.id,
      isLazyLoading: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MacosApp(
      home: MacosScaffold(
        toolBar: ToolBar(
          title: Row(
            children: [
              Text(widget.title),
            ],
          ),
          titleWidth: 150.0,
          actions: [
            ToolBarIconButton(
              label: 'Toggle Sidebar',
              icon: const MacosIcon(
                CupertinoIcons.sidebar_left,
              ),
              onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
              showLabel: false,
            ),
          ],
        ),
        children: [
          ContentArea(builder: (context, scrollController) {
            return LoadingMoreScrollView(
              onLoadingMore: () {
                articleList.nextPage();
              },
              child: articleList,
            );
          }),
        ],
      ),
    );
  }
}
