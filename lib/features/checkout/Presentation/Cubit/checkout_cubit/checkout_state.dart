import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopy/features/checkout/Domain/Entites/delivery_address.dart';
import 'package:shopy/features/checkout/Domain/Entites/payment_method.dart';

enum GetUserLocationState { initial, loading, success, error }

enum AddingNewDeliveryAddresState { initial, loading, success, error }

enum GetDeliveryAddressesState { inital, loading, success, error }

enum SelectedPaymentMethod { inital, card, cash, applePay }

enum AddNewCardState { inital, loading, success, failure }

enum GetPaymentMethodsState { inital, loading, success, failure }

enum ChangeSelectedPaymentMethodState { inital, loading, success, failure }

enum PlaceOrderState { inital, loading, success, failure }

class CheckoutState extends Equatable {
  // Chekout Page
  final DeliveryAddress? selectedDeliveryAddress;
  final PaymentMethod? selectedPaymentMethod;
  final bool isDeliveryAddressSelected;
  final String selectedPaymentMethodType;
  final SelectedPaymentMethod whichPaymentMethodIsSelected;
  final PlaceOrderState placeOrderState;
  final String placeOrderErrorMessage;

  // New Address Page
  final LatLng userLocationLatLng;
  final GetUserLocationState getUserLocationState;
  final String? userLoactionErrorMessage;
  final double sheetSize;
  final bool addressMarkAsDefault;
  final bool addButtonEnabled;
  final AddingNewDeliveryAddresState addingNewDeliveryAddresState;
  final String? addNewDeliveryAddressErrorMessage;

  // addresses page
  final GetDeliveryAddressesState getDeliveryAddressesState;
  final String? getDeliveryAddressesErrorMessage;
  final List<DeliveryAddress> listOfDeliveryAddresses;

  // New Card Page
  final bool addNewCardButtonEnabled;
  final AddNewCardState addNewCardState;
  final String? addNewCardErrorMessage;

  // Payment Methods Page
  final GetPaymentMethodsState getPaymentMethodsState;
  final List<PaymentMethod> listOfPaymentMethods;
  final String? getPaymentMethodsErrorMessage;
  final ChangeSelectedPaymentMethodState? changeSelectedPaymentMethodState;
  final String? changeSelectedPaymentMethodErrorMessage;

  const CheckoutState({
    required this.selectedPaymentMethodType,
    required this.isDeliveryAddressSelected,
    required this.whichPaymentMethodIsSelected,
    required this.selectedDeliveryAddress,
    required this.userLocationLatLng,
    required this.getUserLocationState,
    required this.userLoactionErrorMessage,
    required this.sheetSize,
    required this.addressMarkAsDefault,
    required this.addButtonEnabled,
    required this.addingNewDeliveryAddresState,
    required this.addNewDeliveryAddressErrorMessage,
    required this.getDeliveryAddressesState,
    required this.getDeliveryAddressesErrorMessage,
    required this.listOfDeliveryAddresses,
    required this.addNewCardButtonEnabled,
    required this.addNewCardState,
    this.addNewCardErrorMessage,
    required this.getPaymentMethodsState,
    required this.listOfPaymentMethods,
    this.getPaymentMethodsErrorMessage,
    this.selectedPaymentMethod,
    required this.changeSelectedPaymentMethodState,
    required this.changeSelectedPaymentMethodErrorMessage,
    required this.placeOrderState,
    required this.placeOrderErrorMessage
  });

  factory CheckoutState.initial() {
    return CheckoutState(
      selectedPaymentMethodType: 'card',
      whichPaymentMethodIsSelected: SelectedPaymentMethod.inital,
      isDeliveryAddressSelected: false,
      selectedDeliveryAddress: null,
      userLocationLatLng: LatLng(0, 0),
      getUserLocationState: GetUserLocationState.initial,
      userLoactionErrorMessage: null,
      sheetSize: 0.5,
      addressMarkAsDefault: false,
      addButtonEnabled: false,
      addingNewDeliveryAddresState: AddingNewDeliveryAddresState.initial,
      addNewDeliveryAddressErrorMessage: null,
      getDeliveryAddressesState: GetDeliveryAddressesState.inital,
      getDeliveryAddressesErrorMessage: null,
      listOfDeliveryAddresses: [],
      addNewCardButtonEnabled: false,
      addNewCardState: AddNewCardState.inital,
      addNewCardErrorMessage: null,
      getPaymentMethodsState: GetPaymentMethodsState.inital,
      listOfPaymentMethods: [],
      getPaymentMethodsErrorMessage: null,
      changeSelectedPaymentMethodState: ChangeSelectedPaymentMethodState.inital,
      changeSelectedPaymentMethodErrorMessage: null,
      placeOrderState: PlaceOrderState.inital,
      placeOrderErrorMessage: ''
    );
  }

