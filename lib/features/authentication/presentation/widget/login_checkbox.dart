import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../gen/colors.gen.dart';

class LoginCheckbox extends StatefulWidget {
  const LoginCheckbox({super.key, this.onChanged});

  final Function(bool)? onChanged;

  @override
  State<LoginCheckbox> createState() => _LoginCheckboxState();
}

class _LoginCheckboxState extends State<LoginCheckbox> {
  bool _isCheck = true;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      onChanged: (bool? value) {
        setState(() {
          _isCheck = value ?? true;
        });
        widget.onChanged?.call(value ?? true);
      },
      value: _isCheck,
      checkColor: ColorName.blueJacarta,
      fillColor: WidgetStateProperty.all(
        Colors.transparent,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
      side: WidgetStateBorderSide.resolveWith(
        (states) => const BorderSide(color: ColorName.blueJacarta),
      ),
    );
  }
}
