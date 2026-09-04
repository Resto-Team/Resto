import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:glass_bottom_navigation/nav_style.dart';
import 'package:resto/core/di/di.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'package:resto/features/auth/presentation/manager/session/session_cubit.dart';
import 'package:resto/features/cart/presentation/views/cart_view.dart';
import 'package:resto/features/cart/presentation/manager/cubit/cart_cubit.dart';
import 'package:resto/features/home/presentation/views/home_view.dart';
import 'package:resto/features/order_history/presentation/manager/cubit/order_history_cubit.dart';
import 'package:resto/features/order_history/presentation/views/order_history_view.dart';
import 'package:resto/features/profile/presentation/views/profile_view.dart';

const int _cartTabIndex = 1;
const int _historyTabIndex = 2;

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> with TickerProviderStateMixin {
  late final List<Widget> screens;
  late final List<AnimationController> iconControllers;

  int currentScreen = 0;

  @override
  void initState() {
    super.initState();

    screens = [
      const HomeView(),
      const CartView(),
      const OrderHistoryView(),
      ProfileView(onOrdersTap: () => _onTabTapped(_historyTabIndex)),
    ];

    iconControllers = List.generate(
      screens.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );

    iconControllers[currentScreen].forward();

    getIt<SessionCubit>().loadSession();
  }

  @override
  void dispose() {
    for (final controller in iconControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == currentScreen) return;

    iconControllers[currentScreen].reverse();

    setState(() {
      currentScreen = index;
    });

    iconControllers[index].forward();

    if (index == _cartTabIndex) {
      getIt<CartCubit>().getMyCart();
    }

    if (index == _historyTabIndex) {
      getIt<OrderHistoryCubit>().getMyOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SessionCubit>(),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          extendBody: true,

          body: IndexedStack(index: currentScreen, children: screens),

          bottomNavigationBar: defaultTargetPlatform == TargetPlatform.iOS
              ? buildIOSNavigation()
              : buildAndroidNavigation(),
        ),
      ),
    );
  }

  Widget buildIOSNavigation() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GlassBottomBar(
      items: const [
        GlassBarItem(
          icon: Icons.home_rounded,
          label: 'Home',
          nativeSymbolName: 'house.fill',
        ),
        GlassBarItem(
          icon: Icons.shopping_cart_rounded,
          label: 'Cart',
          nativeSymbolName: 'cart.fill',
        ),
        GlassBarItem(
          icon: Icons.history,
          label: 'My Orders',
          nativeSymbolName: 'clock.fill',
        ),
        GlassBarItem(
          icon: Icons.person_rounded,
          label: 'Profile',
          nativeSymbolName: 'person.fill',
        ),
      ],
      currentIndex: currentScreen,
      onTap: _onTabTapped,
      style: GlassBottomNavStyle(
        widthFactor: 1.0,
        height: 80.h,
        accent: isDark ? AppColors.primaryLight : AppColors.primaryColor,
      ),
    );
  }

  Widget buildAndroidNavigation() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _buildNavItem(
                  index: 0,
                  icon: Icons.home_rounded,
                  label: 'Home',
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  index: 1,
                  icon: Icons.shopping_cart_rounded,
                  label: 'Cart',
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  index: 2,
                  icon: Icons.history,
                  label: 'My Orders',
                ),
              ),
              Expanded(
                child: _buildNavItem(
                  index: 3,
                  icon: Icons.person_rounded,
                  label: 'Profile',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = currentScreen == index;

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 23.sp,
              color: isSelected ? Colors.white : Colors.white70,
            ),

            if (isSelected) ...[
              Gap(5.w),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
