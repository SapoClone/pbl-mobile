import 'package:flutter/material.dart';

import '../resources/app_theme.dart';

const authBrandBlue = Color(0xFF1769E8);
const authBrandBlueDark = Color(0xFF0758D1);
const authTextPrimary = Color(0xFF17233C);
const authTextSecondary = Color(0xFF8C96A8);
const authFieldBorder = Color(0xFFDDE3EC);
const authFontFamily = AppTheme.fontFamily;

class AuthFormScaffold extends StatelessWidget {
  const AuthFormScaffold({
    required this.title,
    required this.description,
    required this.onBack,
    required this.children,
    super.key,
  });

  final String title;
  final String description;
  final VoidCallback onBack;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = (constraints.maxWidth * 0.055).clamp(
              18.0,
              26.0,
            );
            final formSpacing = (constraints.maxHeight * 0.045).clamp(
              28.0,
              42.0,
            );

            return Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      56,
                      horizontalPadding,
                      24,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: (constraints.maxHeight - 80).clamp(
                          0.0,
                          double.infinity,
                        ),
                      ),
                      child: Align(
                        alignment: const Alignment(0, -0.16),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontFamily: authFontFamily,
                                  color: authTextPrimary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                description,
                                style: const TextStyle(
                                  fontFamily: authFontFamily,
                                  color: authTextSecondary,
                                  fontSize: 14,
                                  height: 1.45,
                                ),
                              ),
                              SizedBox(height: formSpacing),
                              ...children,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: (constraints.maxWidth * 0.01).clamp(2.0, 6.0),
                  top: 0,
                  child: IconButton(
                    onPressed: onBack,
                    tooltip: 'Back',
                    visualDensity: VisualDensity.compact,
                    style: IconButton.styleFrom(
                      minimumSize: const Size.square(40),
                      foregroundColor: authTextSecondary,
                    ),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 21,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    required this.hintText,
    required this.prefixIcon,
    required this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.suffixIcon,
    this.onSubmitted,
    super.key,
  });

  final String hintText;
  final IconData prefixIcon;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? suffixIcon;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final height = (MediaQuery.sizeOf(context).width * 0.145).clamp(54.0, 62.0);

    return SizedBox(
      height: height,
      child: TextField(
        style: const TextStyle(
          fontFamily: authFontFamily,
          color: authTextPrimary,
          fontSize: 15,
        ),
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: authFontFamily,
            color: authTextSecondary,
            fontSize: 15,
          ),
          prefixIcon: Icon(prefixIcon, size: 23, color: authTextSecondary),
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: authFieldBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: authBrandBlue, width: 1.5),
          ),
        ),
      ),
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final height = (MediaQuery.sizeOf(context).width * 0.145).clamp(54.0, 62.0);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [authBrandBlue, authBrandBlueDark],
        ),
      ),
      child: SizedBox(
        height: height,
        child: FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: isLoading
              ? const SizedBox.square(
                  dimension: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    fontFamily: authFontFamily,
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}

class AuthErrorText extends StatelessWidget {
  const AuthErrorText(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: const TextStyle(
        fontFamily: authFontFamily,
        color: Colors.redAccent,
        fontSize: 13,
      ),
    );
  }
}
