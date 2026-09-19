import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/auth_form_widgets.dart';
import '../../../navigation/route_const.dart';
import 'forgot_password_cubit.dart';
import 'forgot_password_state.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatelessWidget {
  const _ForgotPasswordView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.success) {
          context.pushNamed(
            AppRouteName.resetPassword,
            extra: state.email.trim(),
          );
        }
      },
      child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
        builder: (context, state) {
          final cubit = context.read<ForgotPasswordCubit>();
          return AuthFormScaffold(
            title: 'Forgot password',
            description:
                'Enter your email to receive password reset instructions.',
            onBack: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.goNamed(AppRouteName.signIn);
              }
            },
            children: [
              AuthTextField(
                hintText: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onChanged: cubit.emailChanged,
                onSubmitted: (_) => cubit.submit(),
              ),
              if (state.errorMessage != null) ...[
                const SizedBox(height: 12),
                AuthErrorText(state.errorMessage!),
              ],
              const SizedBox(height: 24),
              AuthPrimaryButton(
                label: 'Send request',
                isLoading: state.status == ForgotPasswordStatus.submitting,
                onPressed: cubit.submit,
              ),
            ],
          );
        },
      ),
    );
  }
}
