import 'package:flutter/cupertino.dart';

class LoadingMoreScrollView extends StatefulWidget {
  Widget? child;
  final VoidCallback? onLoadingMore;
  LoadingMoreScrollView({required this.child, Key? key, this.onLoadingMore})
      : super(key: key);

  @override
  _LoadingMoreScrollViewState createState() => _LoadingMoreScrollViewState();
}

class _LoadingMoreScrollViewState extends State<LoadingMoreScrollView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.onLoadingMore?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: widget.child,
    );
  }

  _LoadingMoreScrollViewState();
}
