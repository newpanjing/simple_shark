import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:simple_shark/components/article_item.dart';
import 'package:simple_shark/pages/detail_page.dart';
import 'package:simple_shark/utils/api.dart';

import '../components/article_list.dart';
import '../components/scroll_view.dart';

class SearchPage extends StatefulWidget {
  late String keyword;
  var state = _SearchPageState();

  SearchPage({Key? key, required this.keyword}) : super(key: key);

  @override
  State<SearchPage> createState() => state;
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> items = [];

  int currentPage = 1;

  int pageCount = 0;

  bool loadMore = false;

  @override
  void initState() {
    super.initState();
    _search();
  }

  _search() async {
    setState(() {
      currentPage = 1;
      items = [];
      loadMore = false;
    });
    _loadData();
  }

  _loadData() async {
    Api.search(widget.keyword, currentPage).then((data) {
      setState(() {
        var ds = data["data"];
        pageCount = ds["pageCount"];
        var documents = ds["documents"] as List;

        items.addAll(documents.map((item) {
          return Map<String, dynamic>.from(item);
        }).toList());

        if (pageCount == 1 || currentPage >= pageCount) {
          loadMore = false;
        } else {
          loadMore = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MacosApp(
      home: MacosScaffold(
        toolBar: ToolBar(
          title: Row(
            children: [
              Text(widget.keyword),
            ],
          ),
          titleWidth: 150.0,
          actions: [
            ToolBarIconButton(
              label: 'Toggle Sidebar',
              icon: const MacosIcon(
                CupertinoIcons.restart,
              ),
              onPressed: () => _search(),
              showLabel: false,
            ),
          ],
        ),
        children: [
          ContentArea(builder: (context, scrollController) {
            return LoadingMoreScrollView(
              onLoadingMore: () {
                if (currentPage < pageCount) {
                  currentPage++;
                  _loadData();
                }
              },
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          minHeight: 40,
                          maxHeight: 40,
                          minWidth: 200,
                          maxWidth: 300),
                      child: CupertinoSearchTextField(
                        controller: TextEditingController(
                          text: widget.keyword,
                        ),
                        onSubmitted: (value) {
                          widget.keyword = value;
                          _search();
                        },
                        placeholder: '输入要查询的关键字',
                      ),
                    ),
                  ),
                  Column(
                    children: List.generate(items.length, (index) {
                      var data = items[index];
                      // print(data)
                      return Material(
                        child: InkWell(
                          child: Column(
                            children: [
                              Html(
                                data: data["text"],
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(id: data["id"]),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (loadMore) {
                        return Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(20),
                          child: CupertinoButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text("加载更多"),
                                  // CupertinoActivityIndicator(),
                                ],
                              ),
                              onPressed: () {
                                if (currentPage < pageCount) {
                                  currentPage++;
                                  _loadData();
                                }
                              }),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
