import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:photo_view/photo_view.dart';
import 'package:simple_shark/utils/html.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlRenderWidget extends StatefulWidget {
  final String html;

  const HtmlRenderWidget({Key? key, required this.html}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HtmlRenderWidgetState();
  }
}

class _HtmlRenderWidgetState extends State<HtmlRenderWidget> {
  String getHtml() {
    return getProcessHtml(widget.html);
  }

  processTheme() {
    Map<String, Style> style = {
      "*": Style(
        lineHeight: const LineHeight(1.5),
      ),
      "pre": Style(
        lineHeight: const LineHeight(1.5),
      ),
      ".k": Style(
        color: HexColor("#a90d91"),
      ),
      ".bp": Style(
        color: HexColor("#5b269a"),
      ),
      ".nb": Style(
        color: HexColor("#a90d91"),
      ),
      ".p": Style(
        color: HexColor("#e83e8c"),
      ),
      ".s1": Style(
        color: HexColor("#c41a16"),
      ),
      ".s2": Style(
        color: HexColor("#c41a16"),
      ),
      ".c1": Style(
        color: HexColor("#177500"),
      ),
      ".kc": Style(
        color: HexColor("#a90d91"),
      ),
      ".sb": Style(
        color: HexColor("#c41a16"),
      ),
      ".sa": Style(
        color: HexColor("#c41a16"),
      ),
      ".kd": Style(
        color: HexColor("#a90d91"),
      ),
      ".c": Style(
        color: HexColor("#177500"),
        // textDecorationColor: HexColor("#cccccc"),
      ),
      ".nc": Style(
        color: HexColor("#3f6e75"),
      ),
    };

    var isDark = MacosTheme.of(context).brightness.isDark;
    if (isDark) {
      var textStyle = Style(color: HexColor("#adbac7"));
      style.addAll({
        "div": Style(color: Colors.white),
        "p": textStyle,
        "h1": textStyle,
        "h2": textStyle,
        "h3": textStyle,
        "h4": textStyle,
        "h5": textStyle,
        "blockquote": Style(
          color: HexColor("#adbac7"),
          backgroundColor: HexColor("#262728"),
          padding: const EdgeInsets.all(20),
          border: Border(
            left: BorderSide(
              color: HexColor("#49b1f5"),
              width: 3,
              style: BorderStyle.solid,
            ),
          ),
        ),
      });
    } else {
      style.addAll({"div": Style(color: Colors.black)});
    }

    return style;
  }

  @override
  Widget build(BuildContext context) {
    return Html(
      style: processTheme(),
      data: getHtml(),
      onLinkTap: (url, a, b, c) {
        // launchUrl(url);
        print(url);
      },
      onImageTap: (url, a, b, c) {
        // launchUrl(url);
        showDialog(
          context: context,
          builder: (context) => Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth - 100,
                  height: constraints.maxHeight - 100,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: PhotoView(
                      backgroundDecoration: const BoxDecoration(
                        color: Color.fromARGB(0, 255, 255, 255),
                      ),
                      imageProvider: NetworkImage(url!),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
