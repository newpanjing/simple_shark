import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:macos_ui/macos_ui.dart';

class MarkdownPage extends StatefulWidget {
  const MarkdownPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MarkdownPageState();
  }
}

class _MarkdownPageState extends State<MarkdownPage> {
  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: Text("Markdown"),
      ),
      children: [
        ContentArea(builder: (context, c) {
          return Markdown(
              selectable: true,
              data:
                  "# 123123123 \n > asdsajdksadjsakdjskad \n```\n echo ok \n```\n![](https://t7.baidu.com/it/u=1595072465,3644073269&fm=193&f=GIF)");
        })
      ],
    );
  }
}
