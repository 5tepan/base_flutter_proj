import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// размер виджета
const double _kEdgeSize = 24.0;
// размер галки
const double _kStrokeWidth = 1.5;
// Уменьшение размера галки (по умолчанию 1)
const double _checkScale = 17 / _kEdgeSize;

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({
    required this.value,
    required this.onChanged,
    this.tapPadding = EdgeInsets.zero,
    super.key,
    this.tristate = false,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
    this.isError = false,
    this.semanticLabel,
  }) : assert(tristate || value != null);

  final bool? value;
  final EdgeInsets tapPadding;
  final ValueChanged<bool?>? onChanged;
  final MouseCursor? mouseCursor;
  final Color? activeColor;
  final WidgetStateProperty<Color?>? fillColor;
  final Color? checkColor;
  final bool tristate;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final Color? focusColor;
  final Color? hoverColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final FocusNode? focusNode;
  final bool autofocus;
  final OutlinedBorder? shape;
  final BorderSide? side;
  final bool isError;
  final String? semanticLabel;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox>
    with TickerProviderStateMixin, ToggleableStateMixin {
  final _CheckboxPainter _painter = _CheckboxPainter();
  bool? _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
  }

  @override
  void didUpdateWidget(CustomCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      animateToValue();
    }
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  ValueChanged<bool?>? get onChanged => widget.onChanged;

  @override
  bool get tristate => widget.tristate;

  @override
  bool? get value => widget.value;

  @override
  Duration? get reactionAnimationDuration => kRadialReactionDuration;

  WidgetStateProperty<Color?> get _widgetFillColor {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return widget.activeColor;
      }
      return null;
    });
  }

  BorderSide? _resolveSide(BorderSide? side, Set<WidgetState> states) {
    if (side is WidgetStateBorderSide) {
      return WidgetStateProperty.resolveAs<BorderSide?>(side, states);
    }
    if (!states.contains(WidgetState.selected)) {
      return side;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final checkboxTheme = CheckboxTheme.of(context);
    final CheckboxThemeData defaults = _CheckboxDefaultsM3(context);
    const effectiveVisualDensity = VisualDensity.standard;
    var size = const Size(_kEdgeSize, _kEdgeSize);
    size += effectiveVisualDensity.baseSizeAdjustment;

    final effectiveMouseCursor = WidgetStateProperty.resolveWith<MouseCursor>((
      Set<WidgetState> states,
    ) {
      return WidgetStateProperty.resolveAs<MouseCursor?>(
            widget.mouseCursor,
            states,
          ) ??
          checkboxTheme.mouseCursor?.resolve(states) ??
          WidgetStateMouseCursor.clickable.resolve(states);
    });

    // Colors need to be resolved in selected and non selected states separately
    final activeStates = states..add(WidgetState.selected);
    final inactiveStates = states..remove(WidgetState.selected);
    if (widget.isError) {
      activeStates.add(WidgetState.error);
      inactiveStates.add(WidgetState.error);
    }
    final activeColor =
        widget.fillColor?.resolve(activeStates) ??
        _widgetFillColor.resolve(activeStates) ??
        checkboxTheme.fillColor?.resolve(activeStates);
    final effectiveActiveColor =
        activeColor ?? defaults.fillColor!.resolve(activeStates)!;
    final inactiveColor =
        widget.fillColor?.resolve(inactiveStates) ??
        _widgetFillColor.resolve(inactiveStates) ??
        checkboxTheme.fillColor?.resolve(inactiveStates);
    final effectiveInactiveColor =
        inactiveColor ?? defaults.fillColor!.resolve(inactiveStates)!;

    final activeSide =
        _resolveSide(widget.side, activeStates) ??
        _resolveSide(checkboxTheme.side, activeStates) ??
        _resolveSide(defaults.side, activeStates)!;
    final inactiveSide =
        _resolveSide(widget.side, inactiveStates) ??
        _resolveSide(checkboxTheme.side, inactiveStates) ??
        _resolveSide(defaults.side, inactiveStates)!;

    final focusedStates = states..add(WidgetState.focused);
    if (widget.isError) {
      focusedStates.add(WidgetState.error);
    }
    var effectiveFocusOverlayColor =
        widget.overlayColor?.resolve(focusedStates) ??
        widget.focusColor ??
        checkboxTheme.overlayColor?.resolve(focusedStates) ??
        defaults.overlayColor!.resolve(focusedStates)!;

    final hoveredStates = states..add(WidgetState.hovered);
    if (widget.isError) {
      hoveredStates.add(WidgetState.error);
    }
    var effectiveHoverOverlayColor =
        widget.overlayColor?.resolve(hoveredStates) ??
        widget.hoverColor ??
        checkboxTheme.overlayColor?.resolve(hoveredStates) ??
        defaults.overlayColor!.resolve(hoveredStates)!;

    final activePressedStates = activeStates..add(WidgetState.pressed);
    final effectiveActivePressedOverlayColor =
        widget.overlayColor?.resolve(activePressedStates) ??
        checkboxTheme.overlayColor?.resolve(activePressedStates) ??
        activeColor?.withAlpha(kRadialReactionAlpha) ??
        defaults.overlayColor!.resolve(activePressedStates)!;

    final inactivePressedStates = inactiveStates..add(WidgetState.pressed);
    final effectiveInactivePressedOverlayColor =
        widget.overlayColor?.resolve(inactivePressedStates) ??
        checkboxTheme.overlayColor?.resolve(inactivePressedStates) ??
        inactiveColor?.withAlpha(kRadialReactionAlpha) ??
        defaults.overlayColor!.resolve(inactivePressedStates)!;
    if (downPosition != null) {
      effectiveHoverOverlayColor = states.contains(WidgetState.selected)
          ? effectiveActivePressedOverlayColor
          : effectiveInactivePressedOverlayColor;
      effectiveFocusOverlayColor = states.contains(WidgetState.selected)
          ? effectiveActivePressedOverlayColor
          : effectiveInactivePressedOverlayColor;
    }

    final checkStates = widget.isError
        ? (states..add(WidgetState.error))
        : states;
    final effectiveCheckColor =
        widget.checkColor ??
        checkboxTheme.checkColor?.resolve(checkStates) ??
        defaults.checkColor!.resolve(checkStates)!;

    final effectiveSplashRadius =
        widget.splashRadius ??
        checkboxTheme.splashRadius ??
        defaults.splashRadius!;

    return Semantics(
      label: widget.semanticLabel,
      checked: widget.value ?? false,
      mixed: widget.tristate ? widget.value == null : null,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _handleTap,
        child: Padding(
          padding: widget.tapPadding,
          child: buildToggleable(
            mouseCursor: effectiveMouseCursor,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            size: size,
            painter: _painter
              ..position = position
              ..reaction = reaction
              ..reactionFocusFade = reactionFocusFade
              ..reactionHoverFade = reactionHoverFade
              ..inactiveReactionColor = effectiveInactivePressedOverlayColor
              ..reactionColor = effectiveActivePressedOverlayColor
              ..hoverColor = effectiveHoverOverlayColor
              ..focusColor = effectiveFocusOverlayColor
              ..splashRadius = effectiveSplashRadius
              ..downPosition = downPosition
              ..isFocused = states.contains(WidgetState.focused)
              ..isHovered = states.contains(WidgetState.hovered)
              ..activeColor = effectiveActiveColor
              ..inactiveColor = effectiveInactiveColor
              ..checkColor = effectiveCheckColor
              ..value = value
              ..previousValue = _previousValue
              ..shape = widget.shape ?? checkboxTheme.shape ?? defaults.shape!
              ..activeSide = activeSide
              ..inactiveSide = inactiveSide,
          ),
        ),
      ),
    );
  }

  void _handleTap([Intent? _]) {
    if (!isInteractive) {
      return;
    }
    switch (value) {
      case false:
        onChanged!(true);
      case true:
        onChanged!(tristate ? null : false);
      case null:
        onChanged!(false);
    }
    context.findRenderObject()!.sendSemanticsEvent(const TapSemanticEvent());
  }
}

