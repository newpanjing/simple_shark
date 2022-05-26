import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showLoadingDialog(context) {
  showDialog(
    context: context,
    builder: (context) => Center(
      child: Container(
        width: 70.0,
        height: 70.0,
        decoration: BoxDecoration(
          color: const Color.fromARGB(100, 255, 255, 255),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: const [
              CupertinoActivityIndicator(),
              Text(
                "加载中",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
