import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

const baseName = "https://simpleui.72wo.com/api";

class Api {
  static get(url) async {
    var response = await http.get(Uri.parse(baseName + url));
    return _decode(response);
  }

  static post(url, body) async {
    var response = await http
        .post(Uri.parse(baseName + url), body: jsonEncode(body), headers: {
      "Content-Type": "application/json",
    });
    return _decode(response);
  }

  static _decode(response) {
    //解析数据
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    }
    return json.decode(response.body);
  }

  /// 获取banner
  static getBanners() async {
    return get("/carousel");
  }

  static getCategory() async {
    return get("/category");
  }

  static getArticleList() async {
    return get("/article/list");
  }

  static getTopics(int page, int nodeId) async {
    if (page <= 0) {
      page = 0;
    }
    var params = {"page": page};
    if (nodeId != -1) {
      params["pk"] = nodeId;
    }
    return post("/topic", params);
  }

  static getTopic(int id) async {
    return post("/topic/id", {"id": id});
  }

  static getComments(targetId) async {
    var res =
        await post("/comment/list", {"targetId": targetId, "targetType": 0});
    return res["comments"] as List;
  }

  static search(keyword, int page) async {
    if (page <= 0) {
      page = 0;
    }
    return post("/search", {"q": keyword, "page": page});
  }

  static getVerfyCodeUrl(uid) {
    return "$baseName/verification/code?uid=$uid";
  }

  static sendSmsCode(code, uid, phone) async {
    return post("/sms/code", {"code": code, "uid": uid, "phone": phone});
  }

  static smsLogin(phone, smsCode) async {
    return post("/sms/login", {"phone": phone, "smsCode": smsCode});
  }
}

void main() async {
  // var r = await Api.search("simpleui", 1);
  // print(r);
}
