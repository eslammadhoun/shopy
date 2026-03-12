import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/global_button.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shopy/features/auth/presentation/cubit/auth_state.dart';
import 'package:shopy/features/auth/presentation/widgets/text_field.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

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
            _buildEmailField(),
            Expanded(child: SizedBox()),
            _buildSendCodeButton(),
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
          'Forgot password',
          style: AppTextStyle.h2SemiBold.copyWith(
            color: AppColors.primary900Color,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Enter your email for the verification process. We will send 4 digits code to your email.',
          style: AppTextStyle.b1Regular.copyWith(
            color: AppColors.primary500Color,
          ),
        ),
      ],
    );
  }

  // Email Form Field
  Widget _buildEmailField() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (BuildContext context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email',
              style: AppTextStyle.b1Medium.copyWith(
                color: AppColors.primary900Color,
              ),
            ),
            SizedBox(height: 5),
            CustomTextField(
              textAlign: TextAlign.start,
              autoFocusField: true,
              obscureText: false,
              hintText: 'Email',
              validator: (_) => state.isEmailValid
                  ? null
                  : 'Please enter valid email address',
              showError: state.showEmailError,
              showSuccess: state.showEmailSuccess,
              onChanged: context.read<AuthCubit>().onEmailChanged,
            ),
          ],
        );
      },
    );
  }

  // Send Code Button
  Widget _buildSendCodeButton() {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous.state != current.state,
      listener: (BuildContext context, state) {
        if (state.state == AuthStates.otpSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Otp Code Sent to your email')),
          );
          Navigator.of(context).pushReplacementNamed('/verification_code');
        } else if (state.state == AuthStates.error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (BuildContext context, state) {
        return Padding(
          padding: EdgeInsets.only(bottom: 24),
          child: GlobalButton(
            backgroundColor: state.isEmailValid
                ? AppColors.primary900Color
                : AppColors.primary200Color,
            border: BoxBorder.all(
              color: state.isEmailValid
                  ? AppColors.primary900Color
                  : AppColors.primary200Color,
            ),
            onTap: () {
              if (!state.isEmailValid) return;
              context.read<AuthCubit>().sendOtpCode(state.email);
            },
            child: (state.state == AuthStates.sendingOtpCode)
                ? Center(child: AppLoadingIndicator(size: 40, strokeWidth: 5))
                : Text(
                    'Send Code',
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
