import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/authentication/presentation/view/login_page.dart';
import 'route_const.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final goRouterProvider = Provider((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutePath.onboarding,
    routes: [
      GoRoute(
        name: AppRouteName.onboarding,
        path: AppRoutePath.onboarding,
        pageBuilder: (context, state) =>
            CupertinoPage(child: const LoginPage()),
      ),
    ],
  );
});
