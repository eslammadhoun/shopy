import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/bottom_cutton.dart';
import 'package:shopy/core/widgets/global_button.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/core/widgets/no_result.dart';
import 'package:shopy/core/widgets/title_section.dart';
import 'package:shopy/features/checkout/Domain/Entites/delivery_address.dart';
import 'package:shopy/features/checkout/Presentation/Cubit/checkout_cubit/checkout_cubit.dart';
import 'package:shopy/features/checkout/Presentation/Cubit/checkout_cubit/checkout_state.dart';

class DeliveryAddressPage extends StatefulWidget {
  const DeliveryAddressPage({super.key});

  @override
  State<DeliveryAddressPage> createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) async {
      await context.read<CheckoutCubit>().getDeliveryAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocBuilder<CheckoutCubit, CheckoutState>(
        buildWhen: (previous, current) =>
            previous.selectedDeliveryAddress !=
                current.selectedDeliveryAddress ||
            previous.isDeliveryAddressSelected !=
                current.isDeliveryAddressSelected,
        builder: (context, state) => BottomButton(
          text: 'Apply',
          onTap: () {
            context.read<CheckoutCubit>().appleyNewSelectedDeliveryAddress(
              deliveryAddress: state.selectedDeliveryAddress!,
            );
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              TitleSection(title: 'Address'),
              SizedBox(height: 20),
              Container(
                height: 1,
                decoration: BoxDecoration(color: AppColors.primary100Color),
              ),
              const SizedBox(height: 20),
              _buildSavedAddressList(context: context),
              const SizedBox(height: 24),
              _buildAddNewAddress(context: context),
            ],
          ),
        ),
      ),
    );
  }

  // build saved address
  Widget _buildSavedAddressList({required BuildContext context}) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (BuildContext context, state) {
        if (state.getDeliveryAddressesState ==
            GetDeliveryAddressesState.loading) {
          return Center(child: AppLoadingIndicator(size: 60, strokeWidth: 8));
        } else if (state.getDeliveryAddressesState ==
            GetDeliveryAddressesState.error) {
          return Center(
            child: Text(state.getDeliveryAddressesErrorMessage ?? 'Error'),
          );
        } else if (state.listOfDeliveryAddresses.isEmpty) {
          return NoResultWidget(
            icon: 'cart2',
            title: 'No Delivery Addresses Saved yet!',
            subTitle: 'You need to add new delivery address',
          );
        } else {
          return Column(
            children: List.generate(state.listOfDeliveryAddresses.length, (
              index,
            ) {
              final DeliveryAddress deliveryAddress =
                  state.listOfDeliveryAddresses[index];
              return _buildDeliveryAddressWidget(
                context: context,
                deliveryAddress: deliveryAddress,
              );
            }),
          );
        }
      },
    );
  }

  // build delivery address widget
  Widget _buildDeliveryAddressWidget({
    required BuildContext context,
    required DeliveryAddress deliveryAddress,
  }) {
    return InkWell(
      onTap: () => context.read<CheckoutCubit>().changeSelectedDeliveryAddress(
        deliveryAddress: deliveryAddress,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary100Color),
        ),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        margin: EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('lib/assets/icons/location-pin.svg'),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  deliveryAddress.isDefault
                      ? Row(
                          children: [
                            Text(
                              deliveryAddress.nickname,
                              style: AppTextStyle.b2SemiBold.copyWith(
                                color: AppColors.primary900Color,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 5),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 9,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary100Color,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  'Default',
                                  style: AppTextStyle.b3Medium.copyWith(
                                    color: AppColors.primary900Color,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Text(
                          deliveryAddress.nickname,
                          style: AppTextStyle.b2SemiBold.copyWith(
                            color: AppColors.primary900Color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                  const SizedBox(width: 4),
                  Text(
                    deliveryAddress.fullAddress,
                    style: AppTextStyle.b2Regular.copyWith(
                      color: AppColors.primary500Color,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            BlocBuilder<CheckoutCubit, CheckoutState>(
              builder: (BuildContext context, state) {
                return Radio<bool>(
                  activeColor: AppColors.primary900Color,
                  value: true,
                  // ignore: deprecated_member_use
                  groupValue: deliveryAddress.id == state.selectedDeliveryAddress!.id,
                  // ignore: deprecated_member_use
                  onChanged: (val) {
                    if (val != null) {
                      context
                          .read<CheckoutCubit>()
                          .changeSelectedDeliveryAddress(
                            deliveryAddress: deliveryAddress,
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

  // build add new address button widget
  Widget _buildAddNewAddress({required BuildContext context}) {
    return GlobalButton(
      backgroundColor: AppColors.background,
      border: BoxBorder.all(color: AppColors.primary100Color),
      onTap: () => Navigator.of(context).pushNamed('/new_address_page'),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: AppColors.primary900Color),
              SizedBox(width: 8),
              Text(
                'Add New Address',
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
