import 'package:base_flutter_proj/core/components/bottom_sheet/app_bottom_sheet_style.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Тело bottom sheet: drag-handle, заголовок, контент.
class AppBottomSheetPanel extends StatelessWidget {
  const AppBottomSheetPanel({
    required this.child,
    super.key,
    this.title,
    this.titleWidget,
    this.style = const AppBottomSheetStyle(),
    this.showCloseButton = true,
    this.onClose,
    this.headerActions,
    this.header,
    this.footer,
    this.expand = false,
    this.scrollable = false,
    this.safeAreaBottom = true,
  }) : assert(
         title == null || titleWidget == null,
         'Задайте либо title, либо titleWidget.',
       );

  final String? title;
  final Widget? titleWidget;
  final Widget child;
  final AppBottomSheetStyle style;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final Widget? headerActions;
  final Widget? header;
  final Widget? footer;
  final bool expand;
  final bool scrollable;
  final bool safeAreaBottom;

  bool get _hasTitle => title != null || titleWidget != null;
  bool get _hasHeader => _hasTitle || header != null || showCloseButton;

  @override
  Widget build(BuildContext context) {
    final content = _buildContent(context);

    return Material(
      color: style.backgroundColor,
      borderRadius: style.borderRadius,
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        bottom: safeAreaBottom,
        child: Column(
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (style.showDragHandle) ...[
              _buildDragHandle(),
              if (style.gapAfterDragHandle > 0) Gap(style.gapAfterDragHandle),
            ],
            if (_hasHeader) _buildHeader(context),
            if (expand)
              Expanded(child: content)
            else
              content,
            if (footer != null) footer!,
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    final customHandle = style.dragHandle;
    if (customHandle != null) {
      return Padding(
        padding: style.dragHandlePadding,
        child: Center(child: customHandle),
      );
    }

    return Padding(
      padding: style.dragHandlePadding,
      child: Center(
        child: Container(
          width: style.dragHandleWidth,
          height: style.dragHandleHeight,
          decoration: BoxDecoration(
            color: style.dragHandleColor,
            borderRadius: BorderRadius.circular(style.dragHandleHeight),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    if (header != null) {
      return header!;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: style.headerPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _hasTitle
                    ? titleWidget ??
                        Text(
                          title!,
                          style: style.titleStyleOrDefault(context),
                        )
                    : const SizedBox.shrink(),
              ),
              if (headerActions != null) ...[
                headerActions!,
                const Gap(4),
              ],
              if (showCloseButton)
                IconButton(
                  tooltip: style.closeButtonTooltip ??
                      MaterialLocalizations.of(context).closeButtonTooltip,
                  onPressed: onClose ?? () => Navigator.of(context).pop(),
                  icon: Icon(
                    style.closeIcon,
                    color: style.closeIconColor,
                  ),
                ),
            ],
          ),
        ),
        if (style.showHeaderDivider)
          Divider(height: 1, color: style.headerDividerColor),
        if (_hasTitle && style.gapAfterHeader > 0) Gap(style.gapAfterHeader),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    Widget content = Padding(
      padding: style.contentPadding,
      child: child,
    );

    if (scrollable) {
      content = SingleChildScrollView(child: content);
    }

    return content;
  }
}
