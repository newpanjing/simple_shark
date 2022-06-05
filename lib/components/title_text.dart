import 'package:flutter/material.dart';

class TitleText extends Text {
  const TitleText(String data, {Key? key, TextStyle? style})
      : super(data, key: key, style: style);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Text(
          data!,
          key: key,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
