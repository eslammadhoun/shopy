import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/global_button.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/core/widgets/popup_message.dart';
import 'package:shopy/core/widgets/title_section.dart';
import 'package:shopy/features/auth/presentation/widgets/text_field.dart';
import 'package:shopy/features/checkout/Domain/Entites/delivery_address.dart';
import 'package:shopy/features/checkout/Presentation/Cubit/checkout_cubit/checkout_cubit.dart';
import 'package:shopy/features/checkout/Presentation/Cubit/checkout_cubit/checkout_state.dart';

class NewAddressPage extends StatefulWidget {
  const NewAddressPage({super.key});

  @override
  State<NewAddressPage> createState() => _NewAddressPageState();
}

class _NewAddressPageState extends State<NewAddressPage> {
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController fullAddressController = TextEditingController();

  BitmapDescriptor? customMarker;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((duration) async {
      await _loadMarker();
      if (mounted) {
        await context.read<CheckoutCubit>().getUserLocation();
      }
    });
  }

  Future<void> _loadMarker() async {
    if (customMarker != null) return;
    customMarker = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'lib/assets/icons/location-pin-png.png',
    );
    print('Custom marker loaded successfully');
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    nicknameController.dispose();
    fullAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CheckoutCubit, CheckoutState>(
        buildWhen: (prev, curr) =>
            prev.getUserLocationState != curr.getUserLocationState ||
            prev.userLocationLatLng != curr.userLocationLatLng ||
            prev.userLoactionErrorMessage != curr.userLoactionErrorMessage ||
            prev.sheetSize != curr.sheetSize,
        builder: (BuildContext context, state) {
          return SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: TitleSection(title: 'New Address'),
                ),
                SizedBox(height: 20),
                Container(
                  height: 1,
                  decoration: BoxDecoration(color: AppColors.primary100Color),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height:
                            MediaQuery.of(context).size.height *
                            (1 - state.sheetSize + 0.05),
                        child:
                            state.getUserLocationState ==
                                    GetUserLocationState.loading ||
                                state.userLocationLatLng == LatLng(0.0, 0.0)
                            ? Center(
                                child: AppLoadingIndicator(
                                  size: 60,
                                  strokeWidth: 8,
                                ),
                              )
                            : _buildMapWidget(
                                lat: state.userLocationLatLng.latitude,
                                long: state.userLocationLatLng.longitude,
                                markerIcon:
                                    customMarker ??
                                    BitmapDescriptor.defaultMarker,
                              ),
                      ),
                      _buildPersistentSheet(context),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // build map widget
  Widget _buildMapWidget({
    required double lat,
    required double long,
    required BitmapDescriptor markerIcon,
  }) {
    return GoogleMap(
      key: ValueKey(markerIcon.hashCode),
      compassEnabled: false,
      myLocationButtonEnabled: false,
      buildingsEnabled: false,
      initialCameraPosition: CameraPosition(
        target: LatLng(lat, long),
        zoom: 16,
      ),
      style: AppColors.lightMapStyle,
      markers: {
        Marker(
          icon: markerIcon,
          markerId: MarkerId('$lat, $long'),
          position: LatLng(lat, long),
        ),
      },
    );
  }

  // build new Address Form
  Widget _buildPersistentSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.5,
      minChildSize: 0.1,
      builder: (context, controller) =>
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              context.read<CheckoutCubit>().changeSheetSize(
                sheetSize: notification.extent,
              );
              return true;
            },
            child: BlocConsumer<CheckoutCubit, CheckoutState>(
              buildWhen: (prev, curr) =>
                  prev.sheetSize != curr.sheetSize ||
                  prev.addressMarkAsDefault != curr.addressMarkAsDefault ||
                  prev.addButtonEnabled != curr.addButtonEnabled ||
                  prev.addingNewDeliveryAddresState !=
                      curr.addingNewDeliveryAddresState ||
                  prev.addNewDeliveryAddressErrorMessage !=
                      curr.addNewDeliveryAddressErrorMessage,
              listenWhen: (previous, current) =>
                  previous.addingNewDeliveryAddresState !=
                  current.addingNewDeliveryAddresState,
              listener: (BuildContext context, state) {
                if (state.addingNewDeliveryAddresState ==
                    AddingNewDeliveryAddresState.error) {
                  showDialog(
                    context: context,
                    builder: (context) => PopupMessage(
                      popupState: PopupState.error,
                      onTap: () => Navigator.pop(context),
                      title: 'Only one Default Address!',
                      description: state.addNewDeliveryAddressErrorMessage!,
                      buttonText: 'Try Again',
                    ),
                  );
                } else if (state.addingNewDeliveryAddresState ==
                    AddingNewDeliveryAddresState.success) {
                  showDialog(
                    context: context,
                    builder: (context) => PopupMessage(
                      popupState: PopupState.success,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(
                          context,
                        ).pushNamed('/delivery_address_page');
                      },
                      title: 'Congratulations!',
                      description: 'Your new address has been added.',
                      buttonText: 'Thanks',
                    ),
                  );
                }
              },
              builder: (BuildContext context, state) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: 64,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.primary100Color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          controller: controller,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 14),
                                  Text(
                                    'Address',
                                    style: AppTextStyle.h4SemiBold,
                                  ),
                                  const SizedBox(height: 14),
                                  Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary100Color,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    'Address Nickname',
                                    style: AppTextStyle.b1SemiBold,
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextField(
                                    controller: nicknameController,
                                    obscureText: false,
                                    hintText: 'Choos One',
                                    showError: false,
                                    showSuccess: false,
                                    autoFocusField: false,
                                    textAlign: TextAlign.left,
                                    onChanged: (val) {
                                      context
                                          .read<CheckoutCubit>()
                                          .validateAddressForm(
                                            nickname: val,
                                            fullAddress:
                                                fullAddressController.text,
                                          );
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Full Address',
                                    style: AppTextStyle.b1SemiBold,
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextField(
                                    controller: fullAddressController,
                                    obscureText: false,
                                    hintText: 'Enter your full address...',
                                    showError: false,
                                    showSuccess: false,
                                    autoFocusField: false,
                                    textAlign: TextAlign.left,
                                    onChanged: (val) {
                                      context
                                          .read<CheckoutCubit>()
                                          .validateAddressForm(
                                            nickname: nicknameController.text,
                                            fullAddress: val,
                                          );
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () => context
                                            .read<CheckoutCubit>()
                                            .toggleMarkAsDefault(),
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: state.addressMarkAsDefault
                                                ? AppColors.primary900Color
                                                : null,
                                            border: Border.all(
                                              color: state.addressMarkAsDefault
                                                  ? AppColors.primary900Color
                                                  : AppColors.primary200Color,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: state.addressMarkAsDefault
                                              ? Center(
                                                  child: Icon(
                                                    Icons.check,
                                                    color: AppColors.background,
                                                    size: 14,
                                                  ),
                                                )
                                              : null,
                                        ),
                                      ),

                                      const SizedBox(width: 10),
                                      Text(
                                        'Make this as a default address',
                                        style: AppTextStyle.b1Regular.copyWith(
                                          color: AppColors.primary500Color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (state.sheetSize > 0.2)
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: state.sheetSize > 0.2 ? 1 : 0,
                          child: AnimatedSlide(
                            duration: const Duration(milliseconds: 200),
                            offset: state.sheetSize > 0.2
                                ? Offset.zero
                                : Offset(0, 0.2),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                12,
                                24,
                                20,
                              ),
                              child: GlobalButton(
                                backgroundColor: state.addButtonEnabled
                                    ? AppColors.primary900Color
                                    : AppColors.primary200Color,
                                border: Border.all(
                                  color: state.addButtonEnabled
                                      ? AppColors.primary900Color
                                      : AppColors.primary200Color,
                                ),
                                onTap: state.addButtonEnabled
                                    ? () {
                                        final DeliveryAddress
                                        newDeliveryAddress = DeliveryAddress(
                                          id: '',
                                          nickname: nicknameController.text,
                                          fullAddress:
                                              fullAddressController.text,
                                          isDefault: state.addressMarkAsDefault,
                                          lat:
                                              state.userLocationLatLng.latitude,
                                          long: state
                                              .userLocationLatLng
                                              .longitude,
                                          createdAt: Timestamp.now(),
                                        );
                                        context
                                            .read<CheckoutCubit>()
                                            .addNewDeliveryAddress(
                                              deliveryAddress:
                                                  newDeliveryAddress,
                                            );
                                        nicknameController.clear();
                                        fullAddressController.clear();
                                      }
                                    : null,
                                child:
                                    state.addingNewDeliveryAddresState ==
                                        AddingNewDeliveryAddresState.loading
                                    ? AppLoadingIndicator(
                                        size: 40,
                                        strokeWidth: 5,
                                      )
                                    : Text(
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
                  ),
                );
              },
            ),
          ),
    );
  }
}
