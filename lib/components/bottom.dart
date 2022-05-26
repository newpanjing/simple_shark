import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

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
            SizedBox(
              width: 200,
              child: Column(
                children: [
                  MacosTextField(
                    placeholder: "输入手机号",
                  ),
                  // Row(
                  //   children: [
                  //     MacosTextField(
                  //       placeholder: "图像验证码",
                  //     ),
                  //     Image.network("https://simpleui.72wo.com/api/verification/code?uid=3e4853d3-338a-4171-a4bf-fd02be6314dd")
                  //   ],
                  // )
                ],
              ),
            ),
            PushButton(
              buttonSize: ButtonSize.large,
              child: const Text('下一步'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 50),
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

  @override
  Widget build(BuildContext context) {
    /**
     * const MacosListTile(
        leading: MacosIcon(CupertinoIcons.profile_circled),
        title: Text('Tim Apple'),
        subtitle: Text('tim@apple.com'),
        )
     */
    return PushButton(
        buttonSize: ButtonSize.large,
        onPressed: () {
          print("点击登陆");
          showMacosSheet(
            context: context,
            builder: (_) => const MacosuiSheet(),
          );
        },
        child: const Text("点击登陆"));
  }
}
