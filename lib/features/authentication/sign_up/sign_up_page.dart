import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/resources/app_theme.dart';
import '../../../core/di/di.dart';
import '../../../navigation/route_const.dart';
import '../data/repository/authentication_repository.dart';
import 'sign_up_cubit.dart';
import 'sign_up_state.dart';

const _brandBlue = Color(0xFF1769E8);
const _brandBlueDark = Color(0xFF0758D1);
const _textPrimary = Color(0xFF17233C);
const _textSecondary = Color(0xFF8C96A8);
const _fieldBorder = Color(0xFFDDE3EC);
const _fontFamily = AppTheme.fontFamily;

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpCubit(
        authenticationRepository: getIt<AuthenticationRepository>(),
      ),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatelessWidget {
  const _SignUpView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == SignUpStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created successfully!')),
          );
          context.goNamed(AppRouteName.signIn);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = (constraints.maxWidth * 0.07).clamp(
                20.0,
                32.0,
              );
              final topSpacing = (constraints.maxHeight * 0.055).clamp(
                28.0,
                58.0,
              );
              final sectionSpacing = (constraints.maxHeight * 0.03).clamp(
                20.0,
                30.0,
              );
              final logoSize = (constraints.maxWidth * 0.18).clamp(64.0, 78.0);
              final fieldHeight = (constraints.maxWidth * 0.145).clamp(
                54.0,
                62.0,
              );
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
                      child: BlocBuilder<SignUpCubit, SignUpState>(
                        builder: (context, state) {
                          final cubit = context.read<SignUpCubit>();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: topSpacing),
                              _SapoCloneLogo(size: logoSize),
                              SizedBox(height: sectionSpacing),
                              const Text(
                                'Sign up',
                                style: TextStyle(
                                  fontFamily: _fontFamily,
                                  color: _textPrimary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Create your SapoClone account',
                                style: TextStyle(
                                  fontFamily: _fontFamily,
                                  color: _textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                height: fieldHeight,
                                child: TextField(
                                  style: const TextStyle(
                                    fontFamily: _fontFamily,
                                    color: _textPrimary,
                                    fontSize: 15,
                                  ),
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [AutofillHints.name],
                                  onChanged: cubit.fullNameChanged,
                                  decoration: _inputDecoration(
                                    hint: 'Full name',
                                    icon: Icons.person_outline,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
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
                                    hint: 'Email',
                                    icon: Icons.email_outlined,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                height: fieldHeight,
                                child: TextField(
                                  style: const TextStyle(
                                    fontFamily: _fontFamily,
                                    color: _textPrimary,
                                    fontSize: 15,
                                  ),
                                  obscureText: state.obscurePassword,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [
                                    AutofillHints.newPassword,
                                  ],
                                  onChanged: cubit.passwordChanged,
                                  decoration:
                                      _inputDecoration(
                                        hint: 'Password',
                                        icon: Icons.lock_outline,
                                      ).copyWith(
                                        suffixIcon: IconButton(
                                          onPressed:
                                              cubit.togglePasswordVisibility,
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
                              const SizedBox(height: 14),
                              SizedBox(
                                height: fieldHeight,
                                child: TextField(
                                  style: const TextStyle(
                                    fontFamily: _fontFamily,
                                    color: _textPrimary,
                                    fontSize: 15,
                                  ),
                                  obscureText: state.obscureConfirmPassword,
                                  textInputAction: TextInputAction.done,
                                  onChanged: cubit.confirmPasswordChanged,
                                  onSubmitted: (_) => cubit.submit(),
                                  decoration:
                                      _inputDecoration(
                                        hint: 'Confirm password',
                                        icon: Icons.lock_reset_outlined,
                                      ).copyWith(
                                        suffixIcon: IconButton(
                                          onPressed: cubit
                                              .toggleConfirmPasswordVisibility,
                                          icon: Icon(
                                            state.obscureConfirmPassword
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            size: 22,
                                            color: _textSecondary,
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: Checkbox(
                                      value: state.acceptTerms,
                                      activeColor: _brandBlue,
                                      side: const BorderSide(
                                        color: _textSecondary,
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      onChanged: (value) => cubit
                                          .acceptTermsChanged(value ?? false),
                                    ),
                                  ),
                                  const SizedBox(width: 9),
                                  const Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        text: 'I agree to the ',
                                        children: [
                                          TextSpan(
                                            text: 'Terms of Service',
                                            style: TextStyle(
                                              fontFamily: _fontFamily,
                                              color: _brandBlue,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      style: TextStyle(
                                        fontFamily: _fontFamily,
                                        color: _textPrimary,
                                        fontSize: 13,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
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
                              const SizedBox(height: 22),
                              _GradientButton(
                                label: 'Sign up',
                                isLoading:
                                    state.status == SignUpStatus.submitting,
                                onPressed: cubit.submit,
                              ),
                              const SizedBox(height: 24),
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  const Text(
                                    'Already have an account?',
                                    style: TextStyle(
                                      fontFamily: _fontFamily,
                                      color: _textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        context.goNamed(AppRouteName.signIn),
                                    child: const Text(
                                      'Sign in',
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

class _SapoCloneLogo extends StatelessWidget {
  const _SapoCloneLogo({required this.size});

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
                right: -2,
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
        const SizedBox(height: 6),
        const Text(
          'SapoClone',
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
  );
}
