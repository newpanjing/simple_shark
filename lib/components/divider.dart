import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class MacosDivider extends StatelessWidget {
  const MacosDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: MacosTheme.of(context).dividerColor,
    );
  }
}
