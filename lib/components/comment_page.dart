import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_shark/components/comment_item.dart';
import 'package:simple_shark/utils/api.dart';

import 'divider.dart';

class CommentPage extends StatefulWidget {
  final int id;

  const CommentPage({Key? key, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CommentState();
  }
}

class _CommentState extends State<CommentPage> {
  late List comments;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MacosDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "评论列表",
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.left,
            ),
            CupertinoButton(
                child: Row(
                  children: const [
                    Icon(CupertinoIcons.pencil),
                    Text("撰写评论"),
                  ],
                ),
                onPressed: () {})
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        comments.isEmpty
            ? const Text("暂时没有评论")
            : Column(
                children: List.generate(comments.length, (index) {
                  if (comments.length > 1) {
                    return Column(
                      children: [
                        const MacosDivider(),
                        CommentItem(data: comments[index])
                      ],
                    );
                  }
                  return CommentItem(data: comments[index]);
                }).toList(),
              )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    Api.getComments(widget.id).then((res) {
      setState(() {
        comments = res;
      });
    });
  }
}