class _CheckboxPainter extends ToggleablePainter {
  Color get checkColor => _checkColor!;
  Color? _checkColor;

  set checkColor(Color value) {
    if (_checkColor == value) {
      return;
    }
    _checkColor = value;
    notifyListeners();
  }

  bool? get value => _value;
  bool? _value;

  set value(bool? value) {
    if (_value == value) {
      return;
    }
    _value = value;
    notifyListeners();
  }

  bool? get previousValue => _previousValue;
  bool? _previousValue;

  set previousValue(bool? value) {
    if (_previousValue == value) {
      return;
    }
    _previousValue = value;
    notifyListeners();
  }

  OutlinedBorder get shape => _shape!;
  OutlinedBorder? _shape;

  set shape(OutlinedBorder value) {
    if (_shape == value) {
      return;
    }
    _shape = value;
    notifyListeners();
  }

  BorderSide get activeSide => _activeSide!;
  BorderSide? _activeSide;

  set activeSide(BorderSide value) {
    if (_activeSide == value) {
      return;
    }
    _activeSide = value;
    notifyListeners();
  }

  BorderSide get inactiveSide => _inactiveSide!;
  BorderSide? _inactiveSide;

  set inactiveSide(BorderSide value) {
    if (_inactiveSide == value) {
      return;
    }
    _inactiveSide = value;
    notifyListeners();
  }

