import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/di/di.dart';

class AppConfiguration {
  AppConfiguration._();

  static Future<void> ensureAppConfiguration() async {
    await ScreenUtil.ensureScreenSize();
    await configureInjection();
  }

  static const mainAppSize = Size(375, 812);
}
