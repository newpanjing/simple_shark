import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:simple_shark/utils/api.dart';

class CategoryPopup extends StatefulWidget {
  final ValueChanged<int> onChanged;
  final int? categoryId;

  const CategoryPopup({Key? key, required this.onChanged, this.categoryId})
      : super(key: key);

  @override
  _CategoryPopupState createState() => _CategoryPopupState();
}

class _CategoryPopupState extends State<CategoryPopup> {
  var _categories = [];
  var value = -1;

  _getData() {
    //调用API获取数据
    Api.getCategory().then((res) {
      setState(() {
        _categories = res;
        if (res.isNotEmpty && widget.categoryId == 0) {
          value = res[0]["id"];
          widget.onChanged(value);
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
    return MacosPopupButton<int>(
      value: widget.categoryId != 0 ? widget.categoryId : value,
      onChanged: (int? newValue) {
        widget.onChanged(newValue!);
      },
      items: List.generate(_categories.length, (index) {
        var item = _categories[index];
        return MacosPopupMenuItem<int>(
          value: item['id'] ?? 0,
          child: Text(item['title']),
        );
      }).toList(),
    );
  }
}
