import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/core/widgets/popup_message.dart';
import 'package:shopy/features/welcome/presentation/cubit/splash_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.primary900Color,
      body: Stack(
        children: [
          RepaintBoundary(
            child: Image.asset(
              'lib/assets/images/splash.jpg',
              fit: BoxFit.cover,
              cacheWidth: width.toInt(),
            ),
          ),

          BlocConsumer<SplashCubit, SplashState>(
            listener: (context, state) {
              if (state case SplashNavigate()) {
                Navigator.of(context).pushReplacementNamed(state.route);
              }
            },
            builder: (context, state) {
              switch (state) {
                case SplashLoading():
                  return Positioned(
                    bottom: 60,
                    left: width / 2 - 32,
                    child: AppLoadingIndicator(size: 64, strokeWidth: 8),
                  );
                case SplashError():
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Center(
                        child: PopupMessage(
                          popupState: PopupState.error,
                          title: 'No Internet Connection',
                          description: 'Check Your Internew Connection',
                          buttonText: 'Try Again',
                          onTap: () {},
                        ),
                      ),
                    ),
                  );
                case SplashNavigate():
                  return Positioned(
                    bottom: 60,
                    left: width / 2 - 32,
                    child: Text('User Logged In'),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
