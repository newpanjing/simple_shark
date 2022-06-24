import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'package:simple_shark/components/bottom.dart';
import 'package:simple_shark/model/user.dart';
import 'package:simple_shark/pages/category_page.dart';
import 'package:simple_shark/pages/editor_page.dart';
import 'package:simple_shark/pages/home_page.dart';
import 'package:simple_shark/pages/search_page.dart';
import 'package:simple_shark/utils/api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MacosApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('zh', 'CN'),
        Locale('en', 'US'),
      ],
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
  late UserModel userModel;

  @override
  void initState() {
    super.initState();
    userModel = UserModel(callback: () {
      sidebars.add(const SidebarItem(
        leading: MacosIcon(CupertinoIcons.home),
        label: Text('首页'),
      ));

      //首页
      pages.add(const HomePage());

      _getData();
    });
  }

  IconData _getIcon(int id) {
    var mappers = {
      1: Icons.question_mark_rounded,
      2: Icons.share_outlined,
      3: Icons.message_outlined,
      4: Icons.important_devices,
      5: Icons.bookmark_outline,
      6: Icons.list_outlined
    };
    if (mappers.containsKey(id)) {
      return mappers[id] as IconData;
    } else {
      return CupertinoIcons.list_bullet;
    }
  }

  _getData() async {
    Api.getCategory().then((res) {
      for (var i = 0; i < res.length; i++) {
        var text = res[i]["title"].toString();
        //添加到导航
        var icon=MacosIcon(_getIcon(res[i]["id"]));
        sidebars.add(SidebarItem(
          leading: icon,
          label: Text(text),
        ));

        pages.add(CategoryPage(id: res[i]["id"], title: res[i]["title"],icon:icon));
      }
      setState(() {});
    });
  }

  var switchValue = false;

  onPublished() {
    setState(() {
      _pageIndex = 0;
    });
    var page = pages[_pageIndex];
    if (page is HomePage) {
      var context = page.getContext();
      //跳转到编辑页面
      Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) {
          return const EditorPage();
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserModel>(
        create: (_) => userModel,
        child: MacosWindow(
          sidebar: Sidebar(
            top: CupertinoSearchTextField(
                placeholder: '搜索',
                onSubmitted: (value) {
                  setState(() {
                    _pageIndex = 0;
                  });
                  var page = pages[_pageIndex];
                  BuildContext bodyContext = context;
                  if (page is HomePage) {
                    bodyContext = page.getContext();
                  } else if (page is CategoryPage) {
                    bodyContext = page.getContext();
                  }
                  //跳转到搜索页面
                  Navigator.of(bodyContext).push(CupertinoPageRoute(
                    builder: (context) {
                      return SearchPage(keyword: value);
                    },
                  ));
                }),
            bottom: Bottom(
              onPublished: onPublished,
            ),
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
        ));
  }
}
