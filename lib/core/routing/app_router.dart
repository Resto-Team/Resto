import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resto/core/di/di.dart';
import 'package:resto/core/routing/fade_page_route.dart';
import 'package:resto/features/auth/presentation/manager/login/login_cubit.dart';
import 'package:resto/features/auth/presentation/manager/register/register_cubit.dart';
import 'package:resto/features/auth/presentation/manager/session/session_cubit.dart';
import 'package:resto/features/auth/presentation/views/login_view.dart';
import 'package:resto/features/auth/presentation/views/register_view.dart';
import 'package:resto/features/cart/presentation/views/cart_view.dart';
import 'package:resto/features/cart/presentation/views/checkout_view.dart';
import 'package:resto/features/cart/presentation/manager/cubit/cart_cubit.dart';
import 'package:resto/features/home/domain/entities/product_entity.dart';
import 'package:resto/features/home/presentation/views/home_view.dart';
import 'package:resto/features/home/presentation/views/product_details_view.dart';
import 'package:resto/features/profile/presentation/views/profile_view.dart';
import 'package:resto/root_view.dart';

import 'routes.dart';

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginView:
        return FadeSlidePageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const LoginView(),
          ),
        );
      case Routes.registerView:
        return FadeSlidePageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (context) => getIt<RegisterCubit>(),
            child: const RegisterView(),
          ),
        );
      case Routes.homeView:
        return FadeSlidePageRoute(
          settings: settings,
          builder: (_) => const HomeView(),
        );
      case Routes.productDetailsView:
        final product = settings.arguments as ProductEntity;
        // CupertinoPageRoute (not our custom FadeSlidePageRoute) so the
        // native iOS edge-swipe-to-pop gesture works here.
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => BlocProvider.value(
            value: getIt<CartCubit>(),
            child: ProductDetailsView(product: product),
          ),
        );
      case Routes.cartView:
        return FadeSlidePageRoute(
          settings: settings,
          builder: (_) => const CartView(),
        );
      case Routes.profileView:
        return FadeSlidePageRoute(
          settings: settings,
          builder: (_) => const ProfileView(),
        );
      case Routes.checkoutView:
        final totalPrice = settings.arguments as num;
        return FadeSlidePageRoute(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<CartCubit>()),
              BlocProvider.value(value: getIt<SessionCubit>()..loadSession()),
            ],
            child: CheckoutScreen(totalPrice: totalPrice),
          ),
        );
      case Routes.rootView:
        return FadeSlidePageRoute(
          settings: settings,
          builder: (_) => const RootView(),
        );

      default:
        return FadeSlidePageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for "${settings.name}"'),
            ),
          ),
        );
    }
  }
}
