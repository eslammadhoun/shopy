import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopy/core/di/service_locator.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/global_button.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/core/widgets/social_media_login.dart';
import 'package:shopy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shopy/features/auth/presentation/cubit/auth_state.dart';
import 'package:shopy/features/auth/presentation/widgets/text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => sl<AuthCubit>(),
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          children: [
            _loginPageTitle(),
            _emailField(),
            SizedBox(height: 16),

            _passwordField(),
            SizedBox(height: 10),

            _forgetPassword(context),
            SizedBox(height: 24),

            _login(),
            SizedBox(height: 24),

            SocialMediaLogin(),
            SizedBox(height: 48),

            _dontHaveAccount(context),
          ],
        ),
      ),
    );
  }

  Widget _loginPageTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 70),
        Text('Login to your account', style: AppTextStyle.h2SemiBold),
        SizedBox(height: 8),
        Text(
          'It’s great to see you again.',
          style: AppTextStyle.b1Regular.copyWith(
            color: AppColors.primary500Color,
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _emailField() {
    return BlocSelector<AuthCubit, AuthState, AuthState>(
      selector: (state) => state,
      builder: (context, emailState) {
        return _formField(
          fieldName: 'Eamil',
          customTextField: CustomTextField(
            textAlign: TextAlign.start,
            autoFocusField: false,
            obscureText: false,
            hintText: 'Enter your email address',
            validator: (_) => emailState.isEmailValid
                ? null
                : 'Please enter valid email address',
            showError: emailState.showEmailError,
            showSuccess: emailState.showEmailSuccess,
            onChanged: context.read<AuthCubit>().onEmailChanged,
          ),
        );
      },
    );
  }

  Widget _passwordField() {
    return BlocSelector<AuthCubit, AuthState, AuthState>(
      selector: (state) => state,
      builder: (context, passwordState) {
        return _formField(
          fieldName: 'Password',
          customTextField: CustomTextField(
            textAlign: TextAlign.start,
            autoFocusField: false,
            obscureText: passwordState.isPasswordObscured,
            hintText: 'Enter your password',
            validator: (_) => passwordState.isPasswordValid
                ? null
                : 'Password Must be at least 6 characters',
            showError: false,
            showSuccess: false,
            onChanged: context.read<AuthCubit>().onPasswordChanged,
            onToggleVisibility: () =>
                context.read<AuthCubit>().togglePasswordVisibility(),
          ),
        );
      },
    );
  }

  Widget _forgetPassword(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Forgot your password? ',
            style: AppTextStyle.b2Regular,
          ),
          WidgetSpan(
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/reset_password'),
              child: Text(
                'Reset your password',
                style: AppTextStyle.b1Medium.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _login() {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous.state != current.state,
      listener: (BuildContext context, state) {
        if (state.state == AuthStates.success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Login Success')));
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state.state == AuthStates.error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (BuildContext context, state) {
        return GlobalButton(
          backgroundColor: state.isLoginFormValid
              ? AppColors.primary900Color
              : AppColors.primary200Color,
          border: Border(),
          onTap: () {
            if (!state.isLoginFormValid) return;
            context.read<AuthCubit>().login();
          },
          child: (state.state == AuthStates.loading)
              ? AppLoadingIndicator(size: 40, strokeWidth: 5)
              : Text(
                  'Login',
                  style: AppTextStyle.b1Medium.copyWith(
                    color: AppColors.background,
                  ),
                ),
        );
      },
    );
  }

  Widget _dontHaveAccount(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: 'Don’t have an account? '),
            WidgetSpan(
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/signup'),
                child: Text(
                  'Join',
                  style: AppTextStyle.b1Medium.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reuseable widget
  Widget _formField({
    required String fieldName,
    required CustomTextField customTextField,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldName,
          style: AppTextStyle.b1Medium.copyWith(
            color: AppColors.primary900Color,
          ),
        ),
        SizedBox(height: 5),
        customTextField,
      ],
    );
  }
}
