import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../resources/dimens.dart';

extension PlatFormThemeDataExtension on BuildContext {
  TextStyle? get regularSize14WhiteText => platformThemeData(
        this,
        material: (data) => data.textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontSize: Dimens.fontSize14,
          fontWeight: FontWeight.w400,
        ),
        cupertino: (data) => data.textTheme.textStyle.copyWith(
          color: Colors.white,
          fontSize: Dimens.fontSize14,
          fontWeight: FontWeight.w400,
        ),
      );
}
