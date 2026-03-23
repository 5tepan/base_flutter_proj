import 'package:flutter/material.dart';

class AppPageView<T> extends StatefulWidget {
  const AppPageView({
    required this.items,
    required this.itemBuilder,
    super.key,
    this.controller,
    this.onPageChanged,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final PageController? controller;
  final ValueChanged<int>? onPageChanged;

  @override
  State<AppPageView<T>> createState() => _AppPageViewState<T>();
}

class _AppPageViewState<T> extends State<AppPageView<T>> {
  late final PageController _controller = widget.controller ?? PageController();

  bool get _shouldDisposeController => widget.controller == null;

  @override
  void dispose() {
    if (_shouldDisposeController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      itemCount: widget.items.length,
      onPageChanged: widget.onPageChanged,
      itemBuilder: (context, index) {
        return widget.itemBuilder(context, widget.items[index], index);
      },
    );
  }
}