  CheckoutState copyWith({
    String? selectedPaymentMethodType,
    bool? isDeliveryAddressSelected,
    SelectedPaymentMethod? whichPaymentMethodIsSelected,
    DeliveryAddress? selectedDeliveryAddress,
    LatLng? userLocationLatLng,
    GetUserLocationState? getUserLocationState,
    String? userLoactionErrorMessage,
    double? sheetSize,
    bool? addressMarkAsDefault,
    bool? addButtonEnabled,
    AddingNewDeliveryAddresState? addingNewDeliveryAddresState,
    String? addNewDeliveryAddressErrorMessage,
    GetDeliveryAddressesState? getDeliveryAddressesState,
    String? getDeliveryAddressesErrorMessage,
    List<DeliveryAddress>? listOfDeliveryAddresses,
    bool? addNewCardButtonEnabled,
    AddNewCardState? addNewCardState,
    String? addNewCardErrorMessage,
    GetPaymentMethodsState? getPaymentMethodsState,
    List<PaymentMethod>? listOfPaymentMethods,
    String? getPaymentMethodsErrorMessage,
    PaymentMethod? selectedPaymentMethod,
    ChangeSelectedPaymentMethodState? changeSelectedPaymentMethodState,
    String? changeSelectedPaymentMethodErrorMessage,
    PlaceOrderState? placeOrderState,
    String? placeOrderErrorMessage
  }) {
    return CheckoutState(
      selectedPaymentMethodType:
          selectedPaymentMethodType ?? this.selectedPaymentMethodType,
      isDeliveryAddressSelected:
          isDeliveryAddressSelected ?? this.isDeliveryAddressSelected,
      whichPaymentMethodIsSelected:
          whichPaymentMethodIsSelected ?? this.whichPaymentMethodIsSelected,
      selectedDeliveryAddress:
          selectedDeliveryAddress ?? this.selectedDeliveryAddress,
      userLocationLatLng: userLocationLatLng ?? this.userLocationLatLng,
      getUserLocationState: getUserLocationState ?? this.getUserLocationState,
      userLoactionErrorMessage:
          userLoactionErrorMessage ?? this.userLoactionErrorMessage,
      sheetSize: sheetSize ?? this.sheetSize,
      addressMarkAsDefault: addressMarkAsDefault ?? this.addressMarkAsDefault,
      addButtonEnabled: addButtonEnabled ?? this.addButtonEnabled,
      addingNewDeliveryAddresState:
          addingNewDeliveryAddresState ?? this.addingNewDeliveryAddresState,
      addNewDeliveryAddressErrorMessage:
          addNewDeliveryAddressErrorMessage ??
          this.addNewDeliveryAddressErrorMessage,
      getDeliveryAddressesState:
          getDeliveryAddressesState ?? this.getDeliveryAddressesState,
      getDeliveryAddressesErrorMessage:
          getDeliveryAddressesErrorMessage ??
          this.getDeliveryAddressesErrorMessage,
      listOfDeliveryAddresses:
          listOfDeliveryAddresses ?? this.listOfDeliveryAddresses,
      addNewCardButtonEnabled:
          addNewCardButtonEnabled ?? this.addNewCardButtonEnabled,
      addNewCardState: addNewCardState ?? this.addNewCardState,
      addNewCardErrorMessage:
          addNewCardErrorMessage ?? this.addNewCardErrorMessage,
      getPaymentMethodsState:
          getPaymentMethodsState ?? this.getPaymentMethodsState,
      listOfPaymentMethods: listOfPaymentMethods ?? this.listOfPaymentMethods,
      getPaymentMethodsErrorMessage:
          getPaymentMethodsErrorMessage ?? this.getPaymentMethodsErrorMessage,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      changeSelectedPaymentMethodState:
          changeSelectedPaymentMethodState ??
          this.changeSelectedPaymentMethodState,
      changeSelectedPaymentMethodErrorMessage:
          changeSelectedPaymentMethodErrorMessage ??
          this.changeSelectedPaymentMethodErrorMessage,
      placeOrderState: placeOrderState ?? this.placeOrderState,
      placeOrderErrorMessage: placeOrderErrorMessage ?? this.placeOrderErrorMessage
    );
  }

  @override
  List<Object?> get props => [
    selectedPaymentMethodType,
    isDeliveryAddressSelected,
    whichPaymentMethodIsSelected,
    selectedDeliveryAddress,
    userLocationLatLng,
    getUserLocationState,
    userLoactionErrorMessage,
    sheetSize,
    addressMarkAsDefault,
    addButtonEnabled,
    addingNewDeliveryAddresState,
    addNewDeliveryAddressErrorMessage,
    getDeliveryAddressesState,
    getDeliveryAddressesErrorMessage,
    listOfDeliveryAddresses,
    addNewCardButtonEnabled,
    addNewCardState,
    addNewCardErrorMessage,
    getPaymentMethodsState,
    listOfPaymentMethods,
    getPaymentMethodsErrorMessage,
    selectedPaymentMethod,
    changeSelectedPaymentMethodState,
    changeSelectedPaymentMethodErrorMessage,
    placeOrderState,
    placeOrderErrorMessage
  ];
}
