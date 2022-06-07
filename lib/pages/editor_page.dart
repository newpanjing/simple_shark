import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:provider/provider.dart';
import 'package:simple_shark/components/divider.dart';
import 'package:simple_shark/utils/api.dart';

import '../components/category_popup.dart';
import '../components/input.dart';
import '../model/user.dart';
import '../utils/dialog.dart';
import 'detail_page.dart';

class EditorPage extends StatefulWidget {
  final int? id;

  //可选参数 id
  const EditorPage({Key? key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditorPageState();
  }
}

class _EditorPageState extends State<EditorPage> {
  var content = " 您想分享点什么？";
  var categoryId = 0;
  var title = "";
  var isLoading = false;
  late Api api;

  _getData() async {
    setState(() {
      isLoading = true;

      //加载数据
      api.getTopicEditData(widget.id).then((value) {
        setState(() {
          categoryId = value["nodeId"];
          content = value["content"];
          title = value["title"];
          isLoading = false;
        });
      });
    });
  }

  _submit() {
    //校验分类
    if (categoryId == -1) {
      showErrorDialog(context, "请选择分类");
      return;
    }

    //校验
    if (title.isEmpty) {
      showErrorDialog(context, "标题不能为空");
      return;
    }
    //校验内容
    if (content.isEmpty) {
      showErrorDialog(context, "内容不能为空");
      return;
    }
    setState(() {
      isLoading = true;
    });
    //发布
    api.postTopic(title, content, categoryId, id: widget.id).then((res) {
      if (res["code"] != 1) {
        showErrorDialog(context, res["msg"]);
      } else {
        //如果是新发布清空数据
        if (widget.id == null) {
          setState(() {
            content = " 您想分享点什么？";
            categoryId = -1;
            title = "";
          });
        }

        //跳转到详情页
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => DetailPage(id: res["id"]),
          ),
        );
      }
    }).catchError((e) {
      showErrorDialog(context, "发布失败");
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    var userInfo = Provider.of<UserModel>(context, listen: false).userInfo;
    var token = userInfo["token"];
    api = Api(token: token);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // });
    if(widget.id!=null) {
      _getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MacosScaffold(
        toolBar: ToolBar(
          title: Row(
            children: [
              widget.id != null ? const Text("编辑帖子") : const Text("发布帖子"),
              const SizedBox(width: 10),
              if (isLoading)
                SpinKitRing(
                  lineWidth: 2.0,
                  color: MacosTheme.of(context).primaryColor,
                  size: 20.0,
                )
            ],
          ),
          actions: [
            ToolBarIconButton(
                icon: widget.id != null
                    ? const Icon(Icons.save)
                    : const Icon(Icons.send),
                onPressed: _submit,
                label: '保存',
                showLabel: false),
          ],
        ),
        children: [
          ContentArea(
              builder: (context, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CategoryPopup(
                                categoryId: categoryId,
                                onChanged: (value) {
                                  setState(() {
                                    categoryId = value;
                                  });
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: CupertinoTextField(
                                placeholder: "标题",
                                onChanged: (value) => title = value,
                                controller: TextEditingController(text: title),
                              )),
                            ],
                          ),
                          const MacosDivider(),
                          Expanded(
                              child: isLoading
                                  ? SpinKitRing(
                                      lineWidth: 2.0,
                                      color:
                                          MacosTheme.of(context).primaryColor,
                                      size: 20.0,
                                    )
                                  : MarkdownInput(
                                      (String value) =>
                                          setState(() => content = value),
                                      content,
                                      label: 'Description',
                                      maxLines: 100,
                                      actions: MarkdownType.values,
                                      controller: TextEditingController(),
                                    ))
                        ],
                      ),
                    ),
                  )),
          ResizablePane(
              builder: (context, _) {
                return Markdown(selectable: true, data: content);
              },
              minWidth: 100,
              resizableSide: ResizableSide.left,
              startWidth: 300)
        ],
      ),
    );
  }
}
