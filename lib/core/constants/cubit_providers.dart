import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopy/core/di/service_locator.dart';
import 'package:shopy/features/Order/presentation/cubit/orders_cubit.dart';
import 'package:shopy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:shopy/features/checkout/Presentation/Cubit/checkout_cubit/checkout_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/product_details_cubit/product_details_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/saved_cubit/saved_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/search_cubit/search_cubit.dart';
import 'package:shopy/features/welcome/presentation/cubit/splash_cubit.dart';

List<BlocProvider> cubitProviders = [
  BlocProvider<SplashCubit>(
    create: (context) => sl<SplashCubit>()..getLoginState(),
  ),
  BlocProvider<AuthCubit>(create: (context) => sl<AuthCubit>()),
  BlocProvider<HomeCubit>(create: (context) => sl<HomeCubit>()),
  BlocProvider<SearchCubit>(create: (context) => sl<SearchCubit>()),
  BlocProvider<SavedCubit>(create: (context) => sl<SavedCubit>()),
  BlocProvider<ProductDetailsCubit>(
    create: (context) => sl<ProductDetailsCubit>(),
  ),
  BlocProvider<CartCubit>(
    create: (context) => sl<CartCubit>()..getCartProducts(),
  ),
  BlocProvider<CheckoutCubit>(create: (context) => sl<CheckoutCubit>()),
  BlocProvider<OrdersCubit>(create: (context) => sl<OrdersCubit>())
];
