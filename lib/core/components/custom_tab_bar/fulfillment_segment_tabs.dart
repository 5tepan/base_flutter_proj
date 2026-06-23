import 'package:base_flutter_proj/core/components/custom_tab_bar/fulfillment_pill_tab.dart';
import 'package:base_flutter_proj/core/components/custom_tab_bar/fulfillment_segment_tab.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

class FulfillmentSegmentTabs extends StatefulWidget {
  const FulfillmentSegmentTabs({
    required this.tabs,
    super.key,
    this.style,
    this.initialIndex = 0,
    this.onSelectedChanged,
  });

  final List<FulfillmentSegmentTab> tabs;
  final FulfillmentSegmentTabsStyle? style;
  final int initialIndex;
  final ValueChanged<int>? onSelectedChanged;

  @override
  State<FulfillmentSegmentTabs> createState() => _FulfillmentSegmentTabsState();
}

class _FulfillmentSegmentTabsState extends State<FulfillmentSegmentTabs>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  FulfillmentSegmentTabsStyle get _style =>
      widget.style ?? const FulfillmentSegmentTabsStyle();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialIndex.clamp(0, 1),
    );
    _tabController.addListener(_notifySelection);
  }

  @override
  void didUpdateWidget(FulfillmentSegmentTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex &&
        widget.initialIndex.clamp(0, 1) != _tabController.index) {
      _tabController.index = widget.initialIndex.clamp(0, 1);
    }
  }

  void _notifySelection() {
    if (_tabController.indexIsChanging) return;
    widget.onSelectedChanged?.call(_tabController.index);
  }

  @override
  void dispose() {
    _tabController.removeListener(_notifySelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabRow = _buildTabRow();

    if (_style.tabHeight != null) {
      return SizedBox(height: _style.tabHeight, child: tabRow);
    }

    return IntrinsicHeight(child: tabRow);
  }

  Widget _buildTabRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        2,
        (index) => Expanded(
          child: GestureDetector(
            onTap: () => _tabController.animateTo(index),
            behavior: HitTestBehavior.opaque,
            child: FulfillmentPillTab(
              controller: _tabController,
              index: index,
              tab: widget.tabs[index],
              style: _style,
              height: _style.tabHeight,
              trailingGap: _style.tabGap / 2,
            ),
          ),
        ),
      ),
    );
  }
}
