import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/authentication/forgot_password/forgot_password_page.dart';
import '../features/authentication/reset_password/reset_password_page.dart';
import '../features/authentication/sign_in/sign_in_page.dart';
import '../features/authentication/sign_up/sign_up_page.dart';
import 'route_const.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final goRouterProvider = Provider((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutePath.signIn,
    routes: [
      GoRoute(
        name: AppRouteName.signIn,
        path: AppRoutePath.signIn,
        pageBuilder: (context, state) =>
            const CupertinoPage(child: SignInPage()),
      ),
      GoRoute(
        name: AppRouteName.signUp,
        path: AppRoutePath.signUp,
        pageBuilder: (context, state) =>
            const CupertinoPage(child: SignUpPage()),
      ),
      GoRoute(
        name: AppRouteName.forgotPassword,
        path: AppRoutePath.forgotPassword,
        pageBuilder: (context, state) =>
            const CupertinoPage(child: ForgotPasswordPage()),
      ),
      GoRoute(
        name: AppRouteName.resetPassword,
        path: AppRoutePath.resetPassword,
        pageBuilder: (context, state) => CupertinoPage(
          child: ResetPasswordPage(email: state.extra as String? ?? ''),
        ),
      ),
    ],
  );
});
