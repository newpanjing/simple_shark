import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'package:simple_shark/components/divider.dart';
import 'package:simple_shark/model/user.dart';
import 'package:simple_shark/utils/avatar.dart';

import 'login.dart';

class Bottom extends StatefulWidget {
  const Bottom({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  @override
  void initState() {
    super.initState();
  }

  _setUserInfo(userInfo) {
    Provider.of<UserModel>(context, listen: false).setUserInfo(userInfo);
  }

  @override
  Widget build(BuildContext context1) {
    var userInfo = Provider.of<UserModel>(context1).userInfo;

    return Column(
      children: [
        if (userInfo.isNotEmpty) const MacosDivider(),
        if (userInfo.isNotEmpty)
          CupertinoButton(
              child: Row(
                children: const [
                  Icon(Icons.edit),
                  Text("发布帖子"),
                ],
              ),
              onPressed: () {}),
        const MacosDivider(),
        Consumer<UserModel>(
          builder: (context, counter, child) {
            if (counter.userInfo.isEmpty) {
              return PushButton(
                  buttonSize: ButtonSize.large,
                  onPressed: () {
                    showLoginDialog(context, (userInfo) {
                      _setUserInfo(userInfo);
                    });
                  },
                  child: const Text("点击登陆"));
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    ClipOval(
                      child: Image.network(
                        getAvatar(counter.userInfo["avatar"]),
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        Text(
                          counter.userInfo["name"],
                          style: MacosTheme.of(context).typography.title3,
                        ),
                      ],
                    )
                  ]),
                  MacosIconButton(
                      icon: const Icon(CupertinoIcons.clear_circled),
                      onPressed: () {
                        showMacosAlertDialog(
                          context: context,
                          builder: (context) => MacosAlertDialog(
                            appIcon: const FlutterLogo(
                              size: 56,
                            ),
                            title: const Text(
                              '您确定要退出登陆吗？',
                            ),
                            //horizontalActions: false,
                            primaryButton: PushButton(
                              buttonSize: ButtonSize.large,
                              onPressed: () {
                                counter.setUserInfo({});
                                Navigator.of(context).pop();
                              },
                              child: const Text('确定'),
                            ),
                            secondaryButton: PushButton(
                              buttonSize: ButtonSize.large,
                              isSecondary: true,
                              onPressed: Navigator.of(context).pop,
                              child: const Text('取消'),
                            ),
                            message: const Text(""),
                          ),
                        );
                      }),
                ],
              );
            }
          },
        ),
      ],
    );
  }
}
