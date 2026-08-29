import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'common/resources/app_config.dart';
import 'common/resources/app_theme.dart';
import 'generated/l10n.dart';
import 'navigation/app_routes.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return OverlaySupport.global(
      child: PlatformApp.router(
        material: (context, child) {
          return MaterialAppRouterData(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.delegate.supportedLocales,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              ScreenUtil.init(
                context,
                designSize: AppConfiguration.mainAppSize,
                splitScreenMode: true,
                minTextAdapt: true,
              );
              return Portal(
                child: Theme(
                  data: AppTheme.lightTheme,
                  child: child ?? Container(),
                ),
              );
            },
          );
        },
        cupertino: (context, child) {
          return CupertinoAppRouterData(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.delegate.supportedLocales,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              ScreenUtil.init(
                context,
                designSize: AppConfiguration.mainAppSize,
                splitScreenMode: true,
                minTextAdapt: true,
              );
              return Portal(
                child: CupertinoTheme(
                  data: AppTheme.cupertinoTheme,
                  child: child ?? Container(),
                ),
              );
            },
          );
        },
        routeInformationProvider: router.routeInformationProvider,
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
      ),
    );
  }
}