  Rect _outerRectAt(Offset origin, double t) {
    final inset = 1.0 - (t - 0.5).abs() * 2.0;
    final size = _kEdgeSize - inset * _kStrokeWidth;
    final rect = Rect.fromLTWH(
      origin.dx + inset,
      origin.dy + inset,
      size,
      size,
    );
    return rect;
  }

  Color _colorAt(double t) {
    return t >= 0.25
        ? activeColor
        : Color.lerp(inactiveColor, activeColor, t * 4.0)!;
  }

  Paint _createStrokePaint() {
    return Paint()..color = checkColor;
  }

  void _drawBox(Canvas canvas, Rect outer, Paint paint, BorderSide? side) {
    canvas.drawPath(shape.getOuterPath(outer), paint);
    if (side != null) {
      shape.copyWith(side: side).paint(canvas, outer);
    }
  }

  void _drawCheck(Canvas canvas, Offset origin, double t, Paint basePaint) {
    final paint = Paint()
      ..color = basePaint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _kStrokeWidth
      ..strokeCap = StrokeCap.round;

    const scale = _checkScale;
    const start = Offset(_kEdgeSize * 0.15 * scale, _kEdgeSize * 0.45 * scale);
    const mid = Offset(_kEdgeSize * 0.4 * scale, _kEdgeSize * 0.7 * scale);
    const end = Offset(_kEdgeSize * 0.85 * scale, _kEdgeSize * 0.25 * scale);

    final s = origin + start;
    final m = origin + mid;
    final e = origin + end;

    if (t < 0.5) {
      final strokeT = t * 2.0;
      final currentMid = Offset.lerp(s, m, strokeT)!;
      canvas.drawLine(s, currentMid, paint);
    } else {
      final strokeT = (t - 0.5) * 2.0;
      final currentEnd = Offset.lerp(m, e, strokeT)!;
      canvas.drawLine(s, m, paint);
      canvas.drawLine(m, currentEnd, paint);
    }
  }

