import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/core/base/base_pages/base_form/app_form.dart';
import 'package:base_flutter_proj/core/base/base_pages/base_form/app_form_controller.dart';
import 'package:base_flutter_proj/core/base/base_pages/base_form/form_submit_helper.dart';
import 'package:base_flutter_proj/core/components/decorated_text_form_field.dart';
import 'package:base_flutter_proj/core/helpers/assets_catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseAuthFormPage extends StatefulWidget {
  final Widget? startInfo;
  final TextEditingController fieldController;
  final Widget? bottomWidget;
  final String? fieldLabel;
  final String buttonText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String? value)? validator;
  final ValueChanged<String>? onChanged;
  final Future<void> Function(String value)? onContinue;
  final bool isSubmitting;
  final double horizontalPadding;
  final AppFormType formType;
  final double logoSize;
  final AppPageAppBarConfig appBarConfig;
  final AppPageBodyConfig bodyConfig;
  final InputDecoration decoration;

  const BaseAuthFormPage({
    this.startInfo,
    required this.fieldController,
    this.bottomWidget,
    super.key,
    this.fieldLabel,
    this.buttonText = 'Продолжить',
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onContinue,
    this.isSubmitting = false,
    this.horizontalPadding = 16,
    this.formType = AppFormType.fullScreenSize,
    this.logoSize = 90,
    this.appBarConfig = const AppPageAppBarConfig(),
    this.bodyConfig = const AppPageBodyConfig(),
    this.decoration = const InputDecoration(),
  });

  @override
  State<BaseAuthFormPage> createState() => _BaseAuthFormPageState();
}

class _BaseAuthFormPageState extends State<BaseAuthFormPage> {
  final AppFormController _formController = AppFormController();

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      appBarConfig: widget.appBarConfig,
      bodyConfig: widget.bodyConfig,
      isLoading: widget.isSubmitting,
      body: AppForm(
        controller: _formController,
        formType: widget.formType,
        useSafeArea: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
          child: Column(
            spacing: 20,
            children: [
              const Spacer(),
              Image.asset(
                AssetsCatalog.logo,
                height: widget.logoSize,
                width: widget.logoSize,
              ),
              widget.startInfo ?? const SizedBox.shrink(),
              DecoratedTextFormField(
                controller: widget.fieldController,
                keyboardType: widget.keyboardType,
                inputFormatters: widget.inputFormatters,
                labelText: widget.fieldLabel,
                decoration: widget.decoration,
                validator: widget.validator,
                onChanged: (value) => widget.onChanged?.call(value ?? ''),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.isSubmitting ? null : _submit,
                  child: Text(widget.buttonText),
                ),
              ),
              widget.bottomWidget ?? const SizedBox.shrink(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final onContinue = widget.onContinue;
    if (onContinue == null) {
      return;
    }
    await submitFormWithValidation(
      formController: _formController,
      onSubmit: () => onContinue(widget.fieldController.text.trim()),
      onInvalidForm: () => setState(() {}),
    );
  }
}
