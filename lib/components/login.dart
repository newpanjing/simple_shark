import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'package:simple_shark/components/time_button.dart';
import 'package:simple_shark/model/user.dart';
import 'package:simple_shark/utils/api.dart';
import 'package:uuid/uuid.dart';

typedef SuccessCallback = void Function(Map<String, dynamic> userInfo);

class LoginWidget extends StatefulWidget {

  final SuccessCallback onSuccess;
  final VoidCallback onClose;
  const LoginWidget({Key? key, required this.onSuccess, required this.onClose}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginWidgetState();
  }
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();

  String mobile = '';
  String uid = '';
  String codeImgUrl = '';

  //图像验证码
  String verfCode = '';

  //短信验证码
  String smsCode = '';

  @override
  void initState() {
    super.initState();
    refreshCodeUrl();
  }

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

  refreshCodeUrl() {
    uid = Uuid().v4();
    setState(() {
      codeImgUrl = Api.getVerfyCodeUrl(uid);
    });
  }

  Future<bool> sendSmsCode() async {
    if (mobile.isEmpty) {
      showErrorDialog(context, '请输入手机号');
      return false;
    }
    if (verfCode.isEmpty) {
      showErrorDialog(context, '请输入图像验证码');
      return false;
    }

    var result = false;
    //阻塞
    var res = await Api.sendSmsCode(verfCode, uid, mobile);
    debugPrint('send sms code:$res');
    if (res['code'] == 1) {
      //发送成功，启用倒计时
      result = true;
    } else {
      showErrorDialog(context, res['msg']);
      result = false;
    }

    return result;
  }

  loginSubmit() {

    // var user={"id": 1, "name": "社区小助手", "avatar": "/media/uploads/8SkkOIRI.webp", "verify": true, "verifyDesc": "官方账号", "isStaff": true, "token": "c1e22ede-cf86-440a-9250-92f56e93afd5"};
    // widget.onSuccess(user);
    // widget.onClose();
    // if(1==1){
    //   return;
    // }
    debugPrint('verify code:$mobile');

    if (mobile.isEmpty) {
      showErrorDialog(context, '请输入手机号');
      return;
    }

    if (verfCode.isEmpty) {
      showErrorDialog(context, '请输入图像验证码');
      return;
    }

    if (smsCode.isEmpty) {
      showErrorDialog(context, '请输入短信验证码');
      return;
    }

    Api.smsLogin(mobile, smsCode).then((res) {
      debugPrint('login:$res');
      if (res['code'] == 1) {
        //设置用户信息
        debugPrint("user ${res['user']}");
        widget.onSuccess(res['user']);
        widget.onClose();
      } else {
        showErrorDialog(context, res['msg']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350,
        height: 350,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: const Text(
                "登陆",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child: MacosTextField(
                  placeholder: "请输入手机号",
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    mobile = value;
                  },
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                )),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child: MacosTextField(
                  keyboardType: TextInputType.number,
                  placeholder: "请输入图像验证码",
                  // style: const TextStyle(
                  //   fontSize: 28,
                  //   letterSpacing: 1.5
                  // ),
                  onChanged: (value) {
                    verfCode = value;
                  },
                )),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 150,
                  child: GestureDetector(
                    onTap: refreshCodeUrl,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(codeImgUrl),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child: MacosTextField(
                  placeholder: "请输入短信验证码",
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    smsCode = value;
                  },
                )),
                const SizedBox(
                  width: 10,
                ),
                TimeButton(
                  onTap: sendSmsCode,
                  child: const Text("发送验证码"),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            //取消和登陆
            Row(children: [
              Expanded(
                child: PushButton(
                  isSecondary: true,
                  buttonSize: ButtonSize.large,
                  onPressed: Navigator.of(context).pop,
                  child: const Text("取消"),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: PushButton(
                  buttonSize: ButtonSize.large,
                  onPressed: loginSubmit,
                  child: const Text("登陆"),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

showLoginDialog(context, SuccessCallback callback) {
  showCupertinoDialog(context: context, builder: (context) => LoginWidget(onSuccess: callback,onClose: (){
    Navigator.of(context).pop();
  }));
}
