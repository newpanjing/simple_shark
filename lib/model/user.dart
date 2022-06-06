import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel with ChangeNotifier {
  Map<String, dynamic> userInfo = {};

  late SharedPreferences prefs;
  final _key = 'userInfo';

  UserModel() {
    //初始化用户信息
    SharedPreferences.getInstance().then((value) {
      prefs = value;
      //判断是否有用户信息
      if (prefs.containsKey(_key)) {
        var value = prefs.getString(_key);
        userInfo = json.decode(value!) as Map<String, dynamic>;
      }
    });
  }

  setUserInfo(Map<String, dynamic> userInfo) {
    this.userInfo = userInfo;
    if (userInfo == null) {
      prefs.remove(_key);
    }else {
      prefs.setString(_key, json.encode(userInfo));
    }
    notifyListeners();
  }
}
