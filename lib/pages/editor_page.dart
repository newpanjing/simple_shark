import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:markdown_core/markdown.dart';
import 'package:markdown_editor_ot/markdown_editor.dart';

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
                    child: MarkdownEditor(
                      initText: text,
                      imageWidget: (String imageUrl) {
                        return CachedNetworkImage(
                          imageUrl: imageUrl,
                          placeholder: (context, url) => const SizedBox(
                            width: double.infinity,
                            height: 300,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        );
                      },
                    ),
                  )),
          ResizablePane(
              builder: (context, _) {
                return Scaffold(
                    body: SingleChildScrollView(
                  child: Markdown(
                    textStyle: const TextStyle(color: Colors.black),
                    data: text,
                    linkTap: (link) => print('点击了链接 $link'),
                    image: (imageUrl) {
                      print('imageUrl $imageUrl');
                      return CachedNetworkImage(
                        imageUrl: imageUrl,
                        placeholder: (context, url) => const SizedBox(
                          width: double.infinity,
                          height: 300,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      );
                    },
                  ),
                ));
              },
              minWidth: 100,
              resizableSide: ResizableSide.left,
              startWidth: 300)
        ],
      ),
    );
  }
}
