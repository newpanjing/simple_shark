import 'dart:async';

import 'package:flutter/cupertino.dart';

typedef BooleanCallback = Future<bool> Function();

class TimeButton extends StatefulWidget {
  final BooleanCallback onTap;
  final Widget child;

  const TimeButton({Key? key, required this.onTap, required this.child})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TimeButtonState();
  }
}

class _TimeButtonState extends State<TimeButton> {
  int _countdown = 60;
  bool isCountdown = false;
  late Timer _timer;

  start() {
    _countdown = 60;
    setState(() {
      isCountdown = true;
    });

    //开始倒计时，一秒钟一次
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        _timer.cancel();
        setState(() {
          isCountdown = false;
        });
        return;
      }
      _countdown--;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isCountdown) {
          return CupertinoButton(
            onPressed: () {},
            child: Text(
              '($_countdown秒)后重新发送',
              style: const TextStyle(color: CupertinoColors.inactiveGray),
            ),
          );
        } else {
          return CupertinoButton(
            child: widget.child,
            onPressed: () {
              widget.onTap().then((isSuccess) {
                if (isSuccess) {
                  start();
                }
              });
            },
          );
        }
      },
    );
  }
}
