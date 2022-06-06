import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_shark/components/comment_item.dart';
import 'package:simple_shark/components/user_info.dart';
import 'package:simple_shark/model/user.dart';
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
  List comments = [];
  var showEditor = false;
  var comment = "";
  var isPushing = false;
  var token = "";

  pushComment() {
    //判断评论是否为空
    if (comment.isEmpty) {
      //提示
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text("评论不能为空"),
              actions: [
                CupertinoDialogAction(
                  child: const Text("确定"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
      return;
    }
    setState(() {
      isPushing = true;
    });

    //发送评论

    Api(token: token).postComment(widget.id, comment).then((res) {
      setState(() {
        isPushing = false;
      });

      if (res["code"] == 1) {
        setState(() {
          comment = "";
          // showEditor = false;
        });
        //刷新评论列表
        _getData();
      } else {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('评论失败:${res['msg']}'),
                actions: [
                  CupertinoDialogAction(
                    child: const Text("确定"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<UserModel>(context).userInfo;

    token = currentUser["token"];
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
                onPressed: () {
                  //判断是否登陆了
                  if (currentUser.isEmpty) {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: const Text("提示"),
                        content: const Text("请先登陆"),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text("确定"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    );
                    return;
                  }

                  setState(() => showEditor = !showEditor);
                })
          ],
        ),
        if (showEditor)
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Material(
                  child: TextField(
                    controller: TextEditingController.fromValue(
                        TextEditingValue(
                            text: comment,
                            selection: TextSelection.fromPosition(TextPosition(
                                affinity: TextAffinity.downstream,
                                offset: comment.length)))),
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "请输入评论内容，支持markdown语法",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => comment = value,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (currentUser.isNotEmpty)
                      UserInfo(
                        avatar: currentUser["avatar"],
                        name: currentUser["name"],
                      ),
                    if (isPushing)
                      Row(
                        children: const [
                          CupertinoActivityIndicator(),
                          SizedBox(width: 10),
                          Text("正在提交..."),
                        ],
                      ),
                    if (!isPushing)
                      CupertinoButton(
                          onPressed: pushComment,
                          child: Row(
                            children: const [
                              Icon(CupertinoIcons.checkmark_alt),
                              Text("发布评论"),
                            ],
                          ))
                  ],
                ),
                // const MacosDivider(),
              ],
            ),
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
                        CommentItem(
                          data: comments[index],
                          onRefresh: onRefresh,
                          targetId: widget.id,
                        )
                      ],
                    );
                  }
                  return CommentItem(
                    data: comments[index],
                    onRefresh: onRefresh,
                    targetId: widget.id,
                  );
                }).toList(),
              )
      ],
    );
  }

  onRefresh() {
    _getData();
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
