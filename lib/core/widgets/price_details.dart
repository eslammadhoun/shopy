import 'package:flutter/material.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';

class PriceDetails extends StatelessWidget {
  final double subTotal;
  final double shoppingFee;
  final double total;
  const PriceDetails({
    super.key,
    required this.subTotal,
    required this.shoppingFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPricingDetailWidget(
          context: context,
          subject: 'Sub-total',
          value: subTotal,
        ),
        SizedBox(height: 16),
        _buildPricingDetailWidget(
          context: context,
          subject: 'VAT (%)',
          value: 0.00,
        ),
        SizedBox(height: 16),
        _buildPricingDetailWidget(
          context: context,
          subject: 'Shipping fee',
          value: shoppingFee,
        ),
        SizedBox(height: 16),
        Container(height: 1, color: AppColors.primary100Color),
        SizedBox(height: 16),
        _buildPricingDetailWidget(
          context: context,
          subject: 'Total',
          value: total,
        ),
      ],
    );
  }

  Widget _buildPricingDetailWidget({
    required BuildContext context,
    required String subject,
    required double value,
  }) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(
          subject,
          style: AppTextStyle.b1Regular.copyWith(
            color: subject == 'Total'
                ? AppColors.primary900Color
                : AppColors.primary500Color,
          ),
        ),
        Text(
          '\$ $value',
          style: AppTextStyle.b1Medium.copyWith(
            color: AppColors.primary900Color,
          ),
        ),
      ],
    );
  }
}
