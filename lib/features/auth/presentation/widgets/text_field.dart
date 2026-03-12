import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';

class CustomTextField extends StatelessWidget {
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final String hintText;
  final String? Function(String?)? validator;
  final bool showError;
  final bool showSuccess;
  final bool autoFocusField;
  final double? fieldWidth;
  final void Function(String)? onChanged;
  final TextInputType? textInputType;
  final bool? showCursor;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final int? maxLength;
  final TextStyle? textStyle;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    this.fieldWidth,
    super.key,
    required this.obscureText,
    this.onToggleVisibility,
    required this.hintText,
    this.validator,
    required this.showError,
    required this.showSuccess,
    this.onChanged,
    required this.autoFocusField,
    this.textInputType,
    this.showCursor,
    this.focusNode,
    required this.textAlign,
    this.maxLength,
    this.textStyle,
    this.controller,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    Widget? suffixIcon;
    if (onToggleVisibility != null) {
      suffixIcon = IconButton(
        padding: EdgeInsets.zero,

        onPressed: onToggleVisibility,
        icon: SvgPicture.asset(
          obscureText
              ? 'lib/assets/icons/eyeOffIcon.svg'
              : 'lib/assets/icons/eyeIcon.svg',
        ),
      );
    } else if (showSuccess) {
      suffixIcon = Padding(
        padding: EdgeInsets.all(10),
        child: SvgPicture.asset('lib/assets/icons/successIcon.svg'),
      );
    } else if (showError) {
      suffixIcon = Padding(
        padding: EdgeInsets.all(10),
        child: SvgPicture.asset('lib/assets/icons/errorIcon.svg'),
      );
    }

    return SizedBox(
      width: fieldWidth,
      child: TextFormField(
        inputFormatters: inputFormatters,
        controller: controller,
        buildCounter:
            (
              context, {
              required currentLength,
              required isFocused,
              required maxLength,
            }) => null,
        maxLength: maxLength,
        showCursor: showCursor,
        textAlign: textAlign,
        keyboardType: textInputType,
        autofocus: autoFocusField,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: obscureText,
        validator: validator,
        style:
            textStyle ??
            AppTextStyle.b1Medium.copyWith(color: AppColors.primary900Color),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary100Color),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary900Color, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: hintText,
          hintStyle: AppTextStyle.b1Regular.copyWith(
            color: AppColors.primary400Color,
          ),
          suffixIcon: suffixIcon,
          errorStyle: AppTextStyle.b2Medium.copyWith(color: AppColors.error),
        ),
        onChanged: onChanged,
        focusNode: focusNode,
      ),
    );
  }
}
