import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/app_snack_bar.dart';
import 'package:shopy/core/widgets/global_button.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/core/widgets/popup_message.dart';
import 'package:shopy/core/widgets/title_section.dart';
import 'package:shopy/features/checkout/Presentation/Cubit/checkout_cubit/checkout_cubit.dart';
import 'package:shopy/features/checkout/Presentation/Cubit/checkout_cubit/checkout_state.dart';

class NewCardPage extends StatefulWidget {
  const NewCardPage({super.key});

  @override
  State<NewCardPage> createState() => _NewCardPageState();
}

class _NewCardPageState extends State<NewCardPage> {
  final CardFormEditController cardFormEditController =
      CardFormEditController();

  @override
  void dispose() {
    super.dispose();
    cardFormEditController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              TitleSection(title: 'New Card'),
              SizedBox(height: 20),
              Container(
                height: 1,
                decoration: BoxDecoration(color: AppColors.primary100Color),
              ),
              const SizedBox(height: 20),
              _buildCardInformationForm(),
              BlocConsumer<CheckoutCubit, CheckoutState>(
                listener: (BuildContext context, CheckoutState state) {
                  if (state.addNewCardState == AddNewCardState.failure) {
                    AppSnackBar.show(
                      context,
                      message: state.addNewCardErrorMessage ?? 'Error',
                      type: SnackBarType.success,
                    );
                  } else if (state.addNewCardState == AddNewCardState.success) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => PopupMessage(
                        popupState: PopupState.success,
                        onTap: () => Navigator.of(context).pushNamed('/payment_methods_page'),
                        title: 'Congratulations!',
                        description: 'Your new card has been added.',
                        buttonText: 'Thanks',
                      ),
                    );
                  }
                },
                builder: (BuildContext context, state) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                    child: GlobalButton(
                      backgroundColor: state.addNewCardButtonEnabled
                          ? AppColors.primary900Color
                          : AppColors.primary200Color,
                      border: Border.all(
                        color: state.addNewCardButtonEnabled
                            ? AppColors.primary900Color
                            : AppColors.primary200Color,
                      ),
                      onTap: () async {
                        await context.read<CheckoutCubit>().addNewCard();
                      },

                      child: state.addNewCardState == AddNewCardState.loading
                          ? AppLoadingIndicator(size: 40, strokeWidth: 5)
                          : Text(
                              'Add',
                              style: AppTextStyle.b1Medium.copyWith(
                                color: AppColors.background,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // build card information form
  Widget _buildCardInformationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Debit or Credit Card',
          style: AppTextStyle.b1SemiBold.copyWith(
            color: AppColors.primary900Color,
          ),
        ),
        const SizedBox(height: 16),
        CardFormField(
          controller: cardFormEditController,
          onCardChanged: (card) => context
              .read<CheckoutCubit>()
              .validateNewCardForm(card?.complete ?? false),
        ),
      ],
    );
  }
}
