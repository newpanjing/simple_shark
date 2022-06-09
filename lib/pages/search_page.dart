import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:simple_shark/components/article_item.dart';
import 'package:simple_shark/components/divider.dart';
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
  bool isLoading = false;

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
    setState(() {
      isLoading = true;
    });
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
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MacosTheme.of(context).brightness.isDark;
    return MacosApp(
      home: MacosScaffold(
        toolBar: ToolBar(
          title: Row(
            children: [
              MacosBackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                width: 10,
              ),
              Text(widget.keyword),
            ],
          ),
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
                  if (isLoading)
                    SpinKitRing(
                      lineWidth: 2.0,
                      color: MacosTheme.of(context).primaryColor,
                      size: 20.0,
                    ),
                  if (items.isEmpty)
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        '没有找到相关内容',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  Column(
                    children: List.generate(items.length, (index) {
                      var data = items[index];
                      // print(data)
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(id: data["id"]),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Html(
                                  data: data["text"],
                                  style: {
                                    "*": Style(
                                      fontSize: const FontSize(14),
                                      color:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                    "span": Style(
                                      fontSize: const FontSize(14),
                                      color: Colors.red,
                                    ),
                                  },
                                )),
                                Text(
                                  "相似度: ${data["score"]}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            const MacosDivider(),
                          ],
                        ),
                      );
                    }),
                  ),
                  if (loadMore)
                    Container(
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
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
