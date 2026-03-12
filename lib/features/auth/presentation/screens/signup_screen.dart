import 'package:flutter/gestures.dart';
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

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => sl<AuthCubit>(),
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          children: [
            _signUpPageTitle(),
            _nameField(),
            SizedBox(height: 16),

            _emailField(),
            SizedBox(height: 16),

            _passwordField(),
            SizedBox(height: 12),

            _privacyPolicy(),
            SizedBox(height: 24),

            _createAnAccount(),
            SizedBox(height: 24),

            SocialMediaLogin(),
            SizedBox(height: 48),

            _haveAccount(context),
          ],
        ),
      ),
    );
  }

  Widget _signUpPageTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 70),
        Text('Create an account', style: AppTextStyle.h2SemiBold),
        SizedBox(height: 8),
        Text(
          'Let’s create your account.',
          style: AppTextStyle.b1Regular.copyWith(
            color: AppColors.primary500Color,
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _nameField() {
    return BlocSelector<AuthCubit, AuthState, AuthState>(
      selector: (state) => state,
      builder: (context, nameState) {
        return _formField(
          fieldName: 'Full Name',
          customTextField: CustomTextField(
            textAlign: TextAlign.start,
            autoFocusField: false,
            obscureText: false,
            hintText: 'Enter your full name',
            validator: (_) => nameState.isNameValid
                ? null
                : 'Name Must be at least 5 characters',
            showError: nameState.showNameError,
            showSuccess: nameState.showNameSuccess,
            onChanged: context.read<AuthCubit>().onUserNameChanged,
          ),
        );
      },
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

  Widget _privacyPolicy() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'By signing up you agree to our ',
            style: AppTextStyle.b2Regular.copyWith(
              color: AppColors.primary900Color,
            ),
          ),
          TextSpan(
            text: 'Terms, Privacy Policy,             ',
            style: AppTextStyle.b1Medium.copyWith(
              color: AppColors.primary900Color,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          TextSpan(
            text: 'And  ',
            style: AppTextStyle.b2Regular.copyWith(
              color: AppColors.primary900Color,
            ),
          ),
          TextSpan(
            text: 'Cookie Use ',
            style: AppTextStyle.b1Medium.copyWith(
              color: AppColors.primary900Color,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
        ],
      ),
    );
  }

  // Create Account Button
  Widget _createAnAccount() {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous.state != current.state,
      listener: (BuildContext context, state) {
        if (state.state == AuthStates.success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('SignUp Success')));
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state.state == AuthStates.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'error message')),
          );
        }
      },
      builder: (BuildContext context, state) {
        return GlobalButton(
          backgroundColor: state.isSignUpFormValid
              ? AppColors.primary900Color
              : AppColors.primary200Color,
          border: Border(),
          onTap: () {
            if (!state.isSignUpFormValid) return;
            context.read<AuthCubit>().signUp();
          },
          child: (state.state == AuthStates.loading)
              ? AppLoadingIndicator(size: 40, strokeWidth: 5)
              : Text(
                  'Create an Account',
                  style: AppTextStyle.b1Medium.copyWith(
                    color: AppColors.background,
                  ),
                ),
        );
      },
    );
  }

  Widget _haveAccount(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: 'Already have an account? '),
            WidgetSpan(
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/login'),
                child: Text(
                  'Log In',
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

  // Reuseable Widgets -|
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
