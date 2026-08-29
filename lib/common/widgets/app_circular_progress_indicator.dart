import 'package:flutter/material.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class AppCircularProgressIndicator extends StatelessWidget {
  const AppCircularProgressIndicator({
    super.key,
    this.color = Colors.white,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return PlatformCircularProgressIndicator(
      material: (_, __) => MaterialProgressIndicatorData(
        color: color,
      ),
      cupertino: (_, __) => CupertinoProgressIndicatorData(
        color: color,
        radius: 20,
      ),
    );
  }
}
