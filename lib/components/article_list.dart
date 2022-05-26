import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_shark/components/article_item.dart';
import 'package:simple_shark/utils/api.dart';
import 'package:macos_ui/macos_ui.dart';

class ArticleList extends StatefulWidget {
  final int nodeId;
  bool isLazyLoading = false;
  ArticleList(this.nodeId, {Key? key, required this.isLazyLoading})
      : super(key: key);

  final state = _ArticleListState();

  @override
  State<StatefulWidget> createState() {
    return state;
  }

  nextPage() {
    state.next();
  }

  refreshPage() {
    state.refresh();
  }
}

class _ArticleListState extends State<ArticleList> {
  var currentPage = 1;
  List<dynamic> dataList = [];
  var paginator = <String, dynamic>{};
  var pageCount = 2;
  var isLoading = true;
  var isBottom = false;

  _ArticleListState();

  @override
  void initState() {
    super.initState();
    if (!widget.isLazyLoading) {
      _getData();
    }
  }

  refresh() {
    currentPage = 1;
    pageCount = 2;
    isLoading = false;
    dataList = [];
    _getData();
  }

  next() {
    if (currentPage >= pageCount) {
      isBottom = true;
      setState(() {});
      return;
    }
    currentPage++;
    _getData();
  }

  lazyLoadData() async {
    _getData();
  }

  _getData() async {
    Api.getTopics(currentPage, widget.nodeId).then((value) {
      dataList.addAll(Map<String, dynamic>.from(value)['data']);
      paginator = Map<String, dynamic>.from(value)['paginator'];
      pageCount = int.parse(paginator["pages"].toString());
      setState(() {
        isLoading = false;
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
    return Column(children: [
      ...List.generate(dataList.length, (index) {
        return ArticleItem(
          data: dataList[index],
        );
      }).toList(),
      Visibility(visible: isLoading, child: spinkit),
      Visibility(visible: isBottom, child: const Text("~~我也是有底线的~~")),
    ]);
  }
}
