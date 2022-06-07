import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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

  //可选参数 id
  const EditorPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditorPageState();
  }
}

class PublishButton extends ToolbarItem {
  final VoidCallback onPressed;

  const PublishButton(this.onPressed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ToolbarItemDisplayMode displayMode) {
    return Listener(
      child: Row(
        children: const [
          Icon(Icons.send),
          Text('发布'),
        ],
      ),
      onPointerUp: (PointerUpEvent e) {
        onPressed();
      },
    );
  }
}

class _EditorPageState extends State<EditorPage> {
  var content = "# 这是标题\n 你想分享点什么？";
  var categoryId = -1;
  var title = "";

  late Api api;

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

    //发布
    api.postTopic(title, content, categoryId).then((res) {
      if (res["code"] != 1) {
        showErrorDialog(context, res["msg"]);
      } else {
        //跳转到详情页
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => DetailPage(id: res["id"]),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //获取用户信息
    var token = Provider.of<UserModel>(context).userInfo["token"];
    api = Api(token: token);

    return Material(
      child: MacosScaffold(
        toolBar: ToolBar(
          title: Row(
            children: const [Text("编辑器")],
          ),
          actions: [
            ToolBarIconButton(
                icon: const Icon(Icons.send),
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
                                onChanged: (cid) => categoryId = cid,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: MacosTextField(
                                placeholder: '标题',
                                // controller: TextEditingController(text: title),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                maxLength: 128,
                                onChanged: (value) {
                                  setState(() {
                                    title = value;
                                  });
                                },
                              )),
                            ],
                          ),
                          const MacosDivider(),
                          Expanded(
                              child: MarkdownInput(
                            (String value) => setState(() => content = value),
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
