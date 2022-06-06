import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'package:simple_shark/model/user.dart';
import 'package:simple_shark/utils/avatar.dart';
import 'package:simple_shark/utils/loading.dart';

import 'login.dart';

class Bottom extends StatefulWidget {
  const Bottom({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomState();
}

class MacosuiSheet extends StatelessWidget {
  const MacosuiSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return MacosSheet(
      insetPadding: EdgeInsets.symmetric(horizontal: 140.0, vertical: 48.0),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const FlutterLogo(
              size: 56,
            ),
            const SizedBox(height: 24),
            Text(
              '欢迎登陆Simple社区',
              style: MacosTheme.of(context).typography.largeTitle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                MacosListTile(
                  leading: MacosIcon(CupertinoIcons.lightbulb),
                  title: Text(
                    '登陆之后可以更好的为您提供服务',
                    //style: MacosTheme.of(context).typography.headline,
                  ),
                  subtitle: Text(
                    '发帖、查看订单等',
                  ),
                ),
              ],
            ),
            // const Spacer(),
            // LoginWidget(),
          ],
        ),
      ),
    );
  }
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
    return Consumer<UserModel>(
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
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    Text(
                      counter.userInfo["name"],
                      style: MacosTheme.of(context).typography.title2,
                    ),
                    // if(counter.userInfo["verify"] as bool)
                    //   Text(
                    //     counter.userInfo["verifyDesc"] as String,
                    //     style:TextStyle(
                    //       color:  MacosTheme.of(context).dividerColor
                    //     ),
                    //   ),
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
    );
  }
}
