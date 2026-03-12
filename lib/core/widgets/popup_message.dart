import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';

enum PopupState { error, success }

class PopupMessage extends StatelessWidget {
  final PopupState popupState;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onTap;

  const PopupMessage({
    super.key,
    required this.popupState,
    required this.onTap,
    required this.title,
    required this.description,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              popupState == PopupState.error
                  ? 'lib/assets/icons/failure.svg'
                  : 'lib/assets/icons/successIcon.svg',
              width: 78,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyle.h4SemiBold.copyWith(
                color: AppColors.primary900Color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyle.b1Medium.copyWith(
                color: AppColors.primary500Color,
              ),
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary900Color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    buttonText,
                    style: AppTextStyle.b1Medium.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}