import 'package:expandable/expandable.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';

import '../utils/api.dart';

class MarkdownInput extends StatefulWidget {
  final Function onTextChanged;
  final String initialValue;
  final String label;
  final int maxLines;
  final List<MarkdownType> actions;

  final TextEditingController? controller;

  const MarkdownInput(this.onTextChanged, this.initialValue,
      {Key? key,
      this.controller,
      this.maxLines = 10,
      this.actions = const [
        MarkdownType.bold,
        MarkdownType.italic,
        MarkdownType.title,
        MarkdownType.link,
        MarkdownType.list
      ],
      this.label = 'Description'})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MarkdownInputState(controller ?? TextEditingController());
  }
}

final xType = XTypeGroup(
    label: '图片', extensions: ['jpg', 'png', 'bmp', 'gif', 'heic', 'heif']);

class _MarkdownInputState extends State<MarkdownInput> {
  final TextEditingController _controller;
  TextSelection textSelection =
      const TextSelection(baseOffset: 0, extentOffset: 0);

  _MarkdownInputState(this._controller);

  void _onChoiceFile(VoidCallback callback) async {
    XFile? file = await openFile(acceptedTypeGroups: [xType]);
    if (file != null) {
      file.readAsBytes().then((value) {
        Api(token: "").upload(value).then((res) {
          var url = res["url"];
          //判断是否有前缀
          if (!url.startsWith("http")) {
            if (url.startsWith("/")) {
              url = url.substring(1);
            }
            url = "https://simpleui.72wo.com/$url";
          }
          //插入图片
          _controller.text =
              "${_controller.text.substring(0, textSelection.baseOffset)}\n![]($url)\n${_controller.text.substring(textSelection.extentOffset)}";

          //通知成功
          callback.call();
        });
      });
    }
  }

  void onTap(MarkdownType type, {int titleSize = 1}) {
    if (type == MarkdownType.image) {
      //显示图片选择器
      showMacosAlertDialog(
          context: context,
          builder: (context) => MacosAlertDialog(
                appIcon: const Icon(
                  CupertinoIcons.photo_camera,
                  size: 56,
                ),
                title: const Text(
                  '上传图片',
                ),
                message: Column(
                  children: [
                    PushButton(
                      buttonSize: ButtonSize.large,
                      onPressed: () =>
                          _onChoiceFile(() => Navigator.of(context).pop()),
                      child: const Text('浏览图片'),
                    ),
                  ],
                ),
                horizontalActions: false,
                primaryButton: PushButton(
                  isSecondary: true,
                  buttonSize: ButtonSize.large,
                  onPressed: Navigator.of(context).pop,
                  child: const Text('取消'),
                ),
              ));
      return;
    }
    final basePosition = textSelection.baseOffset;
    var noTextSelected =
        (textSelection.baseOffset - textSelection.extentOffset) == 0;

    final result = FormatMarkdown.convertToMarkdown(type, _controller.text,
        textSelection.baseOffset, textSelection.extentOffset,
        titleSize: titleSize);

    _controller.value = _controller.value.copyWith(
        text: result.data,
        selection:
            TextSelection.collapsed(offset: basePosition + result.cursorIndex));

    if (noTextSelected) {
      _controller.selection = TextSelection.collapsed(
          offset: _controller.selection.end - result.replaceCursorIndex);
    }
  }

  @override
  void initState() {
    _controller.text = widget.initialValue;
    _controller.addListener(() {
      if (_controller.selection.baseOffset != -1) {
        textSelection = _controller.selection;
      }
      widget.onTextChanged(_controller.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MacosTheme.of(context).brightness.isDark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? HexColor("#38393a") : Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: <Widget>[
          Expanded(child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight,
                ),
                child: TextField(
                  autofocus: true,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  textInputAction: TextInputAction.newline,
                  maxLines: widget.maxLines,
                  controller: _controller,
                  textCapitalization: TextCapitalization.sentences,
                  // validator: (value) => widget.validators!(value),
                  cursorColor: Theme.of(context).primaryColor,
                  // textDirection: widget.textDirection,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary)),
                    hintText: widget.label,
                    hintStyle:
                        const TextStyle(color: Color.fromRGBO(63, 61, 86, 0.5)),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                  ),
                ),
              );
            },
          )),
          SizedBox(
            height: 44,
            child: Material(
              color: isDark ? HexColor("#38393a") : Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: widget.actions.map((type) {
                  return type == MarkdownType.title
                      ? ExpandableNotifier(
                          child: Expandable(
                            key: const Key('H#_button'),
                            collapsed: ExpandableButton(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'H#',
                                    style: TextStyle(
                                        color: isDark
                                            ? HexColor("#949495")
                                            : HexColor("#6d6d6d"),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                            expanded: Container(
                              color: Colors.white10,
                              child: Row(
                                children: [
                                  for (int i = 1; i <= 6; i++)
                                    InkWell(
                                      key: Key('H${i}_button'),
                                      onTap: () => onTap(MarkdownType.title,
                                          titleSize: i),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          'H$i',
                                          style: TextStyle(
                                              color: isDark
                                                  ? HexColor("#949495")
                                                  : HexColor("#6d6d6d"),
                                              fontSize: (18 - i).toDouble(),
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                  ExpandableButton(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.close,
                                        color: isDark
                                            ? HexColor("#949495")
                                            : HexColor("#6d6d6d"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          key: Key(type.key),
                          onTap: () => onTap(type),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              type.icon,
                              color: isDark
                                  ? HexColor("#949495")
                                  : HexColor("#6d6d6d"),
                            ),
                          ),
                        );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
