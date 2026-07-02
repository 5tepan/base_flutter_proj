import 'dart:async';

import 'package:base_flutter_proj/core/components/search_autocomplete/hive_search_autocomplete_history_storage.dart';
import 'package:base_flutter_proj/core/components/search_autocomplete/search_autocomplete_history_storage.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Визуальные настройки выпадающего списка подсказок.
class SearchAutocompleteOptionsStyle {
  const SearchAutocompleteOptionsStyle({
    this.maxHeight = 280,
    this.elevation = 4,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.backgroundColor = AppColors.white,
    this.dividerColor = AppColors.divider,
    this.padding = EdgeInsets.zero,
    this.margin = const EdgeInsets.only(top: 4),
  });

  final double maxHeight;
  final double elevation;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color dividerColor;
  final EdgeInsets padding;
  final EdgeInsets margin;
}

/// Универсальное поле поиска с автокомплитом.
///
/// Выглядит как обычное поле ввода ([TextFormField]), поддерживает [prefix] /
/// [suffix], опциональную историю и настраиваемый список подсказок.
class SearchAutocompleteField<T extends Object> extends StatefulWidget {
  const SearchAutocompleteField({
    super.key,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.autocompleteEnabled = true,
    this.historyEnabled = false,
    this.maxSuggestions = 8,
    this.maxHistoryItems = 10,
    this.minQueryLength = 1,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.historyStorageKey = 'default',
    this.historyStorage,
    this.historyHeaderText,
    this.onSuggestionsRequested,
    this.displayStringForOption,
    this.historyTextForOption,
    this.historyEntryToSuggestion,
    this.suggestionBuilder,
    this.historyItemBuilder,
    this.optionsStyle = const SearchAutocompleteOptionsStyle(),
    this.decoration,
    this.hintText,
    this.labelText,
    this.prefix,
    this.suffix,
    this.suffixConstraints,
    this.showClearButton = false,
    this.autofocus = false,
    this.textInputAction,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onSuggestionSelected,
    this.loadingBuilder,
    this.emptyBuilder,
    this.optionsViewBuilder,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool enabled;
  final bool autocompleteEnabled;
  final bool historyEnabled;
  final int maxSuggestions;
  final int maxHistoryItems;
  final int minQueryLength;
  final Duration debounceDuration;
  final String historyStorageKey;
  final SearchAutocompleteHistoryStorage? historyStorage;
  final String? historyHeaderText;
  final FutureOr<List<T>> Function(String query)? onSuggestionsRequested;
  final String Function(T option)? displayStringForOption;
  final String Function(T option)? historyTextForOption;
  final T Function(String historyEntry)? historyEntryToSuggestion;
  final Widget Function(
    BuildContext context,
    T option,
    VoidCallback onTap,
  )? suggestionBuilder;
  final Widget Function(
    BuildContext context,
    String entry,
    VoidCallback onTap,
  )? historyItemBuilder;
  final SearchAutocompleteOptionsStyle optionsStyle;
  final InputDecoration? decoration;
  final String? hintText;
  final String? labelText;
  final Widget? prefix;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final bool showClearButton;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<T>? onSuggestionSelected;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? emptyBuilder;
  final Widget Function(
    BuildContext context,
    AutocompleteOnSelected<T> onSelected,
    Iterable<T> options, {
    required bool isLoading,
    required bool isHistory,
  })? optionsViewBuilder;

  @override
  State<SearchAutocompleteField<T>> createState() =>
      _SearchAutocompleteFieldState<T>();
}

class _SearchAutocompleteFieldState<T extends Object>
    extends State<SearchAutocompleteField<T>> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final SearchAutocompleteHistoryStorage _historyStorage;
  late final ValueNotifier<bool> _loadingNotifier;
  late final bool _ownsController;
  late final bool _ownsFocusNode;

  int _searchGeneration = 0;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = TextEditingController();
      _ownsController = true;
    }

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
      _ownsFocusNode = false;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }

    _historyStorage = widget.historyStorage ??
        (widget.historyEnabled
            ? HiveSearchAutocompleteHistoryStorage()
            : InMemorySearchAutocompleteHistoryStorage());
    _loadingNotifier = ValueNotifier(false);
    _showClear = widget.showClearButton && _controller.text.isNotEmpty;
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    _loadingNotifier.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    final shouldShowClear =
        widget.showClearButton && _controller.text.isNotEmpty;
    if (shouldShowClear != _showClear) {
      setState(() => _showClear = shouldShowClear);
    }
    widget.onChanged?.call(_controller.text);
  }

  String _displayFor(T option) {
    final displayStringForOption = widget.displayStringForOption;
    if (displayStringForOption != null) {
      return displayStringForOption(option);
    }
    if (option is String) {
      return option;
    }
    throw ArgumentError(
      'displayStringForOption is required when T is not String.',
    );
  }

  String _historyTextFor(T option) {
    return widget.historyTextForOption?.call(option) ?? _displayFor(option);
  }

  T _historyEntryToOption(String entry) {
    final historyEntryToSuggestion = widget.historyEntryToSuggestion;
    if (historyEntryToSuggestion != null) {
      return historyEntryToSuggestion(entry);
    }
    return entry as T;
  }

  Future<void> _saveHistory(String value) async {
    if (!widget.historyEnabled || value.trim().isEmpty) {
      return;
    }

    final trimmed = value.trim();
    final items = await _historyStorage.read(widget.historyStorageKey);
    final updated = [
      trimmed,
      ...items.where((item) => item != trimmed),
    ].take(widget.maxHistoryItems).toList(growable: false);

    await _historyStorage.write(widget.historyStorageKey, updated);
  }

  Future<List<T>> _loadHistoryOptions() async {
    if (!widget.historyEnabled) {
      return [];
    }

    final items = await _historyStorage.read(widget.historyStorageKey);
    return items
        .take(widget.maxHistoryItems)
        .map(_historyEntryToOption)
        .toList(growable: false);
  }

  Future<List<T>> _loadSuggestionOptions(String query) async {
    final onSuggestionsRequested = widget.onSuggestionsRequested;
    if (onSuggestionsRequested == null) {
      return [];
    }

    final generation = ++_searchGeneration;
    _loadingNotifier.value = true;

    try {
      if (widget.debounceDuration > Duration.zero) {
        await Future<void>.delayed(widget.debounceDuration);
      }
      if (generation != _searchGeneration) {
        return [];
      }

      final result = await onSuggestionsRequested(query);
      if (generation != _searchGeneration) {
        return [];
      }

      return result.take(widget.maxSuggestions).toList(growable: false);
    } finally {
      if (generation == _searchGeneration) {
        _loadingNotifier.value = false;
      }
    }
  }

  FutureOr<Iterable<T>> _optionsBuilder(TextEditingValue value) async {
    if (!widget.autocompleteEnabled || !widget.enabled) {
      return const [];
    }

    final query = value.text.trim();

    if (query.isEmpty) {
      return _loadHistoryOptions();
    }

    if (query.length < widget.minQueryLength) {
      return const [];
    }

    return _loadSuggestionOptions(query);
  }

  Future<void> _handleSelected(T option) async {
    final text = _displayFor(option);
    _controller
      ..text = text
      ..selection = TextSelection.collapsed(offset: text.length);
    widget.onSuggestionSelected?.call(option);
    await _saveHistory(_historyTextFor(option));
    setState(() => _showClear = widget.showClearButton && text.isNotEmpty);
  }

  Future<void> _handleSubmitted(String value) async {
    await _saveHistory(value);
    widget.onSubmitted?.call(value);
  }

  void _clearField() {
    _controller.clear();
    setState(() => _showClear = false);
    widget.onChanged?.call('');
  }

  InputDecoration _buildDecoration() {
    final baseDecoration = widget.decoration ?? const InputDecoration();

    return baseDecoration.copyWith(
      hintText: widget.hintText ?? baseDecoration.hintText,
      labelText: widget.labelText ?? baseDecoration.labelText,
      prefixIcon: widget.prefix ?? baseDecoration.prefixIcon,
      suffixIcon: _buildSuffix() ?? baseDecoration.suffixIcon,
      suffixIconConstraints:
          widget.suffixConstraints ?? baseDecoration.suffixIconConstraints,
    );
  }

  Widget? _buildSuffix() {
    final suffixWidgets = <Widget>[];

    if (_showClear) {
      suffixWidgets.add(
        IconButton(
          tooltip: MaterialLocalizations.of(context).clearButtonTooltip,
          onPressed: widget.enabled ? _clearField : null,
          icon: const Icon(Icons.clear, size: 20),
        ),
      );
    }

    final suffix = widget.suffix;
    if (suffix != null) {
      suffixWidgets.add(suffix);
    }

    if (suffixWidgets.isEmpty) {
      return null;
    }
    if (suffixWidgets.length == 1) {
      return suffixWidgets.first;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: suffixWidgets,
    );
  }

  Widget _defaultSuggestionTile(
    BuildContext context,
    String title, {
    IconData? leadingIcon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: leadingIcon == null ? null : Icon(leadingIcon, size: 20),
      title: Text(title, style: AppTextStyle.body),
      onTap: onTap,
    );
  }

  Widget _buildOptionTile(
    BuildContext context,
    T option,
    AutocompleteOnSelected<T> onSelected, {
    required bool isHistory,
  }) {
    if (isHistory) {
      final entry = _historyTextFor(option);
      final historyItemBuilder = widget.historyItemBuilder;
      if (historyItemBuilder != null) {
        return historyItemBuilder(
          context,
          entry,
          () => onSelected(option),
        );
      }
      return _defaultSuggestionTile(
        context,
        entry,
        leadingIcon: Icons.history,
        onTap: () => onSelected(option),
      );
    }

    final suggestionBuilder = widget.suggestionBuilder;
    if (suggestionBuilder != null) {
      return suggestionBuilder(
        context,
        option,
        () => onSelected(option),
      );
    }

    return _defaultSuggestionTile(
      context,
      _displayFor(option),
      leadingIcon: Icons.search,
      onTap: () => onSelected(option),
    );
  }

  Widget _buildOptionsView(
    BuildContext context,
    AutocompleteOnSelected<T> onSelected,
    Iterable<T> options, {
    required bool isHistory,
  }) {
    final customBuilder = widget.optionsViewBuilder;
    if (customBuilder != null) {
      return customBuilder(
        context,
        onSelected,
        options,
        isLoading: _loadingNotifier.value,
        isHistory: isHistory,
      );
    }

    final style = widget.optionsStyle;
    final optionsList = options.toList(growable: false);

    return Padding(
      padding: style.margin,
      child: Material(
        elevation: style.elevation,
        color: style.backgroundColor,
        borderRadius: style.borderRadius,
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: style.maxHeight),
          child: ValueListenableBuilder<bool>(
            valueListenable: _loadingNotifier,
            builder: (context, isLoading, _) {
              if (isLoading && optionsList.isEmpty) {
                return widget.loadingBuilder?.call(context) ??
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
              }

              if (optionsList.isEmpty) {
                return widget.emptyBuilder?.call(context) ??
                    const SizedBox.shrink();
              }

              return ListView(
                padding: style.padding,
                shrinkWrap: true,
                children: [
                  if (isHistory && widget.historyHeaderText != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Text(
                        widget.historyHeaderText!,
                        style: AppTextStyle.body.copyWith(
                          color: AppColors.grey90,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  for (var index = 0; index < optionsList.length; index++) ...[
                    if (index > 0)
                      Divider(height: 1, color: style.dividerColor),
                    _buildOptionTile(
                      context,
                      optionsList[index],
                      onSelected,
                      isHistory: isHistory,
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim();
    final isHistoryPanel = widget.historyEnabled && query.isEmpty;

    return RawAutocomplete<T>(
      textEditingController: _controller,
      focusNode: _focusNode,
      displayStringForOption: _displayFor,
      optionsBuilder: _optionsBuilder,
      onSelected: _handleSelected,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          textInputAction: widget.textInputAction ?? TextInputAction.search,
          inputFormatters: widget.inputFormatters,
          validator: widget.validator,
          decoration: _buildDecoration(),
          onFieldSubmitted: (value) {
            onFieldSubmitted();
            unawaited(_handleSubmitted(value));
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: _buildOptionsView(
            context,
            onSelected,
            options,
            isHistory: isHistoryPanel,
          ),
        );
      },
    );
  }
}
