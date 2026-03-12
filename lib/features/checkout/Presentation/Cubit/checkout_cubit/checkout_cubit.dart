import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/checkout/Domain/Entites/delivery_address.dart';
import 'package:shopy/features/checkout/Domain/Entites/payment_method.dart';
import 'package:shopy/features/checkout/Domain/Usecases/add_card_usecase.dart';
import 'package:shopy/features/checkout/Domain/Usecases/add_new_delivery_address.dart';
import 'package:shopy/features/checkout/Domain/Usecases/change_selected_delivery_address.dart';
import 'package:shopy/features/checkout/Domain/Usecases/change_selected_payment_method.dart';
import 'package:shopy/features/checkout/Domain/Usecases/get_delivery_addresses.dart';
import 'package:shopy/features/checkout/Domain/Usecases/get_payment_methods.dart';
import 'package:shopy/features/checkout/Domain/Usecases/get_selected_delivery_address.dart';
import 'package:shopy/features/checkout/Domain/Usecases/get_selected_payment_method.dart';
import 'package:shopy/features/checkout/Domain/Usecases/get_user_location.dart';
import 'package:shopy/features/checkout/Presentation/Cubit/checkout_cubit/checkout_state.dart';
import 'package:shopy/features/home/Domain/use_cases/checkout_usecases/place_order.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final GetUserLocation getUserLocationUsecase;
  final AddNewDeliveryAddress addNewDeliveryAddressUsecase;
  final GetDeliveryAddresses getDeliveryAddressesUsecase;
  final GetSelectedDeliveryAddress getSelectedDeliveryAddressUsecase;
  final ChangeSelectedDeliveryAddress changeSelectedDeliveryAddressUsecase;
  final AddCardUsecase addCardUsecase;
  final GetPaymentMethods getPaymentMethodsUsecase;
  final ChangeSelectedPaymentMethod changeSelectedPaymentMethodUsecase;
  final GetSelectedPaymentMethod getSelectedPaymentMethodUsecase;
  final PlaceOrder placeOrderUsecase;
  StreamSubscription<List<DeliveryAddress>>? _deliveryAddressesStream;

  CheckoutCubit({
    required this.getUserLocationUsecase,
    required this.addNewDeliveryAddressUsecase,
    required this.getDeliveryAddressesUsecase,
    required this.getSelectedDeliveryAddressUsecase,
    required this.changeSelectedDeliveryAddressUsecase,
    required this.addCardUsecase,
    required this.getPaymentMethodsUsecase,
    required this.changeSelectedPaymentMethodUsecase,
    required this.getSelectedPaymentMethodUsecase,
    required this.placeOrderUsecase,
  }) : super(CheckoutState.initial());

  Future<void> getUserLocation() async {
    emit(state.copyWith(getUserLocationState: GetUserLocationState.loading));
    final Either<Failure, LatLng> result = await getUserLocationUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          getUserLocationState: GetUserLocationState.error,
          userLoactionErrorMessage: failure.message,
        ),
      ),
      (success) {
        emit(
          state.copyWith(
            getUserLocationState: GetUserLocationState.success,
            userLocationLatLng: success,
          ),
        );
      },
    );
  }

  void changeSheetSize({required double sheetSize}) {
    emit(state.copyWith(sheetSize: sheetSize));
  }

  void toggleMarkAsDefault() {
    emit(state.copyWith(addressMarkAsDefault: !state.addressMarkAsDefault));
  }

  void validateAddressForm({
    required String nickname,
    required String fullAddress,
  }) {
    final isValid = nickname.trim().isNotEmpty && fullAddress.trim().isNotEmpty;

    emit(state.copyWith(addButtonEnabled: isValid));
  }

  Future<void> addNewDeliveryAddress({
    required DeliveryAddress deliveryAddress,
  }) async {
    emit(
      state.copyWith(
        addingNewDeliveryAddresState: AddingNewDeliveryAddresState.loading,
      ),
    );

    final Either<Failure, void> result = await addNewDeliveryAddressUsecase(
      deliveryAddress: deliveryAddress,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          addingNewDeliveryAddresState: AddingNewDeliveryAddresState.error,
          addNewDeliveryAddressErrorMessage: failure.message,
        ),
      ),
      (success) {
        emit(
          state.copyWith(
            addingNewDeliveryAddresState: AddingNewDeliveryAddresState.success,
            addButtonEnabled: false,
          ),
        );
        emit(
          state.copyWith(
            addingNewDeliveryAddresState: AddingNewDeliveryAddresState.initial,
          ),
        );
      },
    );
  }

  Future<void> getDeliveryAddresses() async {
    emit(
      state.copyWith(
        getDeliveryAddressesState: GetDeliveryAddressesState.loading,
      ),
    );

    final Either<Failure, Stream<List<DeliveryAddress>>> result =
        await getDeliveryAddressesUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          getDeliveryAddressesState: GetDeliveryAddressesState.error,
          getDeliveryAddressesErrorMessage: failure.message,
        ),
      ),
      (success) {
        _deliveryAddressesStream?.cancel();
        _deliveryAddressesStream = success.listen((deliveryAddresses) {
          DeliveryAddress? deliveryAddress = state.selectedDeliveryAddress;
          if (deliveryAddress == null && deliveryAddresses.isNotEmpty) {
            deliveryAddress = deliveryAddresses.firstWhere(
              (deliveryAddress) => deliveryAddress.isDefault,
              orElse: () => deliveryAddresses.first,
            );
          }
          emit(
            state.copyWith(
              getDeliveryAddressesState: GetDeliveryAddressesState.success,
              listOfDeliveryAddresses: deliveryAddresses,
              selectedDeliveryAddress: deliveryAddress,
            ),
          );
        });
      },
    );
  }

  Future<void> getSelectedDeliveryAddress() async {
    final Either<Failure, DeliveryAddress?> result =
        await getSelectedDeliveryAddressUsecase();

    result.fold(
      (failure) {
        emit(state.copyWith());
      },
      (success) {
        if (success != null) {
          emit(
            state.copyWith(
              selectedDeliveryAddress: success,
              isDeliveryAddressSelected: true,
            ),
          );
        } else {
          print('No Delivery Address Found...');
          emit(
            state.copyWith(
              selectedDeliveryAddress: null,
              isDeliveryAddressSelected: false,
            ),
          );
        }
      },
    );
  }

  Future<void> changeSelectedDeliveryAddress({
    required DeliveryAddress deliveryAddress,
  }) async {
    emit(state.copyWith(selectedDeliveryAddress: deliveryAddress));
    print(state.selectedDeliveryAddress!.nickname);
  }

  Future<void> appleyNewSelectedDeliveryAddress({
    required DeliveryAddress deliveryAddress,
  }) async {
    final Either<Failure, void> result =
        await changeSelectedDeliveryAddressUsecase(
          deliveryAddress: deliveryAddress,
        );

    result.fold((failure) => emit(state.copyWith()), (success) {
      emit(
        state.copyWith(
          selectedDeliveryAddress: deliveryAddress,
          isDeliveryAddressSelected: true,
        ),
      );
    });
  }

  void changePaymentMethodType({required String type}) {
    emit(state.copyWith(selectedPaymentMethodType: type));
  }

  void validateNewCardForm(bool isCompleted) {
    emit(state.copyWith(addNewCardButtonEnabled: isCompleted));
  }

  Future<void> addNewCard() async {
    emit(state.copyWith(addNewCardState: AddNewCardState.loading));

    final Either<Failure, void> result = await addCardUsecase();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            addNewCardState: AddNewCardState.failure,
            addNewCardErrorMessage: failure.message,
          ),
        );
        emit(
          state.copyWith(
            addNewCardState: AddNewCardState.inital,
            addNewCardErrorMessage: null,
          ),
        );
      },
      (success) {
        emit(state.copyWith(addNewCardState: AddNewCardState.success));
        emit(state.copyWith(addNewCardState: AddNewCardState.inital));
      },
    );
  }

  Future<void> getPaymentMethods() async {
    emit(
      state.copyWith(getPaymentMethodsState: GetPaymentMethodsState.loading),
    );

    final Either<Failure, List<PaymentMethod>> result =
        await getPaymentMethodsUsecase();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            getPaymentMethodsState: GetPaymentMethodsState.failure,
            getPaymentMethodsErrorMessage: failure.message,
          ),
        );
        emit(
          state.copyWith(
            getPaymentMethodsState: GetPaymentMethodsState.inital,
            getPaymentMethodsErrorMessage: null,
          ),
        );
      },
      (success) => emit(
        state.copyWith(
          getPaymentMethodsState: GetPaymentMethodsState.success,
          listOfPaymentMethods: success,
        ),
      ),
    );
  }

  void changeSelectedPaymentMethod({required PaymentMethod paymentMethod}) {
    emit(state.copyWith(selectedPaymentMethod: paymentMethod));
  }

  Future<void> saveSelectedPaymentMethod({
    required PaymentMethod paymentMethod,
  }) async {
    emit(
      state.copyWith(
        changeSelectedPaymentMethodState:
            ChangeSelectedPaymentMethodState.loading,
      ),
    );

    final Either<Failure, void> result =
        await changeSelectedPaymentMethodUsecase(paymentMethod: paymentMethod);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            changeSelectedPaymentMethodState:
                ChangeSelectedPaymentMethodState.failure,
            changeSelectedPaymentMethodErrorMessage: failure.message,
          ),
        );
        emit(
          state.copyWith(
            changeSelectedPaymentMethodState:
                ChangeSelectedPaymentMethodState.inital,
            changeSelectedPaymentMethodErrorMessage: null,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            changeSelectedPaymentMethodState:
                ChangeSelectedPaymentMethodState.success,
          ),
        );
        emit(
          state.copyWith(
            changeSelectedPaymentMethodState:
                ChangeSelectedPaymentMethodState.inital,
          ),
        );
      },
    );
  }

  Future<void> getSelectedPaymentMethod() async {
    final Either<Failure, PaymentMethod?> result =
        await getSelectedPaymentMethodUsecase();

    result.fold(
      (failure) {
        emit(state.copyWith());
      },
      (success) {
        if (success != null) {
          emit(
            state.copyWith(
              selectedPaymentMethod: success,
              whichPaymentMethodIsSelected: SelectedPaymentMethod.card,
            ),
          );
        } else {
          emit(state.copyWith(selectedPaymentMethod: null));
        }
      },
    );
  }

  Future<void> placeOrder({
    required int amount,
    required String paymentMethodId,
  }) async {
    emit(state.copyWith(placeOrderState: PlaceOrderState.loading));

    final Either<Failure, void> result = await placeOrderUsecase(
      amount: amount,
      paymentMethodId: paymentMethodId,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            placeOrderState: PlaceOrderState.failure,
            placeOrderErrorMessage: failure.message,
          ),
        );
        emit(
          state.copyWith(
            placeOrderState: PlaceOrderState.inital,
            placeOrderErrorMessage: null,
          ),
        );
      },
      (success) =>
          emit(state.copyWith(placeOrderState: PlaceOrderState.success)),
    );
  }

  @override
  Future<void> close() {
    _deliveryAddressesStream?.cancel();
    return super.close();
  }
}
