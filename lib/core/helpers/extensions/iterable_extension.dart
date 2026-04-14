import 'package:flutter/material.dart';

extension ExtendedIterable<E> on Iterable<E> {
  /// Аналогичен методу `map<T>(T Function(E e) f)`, но возвращает [Iterable] без [Null] значений
  ///
  /// Example:
  /// ```dart
  ///   var list = [-1, 1, -2, 2, -3, 3];
  ///   var negativeList = list.compactMap((e) => e < 0 ? e : null).toList();
  ///   print(negativeList); // [-1, -2, -3]
  /// ```
  Iterable<T> compactMap<T>(T Function(E e) f) =>
      map(f).where((e) => e != null);

  /// Сокращенный вариант записи `firstWhere(test, orElse: () => null)`
  ///
  /// Example:
  /// ```dart
  ///   var list = [1, 2, 3];
  ///   list.firstWhere((e) => e < 0); // Uncaught Error: Bad state: No element
  ///   list.firstWhereOrNull((e) => e < 0); // null
  /// ```

  /// Создает новый массив вставляя между элементами разделитель,
  /// построенный анонимной функцией [separatorBuilder]
  ///
  /// Example:
  /// ```dart
  ///   var list = [1, 2, 3];
  ///   var separatedlist = list.separate((index) => 0);
  ///   print(separatedlist); // [1, 0, 2, 0, 3]
  /// ```
  Iterable<E> separate(
    E? Function(int index, int length) separatorBuilder,
  ) sync* {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return;
    var item = iterator.current;
    var idx = 0;
    while (iterator.moveNext()) {
      yield item;
      final separator = separatorBuilder(idx, length);
      if (separator != null) {
        yield separator;
      }
      item = iterator.current;
      idx++;
    }
    yield item;
  }

  /// Проверка на существование первого элемента списка
  E? get safeFirst => isEmpty ? null : first;

  /// Проверка на существование последнего элемента списка
  E? get safeLast => isEmpty ? null : last;
}

extension WidgetsIterable<W extends Widget> on Iterable<Widget> {
  List<Widget> addDividers({Color? color, double? height}) {
    return separate(
      (index, length) => Divider(color: color, height: height),
    ).toList();
  }

  List<Widget> addSeparatorSizedBox({double? height, double? width}) {
    return separate((_, __) => SizedBox(height: height, width: width)).toList();
  }
}
