import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/di/di.dart';
import 'package:resto/core/functions/app_snack_bar.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'package:resto/features/cart/domain/entities/cart_entity.dart';
import 'package:resto/features/cart/presentation/manager/cubit/cart_cubit.dart';
import 'package:resto/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:resto/features/cart/presentation/widgets/cart_skeleton.dart';
import 'package:resto/features/cart/presentation/widgets/check_out_bar_widget.dart';
import 'package:resto/features/cart/presentation/widgets/empty_cart_message.dart';
import 'package:resto/features/cart/presentation/widgets/error_cart_widget.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<CartCubit>(),
      child: const CartViewBody(),
    );
  }
}

class CartViewBody extends StatefulWidget {
  const CartViewBody({super.key});

  @override
  State<CartViewBody> createState() => _CartViewBodyState();
}

class _CartViewBodyState extends State<CartViewBody> {
  CartEntity? _currentCart;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<CartCubit>();
    _currentCart = cubit.currentCart;
    cubit.getMyCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.alphaBlend(
        AppColors.primaryColor.withValues(alpha: 0.05),
        Colors.white,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Cart',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<CartCubit>().clearCart();
            },
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
            ),
            tooltip: 'Clear Cart',
          ),
        ],
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is GetCartSuccessState) {
            _currentCart = state.cart;
          } else if (state is UpdateCartItemSuccessState) {
            _currentCart = state.cart;
          } else if (state is RemoveItemFromCartSuccessState) {
            _currentCart = state.cart;
          } else if (state is AddItemToCartSuccessState) {
            _currentCart = state.cart;
          } else if (state is ClearCartSuccessState) {
            _currentCart = state.cart;
          } else if (state is UpdateCartItemErrorState) {
            showAnimatedSnackbar(
              context,
              message: state.error,
              type: AnimatedSnackBarType.error,
            );
          } else if (state is RemoveItemFromCartErrorState) {
            showAnimatedSnackbar(
              context,
              message: state.error,
              type: AnimatedSnackBarType.error,
            );
          } else if (state is AddItemToCartErrorState) {
            showAnimatedSnackbar(
              context,
              message: state.error,
              type: AnimatedSnackBarType.error,
            );
          } else if (state is ClearCartErrorState) {
            showAnimatedSnackbar(
              context,
              message: state.error,
              type: AnimatedSnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          if ((state is GetCartLoadingState || state is CartInitial) &&
              _currentCart == null) {
            return const CartSkeleton();
          }

          if (state is GetCartErrorState && _currentCart == null) {
            return ErrorCartWidget(errorMessage: state.error);
          }

          CartEntity? cart = _currentCart;
          if (state is GetCartSuccessState) {
            cart = state.cart;
            _currentCart = state.cart;
          } else if (state is UpdateCartItemSuccessState) {
            cart = state.cart;
            _currentCart = state.cart;
          } else if (state is RemoveItemFromCartSuccessState) {
            cart = state.cart;
            _currentCart = state.cart;
          } else if (state is AddItemToCartSuccessState) {
            cart = state.cart;
            _currentCart = state.cart;
          } else if (state is ClearCartSuccessState) {
            cart = state.cart;
            _currentCart = state.cart;
          }

          final items = cart?.items ?? [];

          if (state is GetCartLoadingState && items.isEmpty) {
            return const CartSkeleton();
          }

          if (items.isEmpty) {
            return const EmptyCartMessage();
          }

          // Calculate total price
          final totalPrice = items.fold<num>(
            0,
            (sum, item) =>
                sum +
                ((item.price ?? item.product?.price ?? 0) *
                    (item.quantity ?? 1)),
          );

          final isActionLoading =
              state is UpdateCartItemLoadingState ||
              state is RemoveItemFromCartLoadingState ||
              state is ClearCartLoadingState;

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      color: AppColors.primaryColor,
                      onRefresh: () => context.read<CartCubit>().getMyCart(),
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                        itemCount: items.length,
                        separatorBuilder: (context, index) => Gap(12.h),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final product = item.product;
                          final targetId =
                              (item.id != null && item.id!.isNotEmpty)
                              ? item.id!
                              : (item.productId ?? product?.id ?? '');
                          final currentQty = item.quantity ?? 1;

                          return CartItemCard(
                            title: product?.name ?? 'Food Item',
                            subtitle: product?.description ?? '',
                            imageUrl: product?.image ?? '',
                            price: item.price ?? product?.price,
                            quantity: currentQty,
                            onIncrease: () {
                              if (targetId.isNotEmpty) {
                                context.read<CartCubit>().updateCartItem(
                                  targetId,
                                  currentQty + 1,
                                );
                              }
                            },
                            onDecrease: () {
                              if (targetId.isNotEmpty && currentQty > 1) {
                                context.read<CartCubit>().updateCartItem(
                                  targetId,
                                  currentQty - 1,
                                );
                              }
                            },
                            onRemove: () {
                              if (targetId.isNotEmpty) {
                                context.read<CartCubit>().removeItemFromCart(
                                  targetId,
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  // Bottom Total and Checkout Bar
                  CheckOutBarWidget(
                    context: context,
                    itemCount: items.length,
                    totalPrice: totalPrice,
                  ),
                ],
              ),

              if (isActionLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.white.withValues(alpha: 0.35),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
