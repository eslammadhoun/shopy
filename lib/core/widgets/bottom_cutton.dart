import 'package:flutter/material.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/global_button.dart';

class BottomButton extends StatelessWidget {
  final String text;
  final Widget? child;
  final void Function()? onTap;
  const BottomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        MediaQuery.of(context).viewInsets.bottom > 0
            ? MediaQuery.of(context).viewInsets.bottom + 12
            : 20,
      ),
      child: GlobalButton(
        backgroundColor: AppColors.primary900Color,
        border: BoxBorder.all(color: AppColors.primary900Color),
        onTap: onTap,
        child:
            child ??
            Text(
              text,
              style: AppTextStyle.b1Medium.copyWith(
                color: AppColors.background,
              ),
            ),
      ),
    );
  }
}
