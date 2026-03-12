import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/global_button.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shopy/features/auth/presentation/cubit/auth_state.dart';

class SocialMediaLogin extends StatelessWidget {
  const SocialMediaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous.state != current.state,
      listener: (BuildContext context, state) {
        if (state.state == AuthStates.success) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state.state == AuthStates.error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (BuildContext context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 2,
                  width: (MediaQuery.of(context).size.width - 81) / 2,
                  color: AppColors.primary100Color,
                ),
                Text(
                  'Or',
                  style: AppTextStyle.b2Regular.copyWith(
                    color: AppColors.primary500Color,
                  ),
                ),
                Container(
                  height: 2,
                  width: (MediaQuery.of(context).size.width - 81) / 2,
                  color: AppColors.primary100Color,
                ),
              ],
            ),
            SizedBox(height: 24),
            GlobalButton(
              backgroundColor: AppColors.background,
              border: BoxBorder.all(color: AppColors.primary200Color, width: 1),
              onTap: () => context.read<AuthCubit>().loginWithGoogle(),
              child: (state.state == AuthStates.googleLoading)
                  ? Center(child: AppLoadingIndicator(size: 40, strokeWidth: 5))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('lib/assets/icons/google.svg'),
                        SizedBox(width: 10),
                        Text(
                          'Sign Up with Google',
                          style: AppTextStyle.b1Medium.copyWith(
                            color: AppColors.primary900Color,
                          ),
                        ),
                      ],
                    ),
            ),
            SizedBox(height: 16),
            GlobalButton(
              backgroundColor: AppColors.blue,
              border: Border(),
              onTap: () => context.read<AuthCubit>().loginWithFacebook(),
              child: (state.state == AuthStates.facebookLoading)
                  ? Center(child: AppLoadingIndicator(size: 40, strokeWidth: 5))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('lib/assets/icons/facebook.svg'),
                        SizedBox(width: 10),
                        Text(
                          'Sign Up with Facebook',
                          style: AppTextStyle.b1Medium.copyWith(
                            color: AppColors.background,
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
}
