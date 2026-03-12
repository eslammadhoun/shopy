import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopy/core/widgets/custom_bottom_nav_bar.dart';
import 'package:shopy/features/Order/presentation/screens/my_orders.dart';
import 'package:shopy/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/home_cubit/home_state.dart';
import 'package:shopy/features/home/presentation/screens/account_page.dart';
import 'package:shopy/features/home/presentation/screens/cart_page.dart';
import 'package:shopy/features/home/presentation/screens/faqs_page.dart';
import 'package:shopy/features/home/presentation/screens/help_center_page.dart';
import 'package:shopy/features/home/presentation/screens/home_page.dart';
import 'package:shopy/features/home/presentation/screens/my_details.dart';
import 'package:shopy/features/home/presentation/screens/notifications_page.dart';
import 'package:shopy/features/home/presentation/screens/saved_page.dart';
import 'package:shopy/features/home/presentation/screens/search_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static final List<Widget> _pages = <Widget>[
    HomePage(),
    SearchPage(),
    SavedPage(),
    CartPage(),
    AccountPage(),
    NotificationsPage(),
    MyOrders(),
    MyDetails(),
    FaqsPage(),
    HelpCenterPage()
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: CustomBottomNavBar(),
          body: IndexedStack(index: state.selectedPage, children: _pages),
        );
      },
    );
  }
}
