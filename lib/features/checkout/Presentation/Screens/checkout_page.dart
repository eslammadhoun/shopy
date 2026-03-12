import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/widgets/app_snack_bar.dart';
import 'package:shopy/core/widgets/bottom_cutton.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/core/widgets/popup_message.dart';
import 'package:shopy/core/widgets/search_field.dart';
import 'package:shopy/core/widgets/title_section.dart';
import 'package:shopy/features/checkout/Domain/Entites/delivery_address.dart';
import 'package:shopy/features/checkout/Presentation/Cubit/checkout_cubit/checkout_cubit.dart';
import 'package:shopy/features/checkout/Presentation/Cubit/checkout_cubit/checkout_state.dart';
import 'package:shopy/core/widgets/price_details.dart';
import 'package:shopy/features/home/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/cart_cubit/cart_state.dart';
import '../../../../core/theme/app_text_style.dart' show AppTextStyle;

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) async {
      await context.read<CheckoutCubit>().getSelectedDeliveryAddress();
      if (mounted) {
        await context.read<CheckoutCubit>().getSelectedPaymentMethod();
      }
    });
  }

  static const List<Map<String, dynamic>> paymentMethodsList = [
    {'type': 'card', 'title': 'Card', 'icon': 'card'},
    {'type': 'cash', 'title': 'Cash', 'icon': 'cash'},
    {'type': 'apple', 'title': 'Pay', 'icon': 'apple'},
  ];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutCubit, CheckoutState>(
      buildWhen: (prev, curr) =>
          prev.selectedPaymentMethodType != curr.selectedPaymentMethodType ||
          prev.selectedDeliveryAddress != curr.selectedDeliveryAddress ||
          prev.isDeliveryAddressSelected != curr.isDeliveryAddressSelected ||
          prev.whichPaymentMethodIsSelected !=
              curr.whichPaymentMethodIsSelected ||
          prev.selectedPaymentMethod != curr.selectedPaymentMethod ||
          prev.placeOrderState != curr.placeOrderState ||
          prev.placeOrderErrorMessage != curr.placeOrderErrorMessage,
      listenWhen: (prev, curr) =>
          prev.placeOrderState != curr.placeOrderState ||
          prev.placeOrderErrorMessage != curr.placeOrderErrorMessage,
      listener: (BuildContext context, state) {
        if (state.placeOrderState == PlaceOrderState.failure) {
          AppSnackBar.show(
            context,
            message: state.placeOrderErrorMessage,
            type: SnackBarType.success,
          );
        }
        if (state.placeOrderState == PlaceOrderState.success) {
          showDialog(
            context: context,
            builder: (BuildContext context) => PopupMessage(
              popupState: PopupState.success,
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/my_orders_page');
              },
              title: 'Congratulations!',
              description: 'Your order has been placed.',
              buttonText: 'Track Your Order',
            ),
          );
        }
      },
      builder: (BuildContext context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: BottomButton(
            text: 'Place Order',
            onTap: () async {
              final CartState cartState = context.read<CartCubit>().state;
              final checkoutState = context.read<CheckoutCubit>().state;

              if (checkoutState.selectedPaymentMethod == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please select payment method')),
                );
                return;
              }
              if (checkoutState.selectedDeliveryAddress == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please select Delivery Address')),
                );
                return;
              }

              final int amountInCentes = (cartState.total * 100).toInt();

              await context.read<CheckoutCubit>().placeOrder(
                amount: amountInCentes,
                paymentMethodId:
                    checkoutState.selectedPaymentMethod!.paymentMethodId,
              );
            },
            child: state.placeOrderState == PlaceOrderState.loading
                ? Center(child: AppLoadingIndicator(size: 40, strokeWidth: 5))
                : null,
          ),
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    TitleSection(title: 'Checkout'),
                    SizedBox(height: 20),
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        color: AppColors.primary100Color,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery Address',
                          style: AppTextStyle.b1SemiBold.copyWith(
                            color: AppColors.primary900Color,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(
                            context,
                          ).pushNamed('/delivery_address_page'),
                          child: Text(
                            'Change',
                            style: AppTextStyle.b2Medium.copyWith(
                              color: AppColors.primary900Color,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    state.isDeliveryAddressSelected
                        ? _buildDeliveryAddressSection(
                            deliveryAddress: state.selectedDeliveryAddress!,
                          )
                        : Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: SvgPicture.asset(
                                      'lib/assets/icons/location-pin.svg',
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  InkWell(
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      '/delivery_address_page',
                                    ),
                                    child: Text(
                                      'Add Delivery Address',
                                      style: AppTextStyle.b1SemiBold.copyWith(
                                        color: AppColors.primary900Color,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    _buildPaymentMethodSection(
                      context,
                      selectedType: state.selectedPaymentMethodType,
                      whichMethodIsSelected: state.whichPaymentMethodIsSelected,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Order Summary',
                      style: AppTextStyle.b1SemiBold.copyWith(
                        color: AppColors.primary900Color,
                      ),
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<CartCubit, CartState>(
                      builder: (BuildContext context, state) {
                        return PriceDetails(
                          subTotal: state.subTotal,
                          shoppingFee: state.shippingFee,
                          total: state.total,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    PromoCodeWidget(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // build Delivery Address Section
  Widget _buildDeliveryAddressSection({
    required DeliveryAddress deliveryAddress,
  }) {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildSelectedDeliveryAddress(
          addressNickName: deliveryAddress.nickname,
          fullAddress: deliveryAddress.fullAddress,
        ),
        const SizedBox(height: 20),
        Container(
          height: 1,
          decoration: BoxDecoration(color: AppColors.primary100Color),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // build selected Delivery Address Item
  Widget _buildSelectedDeliveryAddress({
    required String addressNickName,
    required String fullAddress,
  }) {
    return Row(
      children: [
        SvgPicture.asset('lib/assets/icons/location-pin.svg'),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              addressNickName,
              style: AppTextStyle.b2SemiBold.copyWith(
                color: AppColors.primary900Color,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              fullAddress,
              style: AppTextStyle.b2Regular.copyWith(
                color: AppColors.primary500Color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // build payment method Section
  Widget _buildPaymentMethodSection(
    BuildContext context, {
    required String selectedType,
    required SelectedPaymentMethod whichMethodIsSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: AppTextStyle.b1SemiBold.copyWith(
            color: AppColors.primary900Color,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                paymentMethodsList.length,
                (index) => _buildPaymentMethodItem(
                  context: context,
                  isSelected: selectedType == paymentMethodsList[index]['type'],
                  icon: paymentMethodsList[index]['icon'],
                  title: paymentMethodsList[index]['title'],
                  type: paymentMethodsList[index]['type'],
                ),
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<CheckoutCubit, CheckoutState>(
              builder: (BuildContext context, state) {
                return selectedType == 'card'
                    ? whichMethodIsSelected == SelectedPaymentMethod.card
                          ? _buildVisaCardItem(
                              context: context,
                              last4: state.selectedPaymentMethod!.card.last4,
                              brand: state.selectedPaymentMethod!.card.brand,
                            )
                          : InkWell(
                              onTap: () => Navigator.of(
                                context,
                              ).pushNamed('/payment_methods_page'),
                              child: Text(
                                'Add New Visa Card',
                                style: AppTextStyle.b1Medium,
                              ),
                            )
                    : selectedType == 'cash'
                    ? Text('Cash')
                    : Text('Apple Pay');
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          height: 1,
          decoration: BoxDecoration(color: AppColors.primary100Color),
        ),
      ],
    );
  }

  // build payment method item
  Widget _buildPaymentMethodItem({
    required BuildContext context,
    required bool isSelected,
    required String icon,
    required String title,
    required String type,
  }) {
    return InkWell(
      onTap: () =>
          context.read<CheckoutCubit>().changePaymentMethodType(type: type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: (MediaQuery.of(context).size.width - 64) / 3,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary900Color : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.primary900Color
                : AppColors.primary500Color,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'lib/assets/icons/$icon.svg',
                color: isSelected
                    ? AppColors.background
                    : AppColors.primary900Color,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTextStyle.b2Medium.copyWith(
                  color: isSelected
                      ? AppColors.background
                      : AppColors.primary900Color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // build visa card item
  Widget _buildVisaCardItem({
    required BuildContext context,
    required String last4,
    required String brand,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary500Color, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              SvgPicture.asset(
                'lib/assets/icons/${brand == 'visa' ? 'visa' : 'masterCard'}.svg',
                color: AppColors.primary900Color,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '**** **** **** $last4',
                  style: AppTextStyle.b1Medium.copyWith(
                    color: AppColors.primary900Color,
                  ),
                ),
              ),
              InkWell(
                onTap: () =>
                    Navigator.of(context).pushNamed('/payment_methods_page'),
                child: SvgPicture.asset('lib/assets/icons/edit.svg'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PromoCodeWidget extends StatefulWidget {
  const PromoCodeWidget({super.key});

  @override
  State<PromoCodeWidget> createState() => _PromoCodeWidgetState();
}

class _PromoCodeWidgetState extends State<PromoCodeWidget> {
  late final TextEditingController promoCodeController;

  @override
  initState() {
    promoCodeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    promoCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SearchField(
          onChanged: (newValue) {},
          width: MediaQuery.of(context).size.width - 140,
          hintText: 'Enter Promo Code',
          prefix: 'discount',
          haseSuffix: false,
          controller: promoCodeController,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InkWell(
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary900Color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Add',
                  style: AppTextStyle.b1Medium.copyWith(
                    color: AppColors.background,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
