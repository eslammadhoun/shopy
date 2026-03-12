import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/title_section.dart';
import 'package:shopy/features/home/presentation/cubit/home_cubit/home_cubit.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'icon': 'userId',
        'name': 'My Details',
        'onTap': () {
          Navigator.of(context).pushNamed('/my_details_page');
        },
      },
      {
        'icon': 'address',
        'name': 'Address Book',
        'onTap': () {
          Navigator.of(context).pushNamed('/delivery_address_page');
        },
      },
      {
        'icon': 'card',
        'name': 'Payment Methods',
        'onTap': () {
          Navigator.of(context).pushNamed('/payment_methods_page');
        },
      },
      {
        'icon': 'bell',
        'name': 'Notifications',
        'onTap': () {
          Navigator.of(context).pushNamed('/main_page');
          context.read<HomeCubit>().changeSelectedPage(newIndex: 5);
        },
      },
    ];
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TitleSection(title: 'Account'),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                height: 1,
                decoration: BoxDecoration(color: AppColors.primary100Color),
              ),
            ),
            const SizedBox(height: 20),
            item(
              context: context,
              title: 'My Orders',
              icon: 'orderBox',
              onTap: () {
                context.read<HomeCubit>().changeSelectedPage(newIndex: 6);
              },
            ),
            const SizedBox(height: 24),
            Container(
              height: 8,
              decoration: BoxDecoration(color: AppColors.primary100Color),
            ),
            const SizedBox(height: 24),
            ...List.generate(
              items.length,
              (index) => Column(
                children: [
                  item(
                    context: context,
                    title: items[index]['name'],
                    icon: items[index]['icon'],
                    onTap: items[index]['onTap'],
                  ),
                  const SizedBox(height: 24),
                  index + 1 != items.length
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 64,
                                right: 24,
                              ),
                              child: Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  color: AppColors.primary100Color,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        )
                      : SizedBox(),
                ],
              ),
            ),
            Container(
              height: 8,
              decoration: BoxDecoration(color: AppColors.primary100Color),
            ),
            const SizedBox(height: 24),
            item(
              context: context,
              title: 'FAQs',
              icon: 'Question',
              onTap: () {
                context.read<HomeCubit>().changeSelectedPage(newIndex: 8);
              },
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 64, right: 24),
              child: Container(
                height: 1,
                decoration: BoxDecoration(color: AppColors.primary100Color),
              ),
            ),
            const SizedBox(height: 24),
            item(
              context: context,
              title: 'Help Center',
              icon: 'Headphones',
              onTap: () {
                context.read<HomeCubit>().changeSelectedPage(newIndex: 9);
              },
            ),
            const SizedBox(height: 24),
            Container(
              height: 8,
              decoration: BoxDecoration(color: AppColors.primary100Color),
            ),
            const SizedBox(height: 24),
            item(
              context: context,
              title: 'Logout',
              icon: 'Logout',
              onTap: () {
                context.read<HomeCubit>().logout();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget item({
    required BuildContext context,
    required String title,
    required String icon,
    required void Function()? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            SvgPicture.asset(
              width: 26,
              'lib/assets/icons/$icon.svg',
              color: icon != 'Logout'
                  ? AppColors.primary900Color
                  : AppColors.error,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTextStyle.b1Regular.copyWith(
                  color: icon != 'Logout'
                      ? AppColors.primary900Color
                      : AppColors.error,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.primary300Color),
          ],
        ),
      ),
    );
  }
}
