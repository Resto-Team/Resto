import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/functions/app_snack_bar.dart';
import 'package:resto/core/localization/app_strings.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'package:resto/core/widgets/custom_button.dart';
import 'package:resto/features/cart/presentation/manager/cubit/cart_cubit.dart';
import 'package:resto/features/home/domain/entities/product_entity.dart';

class ProductDetailsBottomBar extends StatefulWidget {
  const ProductDetailsBottomBar({
    super.key,
    required this.product,
  });

  final ProductEntity product;

  @override
  State<ProductDetailsBottomBar> createState() =>
      _ProductDetailsBottomBarState();
}

class _ProductDetailsBottomBarState extends State<ProductDetailsBottomBar> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final barBg = isDark ? AppColors.darkSurface : Colors.white;
    final primary = isDark ? AppColors.primaryLight : AppColors.primaryColor;
    final qtyBg = isDark
        ? AppColors.darkSurfaceVariant
        : AppColors.primaryColor.withValues(alpha: 0.08);
    final qtyTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.primaryColor;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: barBg,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Quantity selector
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: qtyBg,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 32.r,
                      minHeight: 32.r,
                    ),
                    icon: Icon(
                      Icons.remove,
                      size: 18.r,
                      color: _quantity > 1
                          ? primary
                          : (isDark ? AppColors.darkTextMuted : Colors.grey),
                    ),
                    onPressed: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      '$_quantity',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: qtyTextColor,
                      ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 32.r,
                      minHeight: 32.r,
                    ),
                    icon: Icon(
                      Icons.add,
                      size: 18.r,
                      color: primary,
                    ),
                    onPressed: () => setState(() => _quantity++),
                  ),
                ],
              ),
            ),

            Gap(12.w),

            // Add to Cart Button
            Expanded(
              child: BlocConsumer<CartCubit, CartState>(
                listener: (context, state) {
                  if (state is AddItemToCartSuccessState) {
                    showAnimatedSnackbar(
                      context,
                      message:
                          '${product.name ?? 'Item'} ${context.strings.addedToCartSuccess}',
                      type: AnimatedSnackBarType.success,
                    );
                  } else if (state is AddItemToCartErrorState) {
                    showAnimatedSnackbar(
                      context,
                      message: state.error,
                      type: AnimatedSnackBarType.error,
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading = state is AddItemToCartLoadingState;

                  return CustomButton(
                    text: isLoading ? context.strings.adding : context.strings.addToCart,
                    widget: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : null,
                    gap: isLoading ? 10 : 0,
                    onTap: isLoading
                        ? null
                        : () {
                            final productId = product.id;
                            if (productId != null && productId.isNotEmpty) {
                              context
                                  .read<CartCubit>()
                                  .addItemToCart(productId, _quantity);
                            } else {
                              showAnimatedSnackbar(
                                context,
                                message: context.strings.productIdMissing,
                                type: AnimatedSnackBarType.error,
                              );
                            }
                          },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
