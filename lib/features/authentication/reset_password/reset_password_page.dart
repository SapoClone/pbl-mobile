import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/auth_form_widgets.dart';
import '../../../navigation/route_const.dart';
import 'reset_password_cubit.dart';
import 'reset_password_state.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({
    required this.email,
    super.key,
  });

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordCubit(email: email),
      child: const _ResetPasswordView(),
    );
  }
}

class _ResetPasswordView extends StatelessWidget {
  const _ResetPasswordView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == ResetPasswordStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đặt lại mật khẩu thành công!')),
          );
          context.goNamed(AppRouteName.signIn);
        }
      },
      child: BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
        builder: (context, state) {
          final cubit = context.read<ResetPasswordCubit>();
          return AuthFormScaffold(
            title: 'Đặt lại mật khẩu',
            description: 'Vui lòng nhập mật khẩu mới của bạn.',
            onBack: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.goNamed(AppRouteName.forgotPassword);
              }
            },
            children: [
              AuthTextField(
                hintText: 'Mật khẩu mới',
                prefixIcon: Icons.lock_outline,
                obscureText: state.obscurePassword,
                textInputAction: TextInputAction.next,
                onChanged: cubit.passwordChanged,
                suffixIcon: IconButton(
                  tooltip:
                      state.obscurePassword ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
                  onPressed: cubit.togglePasswordVisibility,
                  icon: Icon(
                    state.obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 22,
                    color: authTextSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AuthTextField(
                hintText: 'Xác nhận mật khẩu mới',
                prefixIcon: Icons.lock_reset_outlined,
                obscureText: state.obscureConfirmPassword,
                textInputAction: TextInputAction.done,
                onChanged: cubit.confirmPasswordChanged,
                onSubmitted: (_) => cubit.submit(),
                suffixIcon: IconButton(
                  tooltip: state.obscureConfirmPassword
                      ? 'Hiện mật khẩu'
                      : 'Ẩn mật khẩu',
                  onPressed: cubit.toggleConfirmPasswordVisibility,
                  icon: Icon(
                    state.obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 22,
                    color: authTextSecondary,
                  ),
                ),
              ),
              if (state.errorMessage != null) ...[
                const SizedBox(height: 12),
                AuthErrorText(state.errorMessage!),
              ],
              const SizedBox(height: 24),
              AuthPrimaryButton(
                label: 'Đặt lại mật khẩu',
                isLoading: state.status == ResetPasswordStatus.submitting,
                onPressed: cubit.submit,
              ),
            ],
          );
        },
      ),
    );
  }
}
