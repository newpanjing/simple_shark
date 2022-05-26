import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Tag extends StatefulWidget {
  final String text;

  const Tag(this.text, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TagState();
  }
}

class _TagState extends State<Tag> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: HexColor("#e9faf6"),
          border: Border.all(color: HexColor("#45d1b2")),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Text(
          widget.text,
          style: TextStyle(color: HexColor("#45d1b2"), fontSize: 13),
        ),
      ),
    );
  }
}
