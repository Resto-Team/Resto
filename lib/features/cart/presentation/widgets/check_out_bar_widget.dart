import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/helpers/extensions.dart';
import 'package:resto/core/routing/routes.dart';
import 'package:resto/core/theme/app_colors.dart';

class CheckOutBarWidget extends StatelessWidget {
  const CheckOutBarWidget({
    super.key,
    required this.context,
    required this.itemCount,
    required this.totalPrice,
  });

  final BuildContext context;
  final int itemCount;
  final num totalPrice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 80.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total ($itemCount items)',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : Colors.grey.shade600,
                ),
              ),
              Gap(4.h),
              Text(
                '$totalPrice EGP',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.primaryLight
                      : AppColors.primaryColor,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // showAnimatedSnackbar(
              //   context,
              //   message: 'Checkout completed successfully!',
              //   type: AnimatedSnackBarType.success,
              // );
              context.pushNamed(Routes.checkoutView, arguments: totalPrice);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'Checkout',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
