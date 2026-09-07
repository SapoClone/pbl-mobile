import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dimens.dart';
import '../../gen/colors.gen.dart';

class AppTheme {
  AppTheme._();

  static const fontFamily = 'Roboto';

  static CupertinoThemeData get cupertinoTheme => CupertinoThemeData(
        primaryColor: ColorName.purpleRhythm,
        brightness: Brightness.light,
        scaffoldBackgroundColor: ColorName.purpleCyberGrape,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            fontFamily: fontFamily,
            color: Colors.white,
            fontSize: Dimens.fontSize12,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.3,
            height: 1.4,
          ),
          actionTextStyle: TextStyle(
            fontFamily: fontFamily,
            color: Colors.white,
            fontSize: Dimens.fontSize14,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            height: 1.4,
          ),
        ),
      );

  static ThemeData get lightTheme => ThemeData(
        fontFamily: fontFamily,
        primaryColor: ColorName.purpleRhythm,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: ColorName.purpleRhythm,
        ),
        scaffoldBackgroundColor: ColorName.purpleCyberGrape,
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            color: Colors.white,
            fontSize: Dimens.fontSize14,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.3,
            height: 1.4,
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: Dimens.fontSize14,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.3,
            height: 1.4,
          ),
          labelMedium: TextStyle(
            color: Colors.white,
            fontSize: Dimens.fontSize22,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
            height: 1.4,
          ),
          labelLarge: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: Dimens.fontSize16,
            letterSpacing: -0.3,
            height: 1.4,
          ),
          headlineMedium: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: Dimens.fontSize32,
            letterSpacing: -0.3,
            height: 1.4,
          ),
          headlineSmall: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: Dimens.fontSize20,
            letterSpacing: -0.3,
            height: 1.4,
          ),
          titleLarge: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: Dimens.fontSize22,
            letterSpacing: -0.3,
            height: 1.4,
          ),
          titleMedium: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: Dimens.fontSize16,
            letterSpacing: -0.3,
            height: 1.4,
          ),
          titleSmall: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: Dimens.fontSize14,
            letterSpacing: -0.3,
            height: 1.4,
          ),
          bodySmall: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: Dimens.fontSize12,
            letterSpacing: -0.3,
            height: 1.4,
          ),
        ),
      );
}
