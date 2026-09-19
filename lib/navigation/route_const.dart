abstract class AppRouteName {
  static const signIn = 'sign-in';
  static const signUp = 'sign-up';
  static const forgotPassword = 'forgot-password';
  static const resetPassword = 'reset-password';
  static const home = 'home';
  static const orderManagement = 'order-management';
  static const orderFilter = 'order-filter';
  static const orderDetail = 'order-detail';
}

abstract class AppRoutePath {
  static const signIn = '/';
  static const signUp = '/sign-up';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const home = '/home';
  static const orderManagement = '/orders';
  static const orderFilter = '/orders/filter';
  static const orderDetail = '/orders/detail';
}
