import 'package:base_flutter_proj/core/helpers/assets_catalog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract final class AppColors {
  /// Базовые цвета
  static const Color black = Color(0xFF000000);
  static const Color lightBlack = Color(0xFF121B35);
  static const Color white = Color(0xFFFFFFFF);
  static const Color green = Color(0xFF46C201);
  static const Color red = Color(0xFFDC4E2F);
  static const Color orange = Colors.orange;
  static const Color yellow = Colors.yellow;
  static const Color lightGrey = Color.fromRGBO(238, 238, 238, 1);
  static const Color grey = Colors.grey;

  static const Color grey90 = Color(0xFF7B7B7B);
  static const Color midGrey = Color(0xFFC4C4C4);
  static const Color darkGrey = Color(0xFF586077);
  static const Color blue = Colors.blue;
  static const Color lightBlue = Colors.lightBlue;

  static const Color black2 = Color(0xFF1D1D1D);

  /// Основной цвет, который чаще всего отображается на экранах и компонентах
  /// приложения.
  static const Color primaryColor = blue;

  static const Color primaryLight = Color(0xFFDCE8FF);

  /// Цвет, который используется для контраста основного цвета (например в
  /// Notification(System) bar'е).
  static const Color primaryVariantColor = Color(0xFF2167F3);

  /// Вторичный цвет для FAB'ов, селекторов, слайдеров, переключателей,
  /// подсветки выделенного текста, прогрессбаров, ссылок и заголовков.
  static const Color secondaryColor = Color(0xFF4656B3);

  /// Цвет, который используется для контраста вторичного цвета (например
  /// текст внутри кнопки)
  static const Color secondaryVariantColor = Color(0xFF3846A2);

  /// Цвет фона отображается за скролящимся содержимым.
  static const Color backgroundColor = white;

  /// Цвет поверхности используется на карточках, bottomSheet и меню.
  static const Color surfaceColor = white;

  /// Цвет ошибки указывает на ошибки в компонентах, например недопустимый
  /// текст в текстовом поле.
  static const Color errorColor = red;

  /// Цвет [Scaffold] background.
  static const Color scaffoldBackgroundColor = white;

  /// The background color of [Dialog] elements.
  static const Color dialogBackground = white;

  /// Background theme color for the [AppBar].
  static const Color appBarBackground = primaryColor;

  /// Background theme color for the [ProgressIndicator],
  /// [CircularProgressIndicator], [RefreshIndicator], [CupertinoActivityIndicator].
  static const Color updatingIndicatorColor = primaryColor;

  /// Цвета «on*» в основном применяются к тексту, значкам и штрихам.
  /// Иногда их наносят на поверхности.
  /// Такие цвета используются для того, чтобы элементы, использующие их, были
  /// четкими и разборчивыми по сравнению с цветами за ними.
  static const Color onPrimaryColor = white;
  static const Color onSecondaryColor = black;
  static const Color onBackgroundColor = black;
  static const Color onSurfaceColor = black;
  static const Color onErrorColor = white;

  /// Цвета для элементов
  static const Color defaultText = darkGrey;
  static const Color divider = Color(0xFFCED2DC);
  static const Color border = Color.fromRGBO(203, 215, 222, 1.0);
  static const Color disabledBorder = Color(0xFFB9BECB);
  static const Color hint = Color(0xB58C95E6);
  static const Color pinKeyboardColor = Color(0xFF03A8B4);
  static const Color pinKeyboardPressedColor = Color(0xFF0B485A);
  static const Color pinCodeFieldColor = Color(0xFFC4C4C4);
  static const Color pinCodeFieldFilledColor = Color(0xFF0B485A);

  static const Color iosAlertButtonTextColor = Color(0xFF007AFF);
}

abstract final class AppTextStyle {
  static const TextStyle title = TextStyle(
    fontSize: 17,
    color: AppColors.onSecondaryColor,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.onSecondaryColor,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 15,
    color: AppColors.onSecondaryColor,
  );
  static const TextStyle body2 = TextStyle(
    fontSize: 16,
    color: AppColors.onSecondaryColor,
  );
  static const TextStyle body3 = TextStyle(
    fontSize: 17,
    color: AppColors.onSecondaryColor,
  );

  static TextStyle h2 = const TextStyle(
    fontSize: 21,
    color: AppColors.onSecondaryColor,
  );

  static TextStyle hyperLink = const TextStyle(
    fontSize: 15,
    decoration: TextDecoration.underline,
    color: AppColors.secondaryColor,
  );

  static TextStyle small = const TextStyle(
    fontSize: 13,
    color: AppColors.onSecondaryColor,
  );

  static TextStyle small2 = const TextStyle(
    fontSize: 11,
    color: AppColors.onSecondaryColor,
  );
}

