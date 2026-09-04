import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductSkeleton extends StatelessWidget {
  const ProductSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Skeletonizer(
      enabled: true,
      effect: isDark
          ? const ShimmerEffect(
              baseColor: AppColors.darkSurfaceVariant,
              highlightColor: AppColors.darkBorder,
            )
          : null,
      child: Card(
        color: theme.cardTheme.color,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),

              Gap(10.h),

              // Product name
              Container(
                width: 120.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),

              Gap(6.h),

              // Description
              Container(
                width: double.infinity,
                height: 10.h,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),

              Gap(4.h),

              Container(
                width: 80.w,
                height: 10.h,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),

              Gap(6.h),
            ],
          ),
        ),
      ),
    );
  }
}
