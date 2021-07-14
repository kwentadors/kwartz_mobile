import 'package:flutter/material.dart';

class NetValueColorScheme {
  final Color color;

  const NetValueColorScheme._(this.color);

  static const NetValueColorScheme POSITIVE_COLOR_SCHEME =
      NetValueColorScheme._(Colors.greenAccent);

  static const NetValueColorScheme NEGATIVE_COLOR_SCHEME =
      NetValueColorScheme._(Colors.redAccent);

  static const NetValueColorScheme ZERO_COLOR_SCHEME =
      NetValueColorScheme._(Colors.grey);

  static NetValueColorScheme getColorScheme(value) {
    if (value > 0) return POSITIVE_COLOR_SCHEME;
    if (value < 0) return NEGATIVE_COLOR_SCHEME;
    return ZERO_COLOR_SCHEME;
  }
}
