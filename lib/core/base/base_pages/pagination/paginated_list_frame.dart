import 'package:flutter/material.dart';

/// Обёртка для paginated list/grid с **фиксированным** header/footer.
///
/// Scroll-слоты передавайте в [PaginatedListView.header] / [footer]
/// или [PaginatedGridView.header] / [footer].
class PaginatedListFrame extends StatelessWidget {
  const PaginatedListFrame({
    required this.child,
    super.key,
    this.fixedHeader,
    this.fixedFooter,
  });

  final Widget child;
  final Widget? fixedHeader;
  final Widget? fixedFooter;

  @override
  Widget build(BuildContext context) {
    if (fixedHeader == null && fixedFooter == null) {
      return child;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (fixedHeader != null) fixedHeader!,
        Expanded(child: child),
        if (fixedFooter != null) fixedFooter!,
      ],
    );
  }
}