/// Класс для формирования "визуальной темы" приложения
/// - внешний вид текстов
/// - внешний вид кнопок
/// - внешний вид полей ввода
/// - и т.д.
/// Позволяет в одном месте задать внешний вид бОльшей части стандарных
/// компонентов Flutter, и потом не дублировать код для их визуальной настройки.
class ThemeBuilder {
  static const double cardBorderRadius = 12.0;
  static const double defaultPadding = 12.0;
  static const double defaultSmallPadding = 6.0;

  static SystemUiOverlayStyle get systemUiOverlayStyle =>
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      );

  ThemeData buildThemeData() {
    final textTheme = _buildTextTheme();
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
      primaryColor: AppColors.primaryColor,
      textSelectionTheme: _buildTextSelectionThemeData(),
      appBarTheme: _buildAppBarTheme(),
      textTheme: textTheme,
      popupMenuTheme: _buildPopupMenuTheme(),
      elevatedButtonTheme: _buildElevatedButtonThemeData(),
      textButtonTheme: _buildTextButtonThemeData(),
      checkboxTheme: _buildCheckBoxThemeData(),
      inputDecorationTheme: _buildInputDecorationTheme(textTheme),
      pageTransitionsTheme: _buildPageTransitionsTheme(),
      floatingActionButtonTheme: _buildFloatingActionButtonThemeData(),
      tabBarTheme: _buildTabBarTheme(textTheme),
      dividerTheme: _buildDividerThemeData(),
      dialogTheme: _buildDialogThemeData(),
      switchTheme: _buildSwitchThemeData(),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        surfaceTint: AppColors.surfaceColor,
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        brightness: Brightness.light,
        error: AppColors.errorColor,
        onError: AppColors.onErrorColor,
        surface: AppColors.surfaceColor,
        onPrimary: AppColors.onPrimaryColor,
        onSecondary: AppColors.onSecondaryColor,
        onSurface: AppColors.onSurfaceColor,
        primaryContainer: AppColors.primaryVariantColor,
        secondaryContainer: AppColors.secondaryVariantColor,
      ),
    );
  }

  TextTheme _buildTextTheme() {
    const textColor = AppColors.defaultText;
    return const TextTheme(
      //Don't rewrite caption, overline, subtitle1, subtitle2 styles
      displayLarge: TextStyle(fontSize: 45, color: textColor),
      displayMedium: TextStyle(fontSize: 40, color: textColor),
      displaySmall: TextStyle(fontSize: 33, color: textColor),
      headlineMedium: TextStyle(fontSize: 22, color: textColor),
      headlineSmall: TextStyle(fontSize: 18, color: textColor),
      //Use headline6 only for customizing AppBar title
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      labelLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
    );
  }

  TextSelectionThemeData _buildTextSelectionThemeData() {
    return TextSelectionThemeData(
      cursorColor: AppColors.secondaryColor,
      selectionHandleColor: AppColors.secondaryColor.withValues(alpha: 0.7),
    );
  }

  AppBarTheme _buildAppBarTheme() {
    return const AppBarTheme(
      backgroundColor: AppColors.appBarBackground,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    );
  }

  DividerThemeData _buildDividerThemeData() {
    return const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    );
  }

  CheckboxThemeData _buildCheckBoxThemeData() {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.all(AppColors.primaryColor),
      side: const BorderSide(width: 2, color: AppColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  ElevatedButtonThemeData _buildElevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(const EdgeInsets.all(2)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        minimumSize: WidgetStateProperty.all(const Size.fromHeight(48)),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.primaryColor;
          }
          if (states.contains(WidgetState.disabled)) {
            return AppColors.lightBlue;
          }
          return AppColors.primaryColor;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.onPrimaryColor;
          }
          if (states.contains(WidgetState.disabled)) {
            return AppColors.onPrimaryColor;
          }
          return AppColors.onPrimaryColor;
        }),
        textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 19.0)),
        elevation: WidgetStateProperty.all(0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  TextButtonThemeData _buildTextButtonThemeData() {
    return TextButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(const EdgeInsets.all(4)),
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 19.0)),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.secondaryColor;
          }
          if (states.contains(WidgetState.pressed)) {
            return AppColors.secondaryColor;
          }
          return AppColors.secondaryColor;
        }),
        splashFactory: NoSplash.splashFactory,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  static InputDecoration get buildDateTimeFieldDecoration {
    const border = InputBorder.none;
    return InputDecoration(
      border: border,
      enabledBorder: border,
      focusedBorder: border,
      hintStyle: AppTextStyle.body.copyWith(color: AppColors.hint),
      suffix: Image.asset(
        AssetsCatalog.icArrowRight,
        height: 22,
        width: 22,
        alignment: Alignment.centerRight,
        color: AppColors.midGrey,
      ),
      hintText: 'Выберите дату',
      isDense: true,
      labelStyle: AppTextStyle.body3,
      contentPadding: EdgeInsets.zero,
    );
  }

  InputDecorationTheme _buildInputDecorationTheme(TextTheme textTheme) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: AppColors.border),
    );
    final textStyle = textTheme.bodyMedium;
    return InputDecorationTheme(
      filled: true,
      isDense: true,
      fillColor: AppColors.white,
      border: border,
      counterStyle: textStyle?.copyWith(color: AppColors.border),
      enabledBorder: border,
      disabledBorder: border.copyWith(
        borderSide: border.borderSide.copyWith(color: AppColors.disabledBorder),
      ),
      errorBorder: border.copyWith(
        borderSide: border.borderSide.copyWith(color: AppColors.errorColor),
      ),
      focusedBorder: border.copyWith(
        borderSide: border.borderSide.copyWith(color: AppColors.primaryColor),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: border.borderSide.copyWith(color: AppColors.errorColor),
      ),
      hintStyle: textStyle?.copyWith(color: AppColors.hint),
      labelStyle: textStyle,
      errorStyle: textStyle?.copyWith(color: AppColors.errorColor),
      contentPadding: const EdgeInsets.all(10),
    );
  }

  PageTransitionsTheme _buildPageTransitionsTheme() {
    return PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      },
    );
  }

  PopupMenuThemeData _buildPopupMenuTheme() {
    return PopupMenuThemeData(
      elevation: 8,
      labelTextStyle: const WidgetStatePropertyAll(
        TextStyle(
          color: AppColors.onSurfaceColor,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    );
  }

  FloatingActionButtonThemeData _buildFloatingActionButtonThemeData() {
    return const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: AppColors.secondaryColor,
    );
  }

  TabBarThemeData _buildTabBarTheme(TextTheme textTheme) {
    const unselectedColor = AppColors.midGrey;
    return TabBarThemeData(
      labelColor: AppColors.white,
      unselectedLabelColor: unselectedColor,
      labelStyle: textTheme.bodyMedium,
      unselectedLabelStyle: textTheme.bodyMedium,
      indicator: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceColor, width: 4),
        ),
      ),
    );
  }

  SliderThemeData videoPlayerSliderTheme({
    required double sliderHeight,
    double enabledThumbRadius = 10.0,
  }) {
    return SliderThemeData(
      overlayShape: SliderComponentShape.noOverlay,
      trackShape: CustomTrackShape(),
      thumbShape: CustomRoundSliderThumbShape(
        sliderHeight: sliderHeight,
        enabledThumbRadius: enabledThumbRadius,
      ),
      trackHeight: 1,
    );
  }

  InputDecoration buildSearchInputDecoration() {
    return const InputDecoration(
      filled: true,
      fillColor: AppColors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
      border: InputBorder.none,
      hintStyle: TextStyle(color: AppColors.hint),
      errorMaxLines: 1,
    );
  }

  DialogThemeData _buildDialogThemeData() {
    return const DialogThemeData(backgroundColor: AppColors.dialogBackground);
  }

  SwitchThemeData _buildSwitchThemeData() {
    return SwitchThemeData(
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) => Colors.transparent,
      ),
      trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryColor;
        }
        return AppColors.primaryColor;
      }),
      thumbColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) => Colors.white,
      ),
    );
  }

  /// Настройка темы для пикера даты
  /// Обязательно сгенерировать swatch цвета, т.к. [DatePickerDialog] использует
  /// почти весь пул цветов (например для выбранной даты используется 500
  /// значение цвета)
  Theme buildDatePickerTheme({required Widget child}) {
    return Theme(
      data: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryColor,
          outlineVariant: AppColors.blue,
        ),
        primaryColor: AppColors.primaryColor,
      ),
      child: child,
    );
  }

  BoxDecoration buildCardDecoration(BuildContext context) => BoxDecoration(
    boxShadow: [buildDefaultShadow(context)],
    color: AppColors.surfaceColor,
    borderRadius: BorderRadius.circular(cardBorderRadius),
  );

  BoxShadow buildDefaultShadow(BuildContext context) => BoxShadow(
    color: Colors.blueGrey.shade900.withAlpha(65),
    blurRadius: 4.0,
    spreadRadius: 1.0,
  );

  BoxDecoration buildCircleDecoration(BuildContext context) => BoxDecoration(
    shape: BoxShape.circle,
    boxShadow: [buildDefaultShadow(context)],
    color: AppColors.surfaceColor,
  );
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    Offset offset = Offset.zero,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class CustomRoundSliderThumbShape extends RoundSliderThumbShape {
  final double sliderHeight;

  const CustomRoundSliderThumbShape({
    required this.sliderHeight,
    super.enabledThumbRadius,
    super.disabledThumbRadius,
    super.elevation,
    super.pressedElevation,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromHeight(sliderHeight);
  }
}