  void _drawDash(Canvas canvas, Offset origin, double t, Paint paint) {
    assert(t >= 0.0 && t <= 1.0);
    const start = Offset(_kEdgeSize * 0.2, _kEdgeSize * 0.5);
    const mid = Offset(_kEdgeSize * 0.5, _kEdgeSize * 0.5);
    const end = Offset(_kEdgeSize * 0.8, _kEdgeSize * 0.5);
    final drawStart = Offset.lerp(start, mid, 1.0 - t)!;
    final drawEnd = Offset.lerp(mid, end, t)!;
    canvas.drawLine(origin + drawStart, origin + drawEnd, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintRadialReaction(canvas: canvas, origin: size.center(Offset.zero));

    final strokePaint = _createStrokePaint();

    const checkScale = _checkScale;
    const scaledEdgeSize = _kEdgeSize * checkScale;
    final origin =
        size.center(Offset.zero) -
        const Offset(scaledEdgeSize / 2, scaledEdgeSize / 2);

    final tNormalized = switch (position.status) {
      AnimationStatus.forward || AnimationStatus.completed => position.value,
      AnimationStatus.reverse ||
      AnimationStatus.dismissed => 1.0 - position.value,
    };

    if (previousValue == false || value == false) {
      final t = value == false ? 1.0 - tNormalized : tNormalized;
      final outer = _outerRectAt(
        size.center(Offset.zero) - const Offset(_kEdgeSize / 2, _kEdgeSize / 2),
        t,
      );
      final paint = Paint()..color = _colorAt(t);

      if (t <= 0.5) {
        final border = BorderSide.lerp(inactiveSide, activeSide, t);
        _drawBox(canvas, outer, paint, border);
      } else {
        _drawBox(canvas, outer, paint, activeSide);
        final tShrink = (t - 0.5) * 2.0;
        if (previousValue == null || value == null) {
          _drawDash(canvas, origin, tShrink, strokePaint);
        } else {
          _drawCheck(canvas, origin, tShrink, strokePaint);
        }
      }
    } else {
      final outer = _outerRectAt(
        size.center(Offset.zero) - const Offset(_kEdgeSize / 2, _kEdgeSize / 2),
        1.0,
      );
      final paint = Paint()..color = _colorAt(1.0);

      _drawBox(canvas, outer, paint, activeSide);

      if (tNormalized <= 0.5) {
        final tShrink = 1.0 - tNormalized * 2.0;
        if (previousValue ?? false) {
          _drawCheck(canvas, origin, tShrink, strokePaint);
        } else {
          _drawDash(canvas, origin, tShrink, strokePaint);
        }
      } else {
        final tExpand = (tNormalized - 0.5) * 2.0;
        if (value ?? false) {
          _drawCheck(canvas, origin, tExpand, strokePaint);
        } else {
          _drawDash(canvas, origin, tExpand, strokePaint);
        }
      }
    }
  }
}

class _CheckboxDefaultsM3 extends CheckboxThemeData {
  _CheckboxDefaultsM3(BuildContext context)
    : _theme = Theme.of(context),
      _colors = Theme.of(context).colorScheme;

  final ThemeData _theme;
  final ColorScheme _colors;

  @override
  WidgetStateBorderSide? get side {
    return WidgetStateBorderSide.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        if (states.contains(WidgetState.selected)) {
          return const BorderSide(width: 2.0, color: Colors.transparent);
        }
        return BorderSide(
          width: 2.0,
          color: _colors.onSurface.withValues(alpha: 0.38),
        );
      }
      if (states.contains(WidgetState.selected)) {
        return const BorderSide(width: 0.0, color: Colors.transparent);
      }
      if (states.contains(WidgetState.error)) {
        return BorderSide(width: 2.0, color: _colors.error);
      }
      if (states.contains(WidgetState.pressed)) {
        return BorderSide(width: 2.0, color: _colors.onSurface);
      }
      if (states.contains(WidgetState.hovered)) {
        return BorderSide(width: 2.0, color: _colors.onSurface);
      }
      if (states.contains(WidgetState.focused)) {
        return BorderSide(width: 2.0, color: _colors.onSurface);
      }
      return BorderSide(width: 2.0, color: _colors.onSurfaceVariant);
    });
  }

  @override
  WidgetStateProperty<Color> get fillColor {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        if (states.contains(WidgetState.selected)) {
          return _colors.onSurface.withValues(alpha: 0.38);
        }
        return Colors.transparent;
      }
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.error)) {
          return _colors.error;
        }
        return _colors.primary;
      }
      return Colors.transparent;
    });
  }

  @override
  WidgetStateProperty<Color> get checkColor {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        if (states.contains(WidgetState.selected)) {
          return _colors.surface;
        }
        return Colors.transparent;
      }
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.error)) {
          return _colors.onError;
        }
        return _colors.onPrimary;
      }
      return Colors.transparent;
    });
  }

  @override
  WidgetStateProperty<Color> get overlayColor {
    return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.error)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.error.withValues(alpha: 0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.error.withValues(alpha: 0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.error.withValues(alpha: 0.1);
        }
      }
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.onSurface.withValues(alpha: 0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.primary.withValues(alpha: 0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.primary.withValues(alpha: 0.1);
        }
        return Colors.transparent;
      }
      if (states.contains(WidgetState.pressed)) {
        return _colors.primary.withValues(alpha: 0.1);
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onSurface.withValues(alpha: 0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onSurface.withValues(alpha: 0.1);
      }
      return Colors.transparent;
    });
  }

  @override
  double get splashRadius => 40.0 / 2;

  @override
  MaterialTapTargetSize get materialTapTargetSize =>
      _theme.materialTapTargetSize;

  @override
  VisualDensity get visualDensity => _theme.visualDensity;

  @override
  OutlinedBorder get shape => const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  );
}
