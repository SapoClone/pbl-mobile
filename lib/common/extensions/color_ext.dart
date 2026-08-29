import 'package:flutter/material.dart';

extension ColorExtension on Color? {
  ColorFilter? get svgColor {
    return this == null
        ? null
        : ColorFilter.mode(
            this!,
            BlendMode.srcIn,
          );
  }
}
