import 'package:flutter/material.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';

class CatecoryButton extends StatelessWidget {
  final BuildContext context;
  final bool isSelected;
  final String categoryName;
  
  const CatecoryButton({
    super.key,
    required this.context,
    required this.isSelected,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? AppColors.primary900Color
              : AppColors.primary100Color,
        ),
        color: isSelected ? AppColors.primary900Color : AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          categoryName,
          style: AppTextStyle.b1Medium.copyWith(
            color: isSelected
                ? AppColors.background
                : AppColors.primary900Color,
          ),
        ),
      ),
    );
  }
}
