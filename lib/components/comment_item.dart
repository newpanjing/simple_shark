import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'package:simple_shark/components/html_render.dart';
import 'package:simple_shark/components/user_info.dart';
import 'package:simple_shark/model/user.dart';

import '../utils/api.dart';

class CommentItem extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onRefresh;
  final int targetId;

  const CommentItem(
      {Key? key,
      required this.data,
      required this.onRefresh,
      required this.targetId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CommentItemState();
  }
}

class _CommentItemState extends State<CommentItem> {
  var isShowReply = false;
  var isPushing = false;
  var replyContent = '';
  late Api api;

  reply() {
    setState(() {
      isPushing = false;
      isShowReply = !isShowReply;
    });
    debugPrint('reply');
  }

  postReply() {
    setState(() {
      isPushing = true;
    });
    debugPrint('postReply');

    var data = widget.data;
    var parentId = data['id'];
    var content = replyContent;
    var user = data['user'];
    api
        .postComment(widget.targetId, content,
            parentId: parentId, replyUserId: user['id'])
        .then((res) {
      if (res['code'] != 1) {
        //提示错误弹框
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('回复失败:${res['msg']}'),
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
      // debugPrint(res);
      widget.onRefresh();
      setState(() {
        isPushing = false;
        replyContent = '';
        isShowReply = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MacosTheme.of(context).brightness.isDark;

    //获取当前用户
    var userInfo = Provider.of<UserModel>(context).userInfo;
    var token = userInfo["token"];
    api = Api(token: token);

    var data = widget.data;
    var user = data["user"];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UserInfo(
              avatar: user["avatar"],
              name: user["name"],
            ),
            Row(
              children: [
                Text(data["createTime"]),
              ],
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Column(children: [
            HtmlRenderWidget(html: data["contentRendered"]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                        child: Text(
                          "👍点赞(${data["up"]})",
                          style: const TextStyle(fontSize: 14),
                        ),
                        onPressed: () {
                          Api(token: token).upComment(data["id"]).then((value) {
                            widget.onRefresh();
                          });
                        }),
                    CupertinoButton(
                        onPressed: reply,
                        child: Text("️回复(${data["children"].length})",
                            style: const TextStyle(fontSize: 14))),
                  ],
                ),
                if (userInfo.isNotEmpty && userInfo["isStaff"] as bool)
                  CupertinoButton(
                      child: const Text(
                        "删除",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      onPressed: () {
                        //弹出确认框
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                                title: const Text("确认删除该评论？"),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text("取消"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  CupertinoDialogAction(
                                      child: const Text("确认"),
                                      onPressed: () {
                                        var id = data["id"] as int;

                                        Api(token: token)
                                            .deleteComment(id)
                                            .then((value) {
                                          if (value["code"] != 1) {
                                            //显示错误
                                            showCupertinoDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CupertinoAlertDialog(
                                                      title: Text(
                                                          "删除失败:${value['msg']}"));
                                                });

                                            //end
                                          } else {
                                            //删除成功
                                            Navigator.of(context).pop();
                                            //刷新评论列表
                                            widget.onRefresh();
                                          }
                                        });
                                        //删除评论
                                      })
                                ]);
                          },
                        );
                      }),
              ],
            ),
            if (isShowReply)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Material(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          UserInfo(
                            avatar: userInfo["avatar"],
                            name: userInfo["name"],
                          ),
                          CupertinoButton(
                            child: const Text("取消"),
                            onPressed: () {
                              setState(() {
                                isShowReply = false;
                              });
                            },
                          ),
                        ],
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            replyContent = value;
                          });
                        },
                        maxLines: null,
                        controller: TextEditingController.fromValue(
                            TextEditingValue(
                                text: replyContent,
                                selection: TextSelection.fromPosition(
                                    TextPosition(
                                        affinity: TextAffinity.downstream,
                                        offset: replyContent.length)))),
                        decoration: InputDecoration(
                          hintText: "回复：${user["name"]}",
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (isPushing)
                            Row(
                              children: const [
                                CupertinoActivityIndicator(),
                                Text("正在提交..."),
                              ],
                            ),
                          if (!isPushing)
                            CupertinoButton(
                              onPressed: postReply,
                              child: const Text("回复"),
                            )
                        ],
                      )
                    ],
                  ),
                ),
              )
          ]),
        ),
        LayoutBuilder(builder: (context, constraints) {
          var children = data["children"] as List;
          if (children.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                    color: isDark ? HexColor("#252628") : HexColor("#eeeeee"),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: List.generate(
                        children.length,
                        (index) => CommentItem(
                              data: children[index],
                              onRefresh: widget.onRefresh,
                              targetId: widget.targetId,
                            )),
                  ),
                ),
              ),
            );
          }
          return const SizedBox(
            height: 0,
          );
        }),
      ],
    );
  }
}
