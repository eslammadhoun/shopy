import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/title_section.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          children: [
            TitleSection(title: 'Notifications'),
            SizedBox(height: 29),
            Container(color: AppColors.primary100Color, height: 1),
            SizedBox(height: 20),
            _buildListOfNotifications(context),
          ],
        ),
      ),
    );
  }

  // build list of notifications
  Widget _buildListOfNotifications(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        Text(
          'Today',
          style: AppTextStyle.b1SemiBold.copyWith(
            color: AppColors.primary900Color,
          ),
        ),
        SizedBox(height: 16),
        _buildNotifcationItem(),
      ],
    );
  }

  // build notification item
  Widget _buildNotifcationItem() {
    return Row(
      children: [
        SvgPicture.asset('lib/assets/icons/promotionIocn.svg', width: 24),
        SizedBox(width: 13),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '30% Special Discount!',
              style: AppTextStyle.b2SemiBold.copyWith(
                color: AppColors.primary900Color,
              ),
            ),
            Text(
              'Special promotion only valid today.',
              style: AppTextStyle.b3Regular.copyWith(
                color: AppColors.primary500Color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
