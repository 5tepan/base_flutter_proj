import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DecoratedTextFormField extends FormField<String?> {
  final GlobalKey<FormFieldState>? formFieldKey;
  final String? labelText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration decoration;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final bool showCursor;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final int maxLines;
  final int minLines;
  final bool expands;
  final int? maxLength;
  final ValueChanged<String?>? onChanged;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  final double cursorWidth;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final InputCounterWidgetBuilder? buildCounter;
  final Widget? suffix;
  final Widget? prefix;
  final Iterable<String>? autofillHints;
  final MaxLengthEnforcement maxLengthEnforcement;
  final BoxConstraints? suffixConstraints;
  @Deprecated('Use suffixConstraints instead.')
  final BoxConstraints? suffixConstrains;

  DecoratedTextFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    this.formFieldKey,
    this.labelText,
    this.controller,
    this.focusNode,
    this.suffix,
    this.suffixConstraints,
    this.suffixConstrains,
    this.prefix,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
    this.showCursor = true,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.enabled = true,
    this.maxLines = 1,
    this.minLines = 1,
    this.expands = false,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.cursorWidth = 1.0,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.buildCounter,
    this.autofillHints,
    this.maxLengthEnforcement = MaxLengthEnforcement.enforced,
  }) : assert(
         controller == null || initialValue == null,
         'controller and initialValue cannot be used together.',
       ),
       super(
         builder: (FormFieldState<String?> fieldState) {
           final state = fieldState as _DecoratedTextFormFieldState;
           return state.buildBody();
         },
       );

  static Widget _defaultContextMenuBuilder(
    BuildContext context,
    EditableTextState editableTextState,
  ) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  @override
  _DecoratedTextFormFieldState createState() => _DecoratedTextFormFieldState();
}

class _DecoratedTextFormFieldState extends FormFieldState<String?> {
  @override
  DecoratedTextFormField get widget => super.widget as DecoratedTextFormField;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onChange);

    final controllerText = widget.controller?.text;
    if (controllerText != null && controllerText != value) {
      setValue(controllerText);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onChange);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DecoratedTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onChange);
      widget.controller?.addListener(_onChange);
      didChange(widget.controller?.text ?? widget.initialValue);
    }
  }

  Widget buildBody() {
    return buildTextField();
  }

  Widget buildTextField() {
    final baseStyle =
        widget.style ??
        const TextStyle().copyWith(
          fontSize: 14,
          height: 1,
          fontWeight: FontWeight.w400,
        );

    final effectiveSuffixConstraints =
        widget.suffixConstraints ?? widget.suffixConstrains;

    return Column(
      spacing: 3,
      children: [
        TextFormField(
          key: widget.formFieldKey,
          focusNode: widget.focusNode,
          controller: widget.controller,
          decoration: widget.decoration.copyWith(
            labelText: widget.labelText,
            errorText: hasError ? '' : null,
            errorStyle: const TextStyle(fontSize: 0, height: 0),
            prefixIcon: widget.prefix,
            suffixIcon: widget.suffix,
            suffixIconConstraints: effectiveSuffixConstraints,
          ),
          initialValue: widget.initialValue,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          textInputAction: widget.textInputAction,
          style: baseStyle.copyWith(
            color: hasError ? Theme.of(context).colorScheme.error : baseStyle.color,
          ),
          strutStyle: widget.strutStyle,
          textDirection: widget.textDirection,
          textAlign: widget.textAlign,
          textAlignVertical: widget.textAlignVertical,
          autofocus: widget.autofocus,
          readOnly: widget.readOnly,
          autofillHints: widget.autofillHints,
          contextMenuBuilder: widget.contextMenuBuilder,
          showCursor: widget.showCursor,
          obscureText: widget.obscureText,
          autocorrect: widget.autocorrect,
          enableSuggestions: widget.enableSuggestions,
          maxLengthEnforcement: widget.maxLengthEnforcement,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          expands: widget.expands,
          maxLength: widget.maxLength,
          onChanged: widget.controller == null
              ? (value) {
                  didChange(value);
                  widget.onChanged?.call(value);
                }
              : null,
          onTap: widget.onTap,
          onEditingComplete: widget.onEditingComplete,
          onFieldSubmitted: widget.onFieldSubmitted,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          cursorWidth: widget.cursorWidth,
          cursorRadius: widget.cursorRadius,
          cursorColor: widget.cursorColor,
          keyboardAppearance: widget.keyboardAppearance,
          scrollPadding: widget.scrollPadding,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          buildCounter: widget.buildCounter,
        ),
        if (hasError) Row(children: [errorBuilder(context, errorText ?? '')]),
      ],
    );
  }

  Widget errorBuilder(BuildContext context, String errorText) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Text(
        errorText,
        style: Theme.of(context).inputDecorationTheme.errorStyle,
      ),
    );
  }

  void _onChange() {
    didChange(widget.controller?.text);
    widget.onChanged?.call(widget.controller?.text);
    if (widget.autovalidateMode == AutovalidateMode.always) {
      validate();
    }
  }
}
