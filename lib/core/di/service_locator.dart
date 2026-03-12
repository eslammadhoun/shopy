import 'package:cloud_functions/cloud_functions.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopy/core/session/data/repos/session_repo_imp.dart';
import 'package:shopy/core/session/domain/repos/session_repo.dart';
import 'package:shopy/core/session/domain/usecases/check_auth.dart';
import 'package:shopy/core/session/domain/usecases/set_auth_usecase.dart';
import 'package:shopy/features/Order/data/datasources/orders_firebase_datasource.dart';
import 'package:shopy/features/Order/data/repositores/orders_firebase_repo_impl.dart';
import 'package:shopy/features/Order/domain/repositories/orders_firebase_repository.dart';
import 'package:shopy/features/Order/domain/usecases/get_orders.dart';
import 'package:shopy/features/Order/presentation/cubit/orders_cubit.dart';
import 'package:shopy/features/auth/Data/data_sources/api_auth_service.dart';
import 'package:shopy/features/auth/Data/data_sources/firebase_auth_service.dart';
import 'package:shopy/features/auth/Data/repos/api_repo_imp.dart';
import 'package:shopy/features/auth/Data/repos/auth_repo_imp.dart';
import 'package:shopy/features/auth/Domain/repos/api_repository.dart';
import 'package:shopy/features/auth/Domain/repos/auth_repository.dart';
import 'package:shopy/features/auth/Domain/use_cases/change_password.dart';
import 'package:shopy/features/auth/Domain/use_cases/login_usecase.dart';
import 'package:shopy/features/auth/Domain/use_cases/login_with_facebook.dart';
import 'package:shopy/features/auth/Domain/use_cases/login_with_google_usecase.dart';
import 'package:shopy/features/auth/Domain/use_cases/send_otp_code.dart';
import 'package:shopy/features/auth/Domain/use_cases/signup_usecase.dart';
import 'package:shopy/features/auth/Domain/use_cases/verify_otp.dart';
import 'package:shopy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shopy/core/session/data/data_sources/login_shared_state.dart';
import 'package:shopy/features/checkout/Data/Data_Sources/checkout_firebase_datasource.dart';
import 'package:shopy/features/checkout/Data/Data_Sources/geolocator_datasource.dart';
import 'package:shopy/features/checkout/Data/Data_Sources/stripe_datasource.dart';
import 'package:shopy/features/checkout/Data/Repositores/checkout_firebase_repo_imp.dart';
import 'package:shopy/features/checkout/Data/Repositores/geolocator_repo_imp.dart';
import 'package:shopy/features/checkout/Data/Repositores/mock_geolocator_repo_imp.dart';
import 'package:shopy/features/checkout/Data/Repositores/stripe_repository_imp.dart';
import 'package:shopy/features/checkout/Domain/Usecases/add_card_usecase.dart';
import 'package:shopy/features/checkout/Domain/Usecases/add_new_delivery_address.dart';
import 'package:shopy/features/checkout/Domain/Usecases/change_selected_delivery_address.dart';
import 'package:shopy/features/checkout/Domain/Usecases/change_selected_payment_method.dart';
import 'package:shopy/features/checkout/Domain/Usecases/get_delivery_addresses.dart';
import 'package:shopy/features/checkout/Domain/Usecases/get_payment_methods.dart';
import 'package:shopy/features/checkout/Domain/Usecases/get_selected_delivery_address.dart';
import 'package:shopy/features/checkout/Domain/Usecases/get_selected_payment_method.dart';
import 'package:shopy/features/checkout/Domain/Usecases/get_user_location.dart';
import 'package:shopy/features/checkout/Domain/repositores/checkout_firebase_repository.dart';
import 'package:shopy/features/checkout/Domain/repositores/geolocator_repository.dart';
import 'package:shopy/features/checkout/Domain/repositores/stripe_repository.dart';
import 'package:shopy/features/home/Data/data_sources/firebase_datasource.dart';
import 'package:shopy/features/home/Data/repos/firebase_repo_imp.dart';
import 'package:shopy/features/home/Domain/repos/firebase_repository.dart';
import 'package:shopy/features/home/Domain/use_cases/add_new_rating.dart';
import 'package:shopy/features/home/Domain/use_cases/add_to_recent_searches.dart';
import 'package:shopy/features/home/Domain/use_cases/check_if_product_in_cart.dart';
import 'package:shopy/features/home/Domain/use_cases/checkout_usecases/place_order.dart';
import 'package:shopy/features/home/Domain/use_cases/deincrement_quantity.dart';
import 'package:shopy/features/home/Domain/use_cases/delete_history.dart';
import 'package:shopy/features/home/Domain/use_cases/delete_search_case.dart';
import 'package:shopy/features/home/Domain/use_cases/get_cart_products.dart';
import 'package:shopy/features/home/Domain/use_cases/get_product_reviews_summery.dart';
import 'package:shopy/features/home/Domain/use_cases/get_products.dart';
import 'package:shopy/features/home/Domain/use_cases/get_quantity.dart';
import 'package:shopy/features/home/Domain/use_cases/get_recent_searches.dart';
import 'package:shopy/features/home/Domain/use_cases/get_reviews.dart';
import 'package:shopy/features/home/Domain/use_cases/get_saved_products.dart';
import 'package:shopy/features/home/Domain/use_cases/get_user_name.dart';
import 'package:shopy/features/home/Domain/use_cases/increment_quantity.dart';
import 'package:shopy/features/home/Domain/use_cases/logout_usecase.dart';
import 'package:shopy/features/home/Domain/use_cases/search_usecase.dart';
import 'package:shopy/features/home/Domain/use_cases/toggle_adding_to_cart.dart';
import 'package:shopy/features/home/Domain/use_cases/toggle_favourite_state.dart';
import 'package:shopy/features/home/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:shopy/features/checkout/Presentation/Cubit/checkout_cubit/checkout_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/product_details_cubit/product_details_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/saved_cubit/saved_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/search_cubit/search_cubit.dart';
import 'package:shopy/features/welcome/presentation/cubit/splash_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDI() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Register Core DI
  sl.registerLazySingleton<SessionRepo>(
    () => SessionRepoImp(loginSharedState: sl<LoginSharedState>()),
  );

  // Register External Sources
  sl.registerLazySingleton<FirebaseFunctions>(
    () => FirebaseFunctions.instanceFor(region: 'us-central1'),
  );

  // Register Services & datasources
  sl.registerLazySingleton<LoginSharedState>(() => LoginSharedState(prefs));
  sl.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService(cloudFunctions: sl<FirebaseFunctions>()));
  sl.registerLazySingleton<ApiAuthService>(() => ApiAuthService());
  sl.registerLazySingleton<FirebaseDatasource>(() => FirebaseDatasource());
  sl.registerLazySingleton<GeolocatorDatasource>(() => GeolocatorDatasource());
  sl.registerLazySingleton<CheckoutFirebaseDatasource>(
    () => CheckoutFirebaseDatasource(functions: sl<FirebaseFunctions>()),
  );
  sl.registerLazySingleton<StripeDatasource>(
    () => StripeDatasource(functions: sl<FirebaseFunctions>()),
  );
  sl.registerLazySingleton<OrdersFirebaseDatasource>(() => OrdersFirebaseDatasource());

  // Register Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImp(sl<FirebaseAuthService>()),
  );
  sl.registerLazySingleton<ApiRepository>(
    () => ApiRepoImp(apiAuthService: sl<ApiAuthService>()),
  );
  sl.registerLazySingleton<FirebaseRepository>(
    () => FirebaseRepoImp(firebaseDatasource: sl<FirebaseDatasource>()),
  );
  sl.registerLazySingleton<GeolocatorRepository>(
    () => GeolocatorRepoImp(geolocatorDatasource: sl<GeolocatorDatasource>()),
  );
  sl.registerLazySingleton<CheckoutFirebaseRepository>(
    () => CheckoutFirebaseRepoImp(
      firebaseDatasource: sl<CheckoutFirebaseDatasource>(),
    ),
  );
  sl.registerLazySingleton<StripeRepository>(
    () => StripeRepositoryImp(stripeDatasource: sl<StripeDatasource>()),
  );
  sl.registerLazySingleton<MockgeoLocatorRepoImp>(
    () => MockgeoLocatorRepoImp(),
  );
  sl.registerLazySingleton<OrdersFirebaseRepository>(
    () => OrdersFirebaseRepoImpl(firebaseDatasource: sl<OrdersFirebaseDatasource>())
  );

  // Register Use-cases
  sl.registerLazySingleton<CheckAuth>(
    () => CheckAuth(sessionRepo: sl<SessionRepo>()),
  );
  sl.registerLazySingleton<SetAuthUsecase>(
    () => SetAuthUsecase(sessionRepo: sl<SessionRepo>()),
  );
  sl.registerLazySingleton<SignupUsecase>(
    () => SignupUsecase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LoginWithGoogle>(
    () => LoginWithGoogle(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LoginWithFacebook>(
    () => LoginWithFacebook(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SendOtpCodeUsecase>(
    () => SendOtpCodeUsecase(apiRepository: sl<ApiRepository>()),
  );
  sl.registerLazySingleton<VerifyOtp>(
    () => VerifyOtp(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ChangePassword>(
    () => ChangePassword(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetProducts>(
    () => GetProducts(firebaseRepository: sl<FirebaseRepository>()),
  );
  sl.registerLazySingleton<ToggleFavouriteState>(
    () => ToggleFavouriteState(firebaseRepository: sl<FirebaseRepository>()),
  );
  sl.registerLazySingleton<SearchUsecase>(
    () => SearchUsecase(firebaseRepository: sl<FirebaseRepository>()),
  );
  sl.registerLazySingleton<AddToRecentSearches>(
    () => AddToRecentSearches(firebaseRepository: sl<FirebaseRepository>()),
  );
  sl.registerLazySingleton<GetRecentSearches>(
    () => GetRecentSearches(firebaseRepository: sl<FirebaseRepository>()),
  );
  sl.registerLazySingleton<DeleteSearchCase>(
    () => DeleteSearchCase(firebaseRepository: sl<FirebaseRepository>()),
  );
  sl.registerLazySingleton<DeleteSearchHistory>(
    () => DeleteSearchHistory(firebaseRepository: sl<FirebaseRepository>()),
  );
  sl.registerLazySingleton<GetSavedProducts>(
    () => GetSavedProducts(firebaseRepository: sl<FirebaseRepository>()),
  );
  sl.registerLazySingleton<GetReviews>(
    () => GetReviews(firebaseRepository: sl<FirebaseRepository>()),
  );
  sl.registerLazySingleton<AddNewRating>(
    () => AddNewRating(firebaseRepository: sl<FirebaseRepository>()),
  );
  sl.registerLazySingleton<GetUserName>(
    () => GetUserName(firebaseRepository: sl<FirebaseRepository>()),
  );
  sl.registerLazySingleton<GetProductReviewsSummery>(
    () =>
        GetProductReviewsSummery(firebaseRepository: sl<FirebaseRepository>()),
  );
  sl.registerLazySingleton<GetCartProducts>(
    () => GetCartProducts(firebaseRepository: sl<FirebaseRepository>()),
  );
  sl.registerLazySingleton<ToggleAddingToCart>(
    () => ToggleAddingToCart(firebaseRepository: sl<FirebaseRepository>()),
  );
  sl.registerLazySingleton<CheckIfProductInCart>(
    () => CheckIfProductInCart(firebaseRepository: sl<FirebaseRepository>()),
  );
  sl.registerLazySingleton<IncrementQuantity>(
    () => IncrementQuantity(firebaseRepository: sl<FirebaseRepository>()),
  );
  sl.registerLazySingleton<DeincrementQuantity>(
    () => DeincrementQuantity(firebaseRepository: sl<FirebaseRepository>()),
  );
  sl.registerLazySingleton<GetQuantity>(
    () => GetQuantity(firebaseRepository: sl<FirebaseRepository>()),
  );
  sl.registerLazySingleton<GetUserLocation>(
    () => GetUserLocation(geolocatorRepository: sl<MockgeoLocatorRepoImp>()),
  );
  sl.registerLazySingleton<AddNewDeliveryAddress>(
    () => AddNewDeliveryAddress(
      checkoutFirebaseRepository: sl<CheckoutFirebaseRepository>(),
    ),
  );
  sl.registerLazySingleton<GetDeliveryAddresses>(
    () => GetDeliveryAddresses(
      checkoutFirebaseRepository: sl<CheckoutFirebaseRepository>(),
    ),
  );
  sl.registerLazySingleton<GetSelectedDeliveryAddress>(
    () => GetSelectedDeliveryAddress(
      checkoutFirebaseRepository: sl<CheckoutFirebaseRepository>(),
    ),
  );
  sl.registerLazySingleton<ChangeSelectedDeliveryAddress>(
    () => ChangeSelectedDeliveryAddress(
      checkoutFirebaseRepository: sl<CheckoutFirebaseRepository>(),
    ),
  );
  sl.registerLazySingleton<AddCardUsecase>(
    () => AddCardUsecase(stripeRepository: sl<StripeRepository>()),
  );
  sl.registerLazySingleton<GetPaymentMethods>(
    () => GetPaymentMethods(
      checkoutFirebaseRepository: sl<CheckoutFirebaseRepository>(),
    ),
  );
  sl.registerLazySingleton<ChangeSelectedPaymentMethod>(
    () => ChangeSelectedPaymentMethod(
      checkoutFirebaseRepository: sl<CheckoutFirebaseRepository>(),
    ),
  );
  sl.registerLazySingleton<GetSelectedPaymentMethod>(
    () => GetSelectedPaymentMethod(
      checkoutFirebaseRepository: sl<CheckoutFirebaseRepository>(),
    ),
  );
  sl.registerLazySingleton<LogoutUsecase>(
    () => LogoutUsecase(firebaseRepository: sl<FirebaseRepository>()),
  );
  sl.registerLazySingleton<PlaceOrder>(
    () => PlaceOrder(stripeRepository: sl<StripeRepository>()),
  );
  sl.registerLazySingleton<GetOrders>(
    () => GetOrders(firebaseRepository: sl<OrdersFirebaseRepository>()),
  );

  // Register Cubits
  sl.registerFactory(() => SplashCubit(checkAuth: sl<CheckAuth>()));
  sl.registerFactory(
    () => AuthCubit(
      loginUsecase: sl<LoginUsecase>(),
      checkAuth: sl<CheckAuth>(),
      signupUsecase: sl<SignupUsecase>(),
      setAuthState: sl<SetAuthUsecase>(),
      loginWithGoogleUsecase: sl<LoginWithGoogle>(),
      loginWithFacebookUsecase: sl<LoginWithFacebook>(),
      sendOtpCodeUsecase: sl<SendOtpCodeUsecase>(),
      verifyOtpuseCase: sl<VerifyOtp>(),
      changePassworduseCase: sl<ChangePassword>(),
    ),
  );
  sl.registerFactory<HomeCubit>(
    () => HomeCubit(
      getProductsUsecase: sl<GetProducts>(),
      toggleFavouriteStateUsecase: sl<ToggleFavouriteState>(),
      logoutUsecase: sl<LogoutUsecase>(),
      setAuthStateUsecase: sl<SetAuthUsecase>(),
    ),
  );
  sl.registerFactory<SearchCubit>(
    () => SearchCubit(
      searchUsecase: sl<SearchUsecase>(),
      addToRecentSearchesUsecase: sl<AddToRecentSearches>(),
      getRecentSearchesUsecase: sl<GetRecentSearches>(),
      deleteSearchCaseUsecase: sl<DeleteSearchCase>(),
      deleteSearchHistoryUsecase: sl<DeleteSearchHistory>(),
    ),
  );
  sl.registerFactory<SavedCubit>(
    () => SavedCubit(getSavedProductsUsecase: sl<GetSavedProducts>()),
  );
  sl.registerFactory<ProductDetailsCubit>(
    () => ProductDetailsCubit(
      getReviewsUsecase: sl<GetReviews>(),
      addNewRatingUsecase: sl<AddNewRating>(),
      getUserNameUsecase: sl<GetUserName>(),
      getProductReviewsSummeryUsecase: sl<GetProductReviewsSummery>(),
      checkIfProductInCartUsecase: sl<CheckIfProductInCart>(),
    ),
  );
  sl.registerFactory<CartCubit>(
    () => CartCubit(
      getCartProductsUsecase: sl<GetCartProducts>(),
      toggleAddingToCartUsecase: sl<ToggleAddingToCart>(),
      incrementQuantityUsecase: sl<IncrementQuantity>(),
      deincrementQuantityUsecase: sl<DeincrementQuantity>(),
      getProductQuantityUsecase: sl<GetQuantity>(),
    ),
  );
  sl.registerFactory<CheckoutCubit>(
    () => CheckoutCubit(
      getUserLocationUsecase: sl<GetUserLocation>(),
      addNewDeliveryAddressUsecase: sl<AddNewDeliveryAddress>(),
      getDeliveryAddressesUsecase: sl<GetDeliveryAddresses>(),
      getSelectedDeliveryAddressUsecase: sl<GetSelectedDeliveryAddress>(),
      changeSelectedDeliveryAddressUsecase: sl<ChangeSelectedDeliveryAddress>(),
      addCardUsecase: sl<AddCardUsecase>(),
      getPaymentMethodsUsecase: sl<GetPaymentMethods>(),
      changeSelectedPaymentMethodUsecase: sl<ChangeSelectedPaymentMethod>(),
      getSelectedPaymentMethodUsecase: sl<GetSelectedPaymentMethod>(),
      placeOrderUsecase: sl<PlaceOrder>(),
    ),
  );
  sl.registerFactory<OrdersCubit>(
    () => OrdersCubit(getOrdersUsecase: sl<GetOrders>()),
  );
}
