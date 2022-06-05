import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';

import '../components/input.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditorPageState();
  }
}

class _EditorPageState extends State<EditorPage> {
  var text = "# Markdown Editor\n Hello,World!";

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Material(

      child: MacosScaffold(
        toolBar: ToolBar(
          title: Row(
            children: const [Text("编辑器"), Text("编辑器"), Text("编辑器")],
          ),
          actions: [
            ToolBarIconButton(
                icon: const Icon(Icons.save),
                onPressed: () {},
                label: '刷新',
                showLabel: false),
          ],
        ),
        children: [
          ContentArea(
              builder: (context, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: MarkdownInput(
                        (String value) => setState(() => text = value),
                        text,
                        label: 'Description',
                        maxLines: 100,
                        actions: MarkdownType.values,
                        controller: controller,
                      ),
                    ),
                  )),
          ResizablePane(
              builder: (context, _) {
                return Markdown(selectable: true, data: text);
              },
              minWidth: 100,
              resizableSide: ResizableSide.left,
              startWidth: 300)
        ],
      ),
    );
  }
}
