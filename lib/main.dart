import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_shark/components/bottom.dart';
import 'package:simple_shark/pages/category_page.dart';
import 'package:simple_shark/pages/home_page.dart';
import 'package:simple_shark/utils/api.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MacosApp(
      title: 'Simple社区',
      themeMode: ThemeMode.system,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _pageIndex = 0;

  final List<Widget> pages = [];
  List<SidebarItem> sidebars = [];

  @override
  void initState() {
    super.initState();
    sidebars.add(const SidebarItem(
      leading: MacosIcon(CupertinoIcons.home),
      label: Text('首页'),
    ));

    //首页
    pages.add(const HomePage());

    _getData();
  }

  _getData() async {
    Api.getCategory().then((res) {
      for (var i = 0; i < res.length; i++) {
        var text = res[i]["title"].toString();
        //添加到导航
        sidebars.add(SidebarItem(
          leading: const MacosIcon(CupertinoIcons.list_bullet),
          label: Text(text),
        ));

        pages.add(CategoryPage(id: res[i]["id"], title: res[i]["title"]));
      }
      setState(() {});
    });
  }

  var switchValue = false;

  @override
  Widget build(BuildContext context) {
    return MacosWindow(
      sidebar: Sidebar(
        top: const MacosSearchField(
          placeholder: "Search",
          maxLines: 1,
        ),
        bottom: const Bottom(),
        minWidth: 200,
        builder: (context, scrollController) {
          return SidebarItems(
            currentIndex: _pageIndex,
            onChanged: (index) {
              setState(() {
                _pageIndex = index;
                var item = pages[index];
                if (item is CategoryPage) {
                  item.state.lazyLoading();
                }
              });
            },
            items: sidebars,
          );
        },
      ),
      child: IndexedStack(
        index: _pageIndex,
        children: pages,
      ),
    );
  }
}
