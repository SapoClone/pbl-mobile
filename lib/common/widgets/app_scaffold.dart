import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../gen/colors.gen.dart';

class AppPlatformScaffold extends StatelessWidget {
  const AppPlatformScaffold({
    super.key,
    this.brightness = Brightness.dark,
    this.backgroundColor,
    this.body,
    this.appBar,
    this.resizeToAvoidBottomInset,
    this.extendBody,
    this.extendBodyBehindAppBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.floatingActionButtonLocation,
    this.bottomSheet,
    this.canPop = true,
    this.onPopInvokedWithResult,
  });

  final Brightness? brightness;
  final Color? backgroundColor;
  final Widget? body;
  final PreferredSizeWidget? appBar;
  final bool? resizeToAvoidBottomInset;
  final bool? extendBody;
  final bool? extendBodyBehindAppBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomSheet;

  /// PopScope properties
  ///
  final bool canPop;
  final Function(bool, dynamic)? onPopInvokedWithResult;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarBrightness: (Platform.isAndroid) ? null : brightness,
          statusBarIconBrightness: (Platform.isIOS)
              ? null
              : (brightness == Brightness.dark)
                  ? Brightness.light
                  : Brightness.dark,
          statusBarColor: Colors.transparent,
          systemNavigationBarColor:
              backgroundColor ?? ColorName.purpleCyberGrape,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
        child: Scaffold(
          backgroundColor: backgroundColor ?? ColorName.purpleCyberGrape,
          body: body,
          appBar: appBar,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          extendBody: extendBody ?? false,
          extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButtonLocation: floatingActionButtonLocation,
          bottomSheet: bottomSheet,
        ),
      ),
    );
  }
}
