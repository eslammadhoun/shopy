import 'package:flutter/material.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/global_button.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'lib/assets/images/decoratedLines.png',
              scale: 0.9,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 107,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: BoxBorder.symmetric(
                  horizontal: BorderSide(color: AppColors.primary100Color),
                ),
              ),
              child: GlobalButton(
                backgroundColor: AppColors.primary900Color,
                border: Border.all(),
                onTap: () =>
                    Navigator.of(context).pushReplacementNamed('/login'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get Started',
                      style: AppTextStyle.b1Medium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 24,
            right: 42,
            child: Text(
              'Define yourself in your unique way.',
              style: AppTextStyle.h1SemiBold,
            ),
          ),
          Positioned(
            bottom: 107,
            right: 0,
            child: Image.asset('lib/assets/images/person.png'),
          ),
        ],
      ),
    );
  }
}
