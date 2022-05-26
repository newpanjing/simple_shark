import 'package:flutter/material.dart';

class TabbarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TabbarWidgetState();
  }
}

class _TabbarWidgetState extends State<TabbarWidget> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Tab1'),
    Tab(text: 'Tab2'),
    Tab(text: 'Tab3'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: TabBar(
                  tabs: myTabs,
                  isScrollable: true,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
        ),
        body: TabBarView(
          children: <Widget>[
            ListView(
              children: [
                ListTile(
                  title: Text("第一个tab"),
                ),
                ListTile(
                  title: Text("第一个tab"),
                ),
              ],
            ),
            ListView(
              children: [
                ListTile(
                  title: Text("第二个tab"),
                ),
                ListTile(
                  title: Text("第二个tab"),
                ),
              ],
            ),
            ListView(
              children: [
                ListTile(
                  title: Text("第三个tab"),
                ),
                ListTile(
                  title: Text("第二个tab"),
                ),
              ],
            ),
            ListView(
              children: [
                ListTile(
                  title: Text("第四个tab"),
                ),
                ListTile(
                  title: Text("第二个tab"),
                ),
              ],
            ),
            ListView(
              children: [
                ListTile(
                  title: Text("第五个tab"),
                ),
                ListTile(
                  title: Text("第二个tab"),
                ),
              ],
            ),
            ListView(
              children: [
                ListTile(
                  title: Text("第6个tab"),
                ),
                ListTile(
                  title: Text("第二个tab"),
                ),
              ],
            ), ListView(
              children: [
                ListTile(
                  title: Text("第7个tab"),
                ),
                ListTile(
                  title: Text("第二个tab"),
                ),
              ],
            ),
            ListView(
              children: [
                ListTile(
                  title: Text("第8个tab"),
                ),
                ListTile(
                  title: Text("第二个tab"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
