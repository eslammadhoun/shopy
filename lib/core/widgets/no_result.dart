import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';

class NoResultWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String subTitle;
  const NoResultWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('lib/assets/icons/$icon.svg', width: 64),
        SizedBox(height: 20),
        SizedBox(
          width: 218,
          child: Center(
            child: Text(
              textAlign: TextAlign.center,
              title,
              style: AppTextStyle.h4SemiBold.copyWith(
                color: AppColors.primary900Color,
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          width: 252,
          child: Text(
            textAlign: TextAlign.center,
            subTitle,
            style: AppTextStyle.b1Regular.copyWith(
              color: AppColors.primary500Color,
            ),
          ),
        ),
      ],
    );
  }
}
