import 'dart:math';

import 'package:base_flutter_proj/core/base/base_pages/base_form/app_form_controller.dart';
import 'package:flutter/material.dart';

enum AppFormType { normal, fullScreenSize, sliverFixedFooter }

class AppForm extends StatefulWidget {
  const AppForm({
    required this.controller,
    required this.child,
    super.key,
    this.formType = AppFormType.normal,
    this.footer,
    this.useAutofillGroup = true,
    this.useSafeArea = true,
  });

  final AppFormController controller;
  final Widget child;
  final AppFormType formType;
  final Widget? footer;
  final bool useAutofillGroup;
  final bool useSafeArea;

  @override
  State<AppForm> createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  double _maxPageHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final primaryController = PrimaryScrollController.of(context);
      widget.controller.scrollController.parentController = primaryController;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.formType) {
      case AppFormType.normal:
        return _buildDefaultFormBody(context);
      case AppFormType.fullScreenSize:
        return _buildFullScreenSizeFormBody(context);
      case AppFormType.sliverFixedFooter:
        return _buildSliverFormBody(context);
    }
  }

  Widget _wrapFormChild(Widget child) {
    Widget result = child;

    if (widget.useSafeArea) {
      result = SafeArea(child: result);
    }

    if (widget.useAutofillGroup) {
      result = AutofillGroup(child: result);
    }

    return Form(
      key: widget.controller.formKey,
      autovalidateMode: widget.controller.autovalidateMode,
      child: result,
    );
  }

  Widget _buildDefaultFormBody(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.controller.scrollController,
      child: _wrapFormChild(widget.child),
    );
  }

  Widget _buildFullScreenSizeFormBody(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _maxPageHeight = max(constraints.maxHeight, _maxPageHeight);

        return SingleChildScrollView(
          controller: widget.controller.scrollController,
          child: SizedBox(
            width: constraints.maxWidth,
            height: _maxPageHeight,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: _maxPageHeight),
              child: _wrapFormChild(widget.child),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSliverFormBody(BuildContext context) {
    return CustomScrollView(
      controller: widget.controller.scrollController,
      shrinkWrap: true,
      slivers: [
        SliverToBoxAdapter(child: _wrapFormChild(widget.child)),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: widget.footer ?? const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
