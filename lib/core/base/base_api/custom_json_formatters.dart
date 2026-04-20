// ignore_for_file: avoid_annotating_with_dynamic

import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

class DateTimeJsonConverter implements JsonConverter<DateTime?, dynamic> {
  const DateTimeJsonConverter();

  @override
  DateTime? fromJson(dynamic json) {
    if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json * 1000).toLocal();
    } else if (json is String) {
      return DateTime.tryParse(json)?.toLocal();
    }
    return null;
  }

  @override
  dynamic toJson(DateTime? object) => object?.toUtc().toIso8601String();
}

class BoolJsonConverter implements JsonConverter<bool, dynamic> {
  const BoolJsonConverter();

  @override
  bool fromJson(dynamic json) {
    if (json is int) {
      return json == 1;
    } else if (json is bool) {
      return json;
    }
    throw ArgumentError('Invalid bool value: $json');
  }

  @override
  int toJson(bool object) => object ? 1 : 0;
}

class DurationJsonConverter extends JsonConverter<Duration?, String?> {
  const DurationJsonConverter();

  @override
  Duration? fromJson(String? json) {
    if (json == null || json.isEmpty) return null;

    final parts = json.split(':');
    if (parts.length < 2) return null;

    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    final seconds = parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0;

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  @override
  String? toJson(Duration? object) => object.toString();
}

class IntNullableJsonConverter implements JsonConverter<int?, dynamic> {
  const IntNullableJsonConverter();

  @override
  int? fromJson(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  @override
  dynamic toJson(int? object) => object;
}

class IntJsonConverter implements JsonConverter<int, dynamic> {
  const IntJsonConverter();

  @override
  int fromJson(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.parse(value);
    }
    throw ArgumentError();
  }

  @override
  dynamic toJson(int? object) => object;
}

class DoubleJsonConverter implements JsonConverter<double?, dynamic> {
  const DoubleJsonConverter();

  @override
  double? fromJson(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  @override
  dynamic toJson(double? object) => object;
}

class ColorJsonConverter implements JsonConverter<Color?, String?> {
  const ColorJsonConverter();

  @override
  Color? fromJson(String? value) {
    if (value == null) {
      return null;
    }
    final buffer = StringBuffer();
    if (value.length == 6 ||
        value.length == 7 && value.contains('#') ||
        value.length == 4 && value.contains('#')) {
      buffer.write('ff');
    }
    if (value.length == 4) {
      final temp = value.replaceFirst('#', '');
      buffer.write(
        "${temp[0]}${temp[0]}${temp[1]}${temp[1]}${temp[2]}${temp[2]}",
      );
    } else {
      buffer.write(value.replaceFirst('#', ''));
    }

    final colorInt = int.tryParse(buffer.toString(), radix: 16);
    if (colorInt == null) {
      return null;
    }
    return Color(colorInt);
  }

  @override
  String? toJson(Color? value) {
    if (value == null) {
      return null;
    }
    return "#${value.r.toInt().toRadixString(16).padLeft(2, '0')}${value.g.toInt().toRadixString(16).padLeft(2, '0')}${value.b.toInt().toRadixString(16).padLeft(2, '0')}";
  }
}
