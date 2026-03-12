import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/global_button.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/core/widgets/popup_message.dart';
import 'package:shopy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shopy/features/auth/presentation/cubit/auth_state.dart';
import 'package:shopy/features/auth/presentation/widgets/text_field.dart';

class NewPasswordPage extends StatelessWidget {
  const NewPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 65),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back, size: 30),
            ),
            _buildTitleSection(),
            SizedBox(height: 24),
            _buildPasswordFields(),
            Expanded(child: SizedBox()),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  // Title Section
  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 14),
        Text(
          'Reset Password',
          style: AppTextStyle.h2SemiBold.copyWith(
            color: AppColors.primary900Color,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Set the new password for your account so you can login and access all the features.',
          style: AppTextStyle.b1Regular.copyWith(
            color: AppColors.primary500Color,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordFields() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (BuildContext context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Passwrod',
              style: AppTextStyle.b1Medium.copyWith(
                color: AppColors.primary900Color,
              ),
            ),
            SizedBox(height: 5),
            CustomTextField(
              textAlign: TextAlign.start,
              autoFocusField: true,
              obscureText: state.isPasswordObscured,
              hintText: 'Password',
              validator: (_) => state.isPasswordValid
                  ? null
                  : 'please password must be at least 6 characters',
              showError: false,
              showSuccess: false,
              onChanged: context.read<AuthCubit>().onPasswordChanged,
              onToggleVisibility: context
                  .read<AuthCubit>()
                  .togglePasswordVisibility,
            ),
            SizedBox(height: 16),
            Text(
              'Confirm Passwrod',
              style: AppTextStyle.b1Medium.copyWith(
                color: AppColors.primary900Color,
              ),
            ),
            SizedBox(height: 5),
            CustomTextField(
              textAlign: TextAlign.start,
              autoFocusField: false,
              obscureText: state.isConfiermPasswordObscured!,
              hintText: 'Confirm Password',
              validator: (_) =>
                  state.isConfirmPasswordValid! ? null : 'Passwords Not Match',
              showError: false,
              showSuccess: false,
              onChanged: context.read<AuthCubit>().onConfirmPasswordChanged,
              onToggleVisibility: context
                  .read<AuthCubit>()
                  .toggleConfirmPasswordVisibility,
            ),
          ],
        );
      },
    );
  }

  // Continue Button (Reset Password)
  Widget _buildContinueButton() {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous.state != current.state,
      listener: (BuildContext context, state) {
        if (state.state == AuthStates.passwordChanged) {
          showDialog(
            context: context,
            builder: (_) => PopupMessage(
              popupState: PopupState.success,
              title: 'Password Changed!',
              description:
                  'Your can now use your new password to login to your account.',
              buttonText: 'Login',
              onTap: () => Navigator.of(context).pushReplacementNamed('/login'),
            ),
          );
        } else if (state.state == AuthStates.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'error message')),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(bottom: 24),
          child: GlobalButton(
            backgroundColor: (state.isConfirmPasswordValid!)
                ? AppColors.primary900Color
                : AppColors.primary200Color,
            border: Border(),
            onTap: () async {
              if (!state.isConfirmPasswordValid!) return;
              await context.read<AuthCubit>().changePassword(
                newPassword: state.confirmPassword!,
                userEmail: state.email
              );
            },
            child: (state.state == AuthStates.changeingPassword)
                ? Center(child: AppLoadingIndicator(size: 40, strokeWidth: 5))
                : Text(
                    'Continue',
                    style: AppTextStyle.b1Medium.copyWith(
                      color: AppColors.background,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
