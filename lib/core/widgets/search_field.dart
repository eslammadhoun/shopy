import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';

// ignore: must_be_immutable
class SearchField extends StatelessWidget {
  SearchField({
    super.key,
    required this.onChanged,
    this.controller,
    required this.width,
    this.onFieldSubmitted,
    required this.prefix,
    required this.hintText,
    required this.haseSuffix,
  });
  final String hintText;
  final bool haseSuffix;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final double width;
  final String prefix;
  void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: width,
      child: TextFormField(
        onFieldSubmitted: onFieldSubmitted,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.primary100Color, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.primary200Color, width: 1),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 20, right: prefix == 'discount' ? 10 : 0),
            child: SvgPicture.asset('lib/assets/icons/$prefix.svg'),
          ),
          suffixIcon: haseSuffix ? Padding(
            padding: EdgeInsets.only(right: 20),
            child: SvgPicture.asset('lib/assets/icons/microphone.svg'),
          ) : null,
          hintText: hintText,
          hintStyle: AppTextStyle.b1Regular.copyWith(
            color: AppColors.primary400Color,
          ),
        ),
        cursorColor: AppColors.primary400Color,
      ),
    );
  }
}
