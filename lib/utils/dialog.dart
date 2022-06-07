import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

showErrorDialog(context, error) {
  showMacosAlertDialog(
      context: context,
      builder: (context) => MacosAlertDialog(
        appIcon: const Icon(
          CupertinoIcons.xmark_circle,
          size: 56,
          color: Colors.red,
        ),
        title: const Text(
          '提示',
        ),
        message: Text(
          error,
          textAlign: TextAlign.center,
        ),
        horizontalActions: false,
        primaryButton: PushButton(
          buttonSize: ButtonSize.large,
          onPressed: Navigator.of(context).pop,
          child: const Text('好的'),
        ),
      ));
}