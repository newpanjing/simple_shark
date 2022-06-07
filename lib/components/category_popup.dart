import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:simple_shark/utils/api.dart';

class CategoryPopup extends StatefulWidget {
  final ValueChanged<int> onChanged;
  const CategoryPopup({Key? key, required this.onChanged}) : super(key: key);

  @override
  _CategoryPopupState createState() => _CategoryPopupState();
}

class _CategoryPopupState extends State<CategoryPopup> {
  int popupValue = 0;
  var _categories = [];

  _getData() {
    //调用API获取数据
    Api.getCategory().then((res) {
      setState(() {
        _categories = res;
        if (res.isNotEmpty) {
          popupValue = res[0]['id'] ?? 0;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    var list = List.generate(_categories.length, (index) {
      var item = _categories[index];
      return MacosPopupMenuItem<int>(
        value: item['id'] ?? 0,
        child: Text(item['title']),
      );
    }).toList();
    return MacosPopupButton<int>(
      value: popupValue,
      onChanged: (int? newValue) {
        setState(() {
          popupValue = newValue!;
          widget.onChanged(newValue);
        });
      },
      items:list,
    );
  }
}
