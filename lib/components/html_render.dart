import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macos_ui/macos_ui.dart';
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
  @override
  Widget build(BuildContext context) {
    var isDark = MacosTheme.of(context).brightness.isDark;
    Map<String, Style> style = {};
    if (isDark) {
      var textStyle = Style(color: HexColor("#adbac7"));
      style = {
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
        )
      };
    } else {
      style = {"div": Style(color: Colors.black)};
    }
    return SelectableHtml(
      style: style,
      data: widget.html,
      onLinkTap: (String? url,a,b,c)  {
        // launchUrl(url);
        print(url);
      },
    );
  }
}
