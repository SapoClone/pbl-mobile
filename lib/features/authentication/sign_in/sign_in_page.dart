import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../navigation/route_const.dart';
import 'sign_in_cubit.dart';
import 'sign_in_state.dart';

const _brandBlue = Color(0xFF1769E8);
const _brandBlueDark = Color(0xFF0758D1);
const _textPrimary = Color(0xFF17233C);
const _textSecondary = Color(0xFF8C96A8);
const _fieldBorder = Color(0xFFDDE3EC);
const _fontFamily = 'Roboto';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInCubit(),
      child: const _SignInView(),
    );
  }
}

class _SignInView extends StatelessWidget {
  const _SignInView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInCubit, SignInState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == SignInStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng nhập thành công!')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding =
                  (constraints.maxWidth * 0.07).clamp(20.0, 32.0);
              final topSpacing =
                  (constraints.maxHeight * 0.13).clamp(64.0, 112.0);
              final sectionSpacing =
                  (constraints.maxHeight * 0.045).clamp(28.0, 42.0);
              final logoSize = (constraints.maxWidth * 0.18).clamp(64.0, 78.0);
              final fieldHeight =
                  (constraints.maxWidth * 0.145).clamp(54.0, 62.0);
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 32,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: BlocBuilder<SignInCubit, SignInState>(
                        builder: (context, state) {
                          final cubit = context.read<SignInCubit>();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: topSpacing),
                              _RetailProLogo(size: logoSize),
                              SizedBox(height: sectionSpacing),
                              const Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  fontFamily: _fontFamily,
                                  color: _textPrimary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Chào mừng bạn trở lại',
                                style: TextStyle(
                                  fontFamily: _fontFamily,
                                  color: _textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 28),
                              SizedBox(
                                height: fieldHeight,
                                child: TextField(
                                  style: const TextStyle(
                                    fontFamily: _fontFamily,
                                    color: _textPrimary,
                                    fontSize: 15,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [AutofillHints.email],
                                  onChanged: cubit.emailChanged,
                                  decoration: _inputDecoration(
                                    hint: 'Email hoặc số điện thoại',
                                    icon: Icons.email_outlined,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: fieldHeight,
                                child: TextField(
                                  style: const TextStyle(
                                    fontFamily: _fontFamily,
                                    color: _textPrimary,
                                    fontSize: 15,
                                  ),
                                  obscureText: state.obscurePassword,
                                  textInputAction: TextInputAction.done,
                                  autofillHints: const [AutofillHints.password],
                                  onChanged: cubit.passwordChanged,
                                  onSubmitted: (_) => cubit.submit(),
                                  decoration: _inputDecoration(
                                    hint: 'Mật khẩu',
                                    icon: Icons.lock_outline,
                                  ).copyWith(
                                    suffixIcon: IconButton(
                                      tooltip: state.obscurePassword
                                          ? 'Hiện mật khẩu'
                                          : 'Ẩn mật khẩu',
                                      onPressed: cubit.togglePasswordVisibility,
                                      icon: Icon(
                                        state.obscurePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        size: 22,
                                        color: _textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _SignInOptions(
                                rememberMe: state.rememberMe,
                                onRememberChanged: cubit.rememberMeChanged,
                                onForgotPassword: () => context.pushNamed(
                                  AppRouteName.forgotPassword,
                                ),
                              ),
                              if (state.errorMessage != null) ...[
                                const SizedBox(height: 12),
                                Text(
                                  state.errorMessage!,
                                  style: const TextStyle(
                                    fontFamily: _fontFamily,
                                    color: Colors.redAccent,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 24),
                              _GradientButton(
                                label: 'Đăng nhập',
                                isLoading:
                                    state.status == SignInStatus.submitting,
                                onPressed: cubit.submit,
                              ),
                              const SizedBox(height: 34),
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  const Text(
                                    'Chưa có tài khoản?',
                                    style: TextStyle(
                                      fontFamily: _fontFamily,
                                      color: _textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        context.goNamed(AppRouteName.signUp),
                                    child: const Text(
                                      'Đăng ký',
                                      style: TextStyle(
                                        fontFamily: _fontFamily,
                                        color: _brandBlue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RetailProLogo extends StatelessWidget {
  const _RetailProLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: size + 8,
          height: size,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Icon(
                  Icons.shopping_bag_rounded,
                  size: size,
                  color: _brandBlue,
                ),
              ),
              Positioned(
                right: -3,
                bottom: -2,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_rounded,
                    size: size * 0.36,
                    color: _brandBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'RetailPro',
          style: TextStyle(
            fontFamily: _fontFamily,
            color: _brandBlue,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SignInOptions extends StatelessWidget {
  const _SignInOptions({
    required this.rememberMe,
    required this.onRememberChanged,
    required this.onForgotPassword,
  });

  final bool rememberMe;
  final ValueChanged<bool> onRememberChanged;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: rememberMe,
            activeColor: _brandBlue,
            side: const BorderSide(color: _textSecondary, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
            onChanged: (value) => onRememberChanged(value ?? false),
          ),
        ),
        const SizedBox(width: 9),
        const Expanded(
          child: Text(
            'Ghi nhớ đăng nhập',
            maxLines: 2,
            style: TextStyle(
              fontFamily: _fontFamily,
              color: _textPrimary,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: onForgotPassword,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Quên mật khẩu?',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: _fontFamily,
              color: _brandBlue,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(colors: [_brandBlue, _brandBlueDark]),
      ),
      child: SizedBox(
        height: 52,
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
                    fontFamily: _fontFamily,
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

InputDecoration _inputDecoration({
  required String hint,
  required IconData icon,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      fontFamily: _fontFamily,
      color: _textSecondary,
      fontSize: 15,
    ),
    prefixIcon: Icon(icon, size: 23, color: _textSecondary),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: _fieldBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: _brandBlue, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
  );
}
