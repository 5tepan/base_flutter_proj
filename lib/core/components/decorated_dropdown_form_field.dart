import 'package:flutter/material.dart';

class DecoratedDropdownItem<T> {
  const DecoratedDropdownItem({required this.value, required this.label});

  final T value;
  final String label;
}

class DecoratedDropdownFormField<T> extends FormField<T> {
  DecoratedDropdownFormField({
    super.key,
    required List<DecoratedDropdownItem<T>> items,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.enabled = true,
    this.labelText,
    this.decoration = const InputDecoration(),
    this.hintText,
    this.onChanged,
    this.isExpanded = true,
    this.icon,
    this.menuMaxHeight,
    this.alignment = AlignmentDirectional.centerStart,
  }) : _items = items,
       super(
         builder: (fieldState) {
           final state = fieldState as _DecoratedDropdownFormFieldState<T>;
           return state.buildBody();
         },
       );

  final List<DecoratedDropdownItem<T>> _items;
  final String? labelText;
  final InputDecoration decoration;
  final String? hintText;
  final ValueChanged<T?>? onChanged;
  final bool isExpanded;
  final Widget? icon;
  final double? menuMaxHeight;
  final AlignmentGeometry alignment;

  List<DecoratedDropdownItem<T>> get items => _items;

  @override
  FormFieldState<T> createState() => _DecoratedDropdownFormFieldState<T>();
}

class _DecoratedDropdownFormFieldState<T> extends FormFieldState<T> {
  @override
  DecoratedDropdownFormField<T> get widget =>
      super.widget as DecoratedDropdownFormField<T>;

  Widget buildBody() {
    final effectiveDecoration = widget.decoration.copyWith(
      labelText: widget.labelText,
      hintText: widget.hintText,
      errorText: hasError ? '' : null,
      errorStyle: const TextStyle(fontSize: 0, height: 0),
    );

    return Column(
      spacing: 3,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<T>(
          initialValue: value,
          decoration: effectiveDecoration,
          items: widget.items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item.value,
                  child: Text(item.label),
                ),
              )
              .toList(),
          onChanged: widget.enabled
              ? (newValue) {
                  didChange(newValue);
                  widget.onChanged?.call(newValue);
                }
              : null,
          isExpanded: widget.isExpanded,
          icon: widget.icon,
          menuMaxHeight: widget.menuMaxHeight,
          alignment: widget.alignment,
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
}
