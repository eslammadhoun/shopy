import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/home_cubit/home_state.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
      height: 86,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: BoxBorder.fromLTRB(
          top: BorderSide(color: AppColors.primary100Color, width: 2),
        ),
      ),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIconButton(
                iconPath: 'home',
                name: 'Home',
                onTap: () =>
                    context.read<HomeCubit>().changeSelectedPage(newIndex: 0),
                isSelected: state.selectedPage == 0,
              ),
              _buildIconButton(
                iconPath: 'search',
                name: 'Search',
                onTap: () =>
                    context.read<HomeCubit>().changeSelectedPage(newIndex: 1),
                isSelected: state.selectedPage == 1,
              ),
              _buildIconButton(
                iconPath: 'heart',
                name: 'Saved',
                onTap: () =>
                    context.read<HomeCubit>().changeSelectedPage(newIndex: 2),
                isSelected: state.selectedPage == 2,
              ),
              _buildIconButton(
                iconPath: 'cart',
                name: 'Cart',
                onTap: () =>
                    context.read<HomeCubit>().changeSelectedPage(newIndex: 3),
                isSelected: state.selectedPage == 3,
              ),
              _buildIconButton(
                iconPath: 'user',
                name: 'Account',
                onTap: () =>
                    context.read<HomeCubit>().changeSelectedPage(newIndex: 4),
                isSelected: state.selectedPage == 4,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIconButton({
    required String iconPath,
    required String name,
    required void Function() onTap,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            'lib/assets/icons/$iconPath.svg',
            color: isSelected
                ? AppColors.primary900Color
                : AppColors.primary400Color,
            width: 26,
          ),
          Text(
            name,
            style: AppTextStyle.b3Medium.copyWith(
              color: isSelected
                  ? AppColors.primary900Color
                  : AppColors.primary400Color,
            ),
          ),
        ],
      ),
    );
  }
}
