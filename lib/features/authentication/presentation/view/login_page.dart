import 'package:flutter/material.dart';

import '../../../../common/extensions/text_style_ext.dart';
import '../../../../common/widgets/app_scaffold.dart';

/// TODO: This UI is for template purpose
///
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPlatformScaffold(
      body: Center(
        child: Text(
          'LOGIN',
          style: context.regularSize14WhiteText,
        ),
      ),
    );
  }
}
