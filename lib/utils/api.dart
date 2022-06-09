import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

const baseName = "https://simpleui.72wo.com/api";
// const baseName = "http://192.168.31.9:8003/api";

class Api {
  //用户的token
  String token;
  var headers = {
    "Content-Type": "application/json",
    "version": "1.0",
    "from": "pc-client",
  };

  Api({required this.token});

  static get(url) async {
    var dio = Dio();
    var res = await dio.get(baseName + url);
    return res.data;
  }

  post(url, body) async {
    var dio = Dio();
    var res = await dio.post(baseName + url,
        data: body,
        options: Options(headers: {
          ...headers,
          "token": token,
        }));
    return res.data;
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
    return Api(token: "").post("/topic", params);
  }

  static getTopic(int id) async {
    return Api(token: "").post("/topic/id", {"id": id});
  }

  static getComments(targetId) async {
    var res = await Api(token: "")
        .post("/comment/list", {"targetId": targetId, "targetType": 0});
    return res["comments"] as List;
  }

  static search(keyword, int page) async {
    if (page <= 0) {
      page = 0;
    }
    return Api(token: "").post("/search", {"q": keyword, "page": page});
  }

  static getVerfyCodeUrl(uid) {
    return "$baseName/verification/code?uid=$uid";
  }

  static sendSmsCode(code, uid, phone) async {
    return Api(token: "")
        .post("/sms/code", {"code": code, "uid": uid, "phone": phone});
  }

  static smsLogin(phone, smsCode) async {
    return Api(token: "")
        .post("/sms/login", {"phone": phone, "smsCode": smsCode});
  }

  postComment(targetId, content, {parentId, replyUserId}) async {
    return post("/comment/post", {
      "targetId": targetId,
      "targetType": 0,
      "content": content,
      "parentId": parentId,
      "replyUserId": replyUserId
    });
  }

  deleteComment(id) async {
    return post("/comment/delete", {"id": id});
  }

  upComment(id) async {
    return post("/comment/up", {"id": id});
  }

  postTopic(title, content, categoryId, {id}) async {
    return post("/post/topic",
        {"title": title, "content": content, "nodeId": categoryId, "id": id});
  }

  deleteTopic(id) async {
    return post("/topic/delete", {"id": id});
  }

  getTopicEditData(id) async {
    return post("/topic/edit/data", {"id": id});
  }

  upload(buffer) async {
    FormData formData = FormData.fromMap(
        {"file": MultipartFile.fromBytes(buffer, filename: "file.jpg")});

    var res = await Dio().post(
      "$baseName/upload",
      data: formData,
      options: Options(headers: {
        ...headers,
        "token": token,
      }),
      onSendProgress: (int sent, int total) {
        debugPrint("uploading: ${sent / total}");
      },
    );
    return res.data;
  }
}

void main() async {
  var r = await Api.search("simpleui", 1);
  print(r);
}
