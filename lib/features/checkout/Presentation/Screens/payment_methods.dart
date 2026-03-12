import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/app_snack_bar.dart';
import 'package:shopy/core/widgets/bottom_cutton.dart';
import 'package:shopy/core/widgets/global_button.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/core/widgets/no_result.dart';
import 'package:shopy/core/widgets/title_section.dart';
import 'package:shopy/features/checkout/Domain/Entites/payment_method.dart';
import 'package:shopy/features/checkout/Presentation/Cubit/checkout_cubit/checkout_cubit.dart';
import 'package:shopy/features/checkout/Presentation/Cubit/checkout_cubit/checkout_state.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) async {
      await context.read<CheckoutCubit>().getPaymentMethods();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (BuildContext context, state) {
          if (state.changeSelectedPaymentMethodState ==
              ChangeSelectedPaymentMethodState.success) {
            AppSnackBar.show(
              context,
              message: 'Payment Method Changed',
              type: SnackBarType.success,
            );
          } else if (state.changeSelectedPaymentMethodState ==
              ChangeSelectedPaymentMethodState.success) {
            AppSnackBar.show(
              context,
              message:
                  'Failed to save the card, Try Again, ${state.changeSelectedPaymentMethodErrorMessage}',
              type: SnackBarType.success,
            );
          }
        },
        builder: (context, state) => BottomButton(
          text: 'Apply',
          onTap: () async {
            await context.read<CheckoutCubit>().saveSelectedPaymentMethod(
              paymentMethod: state.selectedPaymentMethod!,
            );
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              TitleSection(title: 'Payment Method'),
              SizedBox(height: 20),
              Container(
                height: 1,
                decoration: BoxDecoration(color: AppColors.primary100Color),
              ),
              const SizedBox(height: 20),
              Expanded(child: _buildSavedCardsList(context: context)),
            ],
          ),
        ),
      ),
    );
  }

  // build saved Cards
  Widget _buildSavedCardsList({required BuildContext context}) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (BuildContext context, state) {
        if (state.getPaymentMethodsState == GetPaymentMethodsState.loading) {
          return Center(child: AppLoadingIndicator(size: 60, strokeWidth: 8));
        } else if (state.getPaymentMethodsState ==
            GetPaymentMethodsState.failure) {
          return Center(
            child: Text(state.getPaymentMethodsErrorMessage ?? 'Error'),
          );
        } else if (state.listOfPaymentMethods.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NoResultWidget(
                icon: 'visa',
                title: 'No Saved Cards yet!',
                subTitle: 'You need to add Visa/Debit Card to continue',
              ),
              const SizedBox(height: 24),
              _buildAddNewCardButton(context: context),
            ],
          );
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 20),
                itemCount: state.listOfPaymentMethods.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,

                itemBuilder: (context, index) => _buildPaymentMethodItem(
                  context: context,
                  paymentMethod: state.listOfPaymentMethods[index],
                ),
              ),
              const SizedBox(height: 16),
              _buildAddNewCardButton(context: context),
            ],
          );
        }
      },
    );
  }

  // build payment method widget
  Widget _buildPaymentMethodItem({
    required BuildContext context,
    required PaymentMethod paymentMethod,
  }) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary100Color),
        ),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'lib/assets/icons/${paymentMethod.card.brand == 'visa' ? 'visa' : 'masterCard'}.svg',
              width: 37,
              height: 14,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                '**** **** **** ${paymentMethod.card.last4}',
                style: AppTextStyle.b2SemiBold.copyWith(
                  color: AppColors.primary900Color,
                ),
              ),
            ),
            SizedBox(width: 12),
            BlocBuilder<CheckoutCubit, CheckoutState>(
              builder: (BuildContext context, state) {
                return Radio<bool>(
                  activeColor: AppColors.primary900Color,
                  value: true,
                  // ignore: deprecated_member_use
                  groupValue:
                      paymentMethod.paymentMethodId ==
                      state.selectedPaymentMethod?.paymentMethodId,
                  // ignore: deprecated_member_use
                  onChanged: (val) {
                    if (val != null) {
                      context.read<CheckoutCubit>().changeSelectedPaymentMethod(
                        paymentMethod: paymentMethod,
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // build add new card button widget
  Widget _buildAddNewCardButton({required BuildContext context}) {
    return GlobalButton(
      backgroundColor: AppColors.background,
      border: BoxBorder.all(color: AppColors.primary100Color),
      onTap: () => Navigator.of(context).pushNamed('/new_card_page'),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: AppColors.primary900Color),
              SizedBox(width: 8),
              Text(
                'Add New Card',
                style: AppTextStyle.b1Medium.copyWith(
                  color: AppColors.primary900Color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
