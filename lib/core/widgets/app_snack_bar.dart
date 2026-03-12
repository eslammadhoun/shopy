import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shopy/core/theme/app_colors.dart';
import '../theme/app_text_style.dart';

enum SnackBarType {success, error, info}

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    bool? heartFill
  }) {
    final color = _getColor(type);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                message,
                style: AppTextStyle.b1Medium.copyWith(color: Colors.white),
              ),
              // ignore: deprecated_member_use
              SvgPicture.asset(heartFill != null ? 'lib/assets/icons/heart-filled.svg': 'lib/assets/icons/heart.svg', color: heartFill != null ?  AppColors.error : null)
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  static Color _getColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return AppColors.primary900Color;
      case SnackBarType.error:
        return AppColors.error;
      case SnackBarType.info:
        return Colors.blue;
    }
  }
}
