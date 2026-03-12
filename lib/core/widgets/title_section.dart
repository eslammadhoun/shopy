import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/features/home/presentation/cubit/home_cubit/home_cubit.dart';

class TitleSection extends StatelessWidget {
  final String title;
  const TitleSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, size: 30),
        ),
        Text(
          title,
          style: AppTextStyle.h3SemiBold.copyWith(
            color: AppColors.primary900Color,
          ),
        ),
        GestureDetector(
          child: SvgPicture.asset('lib/assets/icons/bell.svg', width: 26),
          onTap: () {
            context.read<HomeCubit>().changeSelectedPage(newIndex: 5);
            Navigator.of(context).pushNamed('/main_page');
          },
        ),
      ],
    );
  }
}
