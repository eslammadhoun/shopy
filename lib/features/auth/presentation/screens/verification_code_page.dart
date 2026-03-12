import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/global_button.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shopy/features/auth/presentation/cubit/auth_state.dart';
import 'package:shopy/features/auth/presentation/widgets/text_field.dart';

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({super.key});

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  late final List<FocusNode> _focusNodes;
  @override
  void initState() {
    _focusNodes = List.generate(4, (_) => FocusNode());
    super.initState();
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

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
            _buildCodeFields(),
            SizedBox(height: 16),
            _buildResendCode(),
            Expanded(child: SizedBox()),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  // Title Section
  Widget _buildTitleSection() {
    return BlocSelector<AuthCubit, AuthState, String>(
      selector: (state) => state.email,
      builder: (BuildContext context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 14),
            Text(
              'Enter 4 Digit Code',
              style: AppTextStyle.h2SemiBold.copyWith(
                color: AppColors.primary900Color,
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Enter 4 digit code that your receive on your email',
                    style: AppTextStyle.b1Regular.copyWith(
                      color: AppColors.primary500Color,
                    ),
                  ),
                  TextSpan(
                    text: '($state).',
                    style: AppTextStyle.b1Regular.copyWith(
                      color: AppColors.primary900Color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // Code Form Fields
  Widget _buildCodeFields() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (BuildContext context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) {
            return CustomTextField(
              maxLength: 1,
              fieldWidth: 70,
              obscureText: false,
              hintText: '',
              validator: null,
              showError: false,
              showSuccess: false,
              autoFocusField: index == 0,
              textAlign: TextAlign.center,
              textInputType: TextInputType.number,
              showCursor: false,
              focusNode: _focusNodes[index],
              onChanged: (value) {
                context.read<AuthCubit>().onOtpChanged(
                  index: index,
                  value: value,
                );

                if (value.isNotEmpty && index < 3) {
                  _focusNodes[index + 1].requestFocus();
                }

                if (value.isEmpty && index > 0) {
                  _focusNodes[index - 1].requestFocus();
                }
              },

              textStyle: AppTextStyle.h2SemiBold.copyWith(
                color: AppColors.primary900Color,
              ),
            );
          }),
        );
      },
    );
  }

  // build reesend code
  Widget _buildResendCode() {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous.state != current.state,
      listener: (BuildContext context, state) {
        if (state.state == AuthStates.otpSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Otp code sent to your email')),
          );
        } else if (state.state == AuthStates.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ??
                    'Falid to send otp code, try again later...',
              ),
            ),
          );
        }
      },
      builder: (BuildContext context, state) {
        return Center(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Email not received? ',
                  style: AppTextStyle.b1Regular.copyWith(
                    color: AppColors.primary500Color,
                  ),
                ),
                WidgetSpan(
                  child: GestureDetector(
                    child: Text(
                      'Resend Code',
                      style: AppTextStyle.b1Medium.copyWith(
                        color: AppColors.primary900Color,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () => context.read<AuthCubit>().sendOtpCode(state.email)
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Send Code Button
  Widget _buildContinueButton() {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous.state != current.state,
      listener: (BuildContext context, state) {
        if (state.state == AuthStates.otpVerified) {
          if (state.isOtpValid) {
            Navigator.of(context).pushReplacementNamed('/new_password');
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Right Otp!!!')));
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Wrong Otp<_,_>')));
          }
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
            backgroundColor: (state.isOtpCompleted)
                ? AppColors.primary900Color
                : AppColors.primary200Color,
            border: Border(),
            onTap: () {
              if (!state.isOtpCompleted) return;
              context.read<AuthCubit>().verifyOtp(
                otpCode: state.otpCode,
                userEmail: state.email,
              );
            },
            child: (state.state == AuthStates.verifingOtp)
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
