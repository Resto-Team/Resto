import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartSkeleton extends StatelessWidget {
  const CartSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = theme.cardTheme.color ??
        (isDark ? AppColors.darkSurface : Colors.white);
    final bottomBarBg = isDark ? AppColors.darkSurface : Colors.white;

    return Skeletonizer(
      enabled: true,
      effect: isDark
          ? const ShimmerEffect(
              baseColor: AppColors.darkSurfaceVariant,
              highlightColor: AppColors.darkBorder,
            )
          : null,
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              itemCount: 4,
              separatorBuilder: (context, index) => Gap(12.h),
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 75.w,
                        height: 75.h,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 140.w,
                              height: 14.h,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                            ),
                            Gap(6.h),
                            Container(
                              width: 180.w,
                              height: 11.h,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                            ),
                            Gap(8.h),
                            Container(
                              width: 70.w,
                              height: 13.h,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(8.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 22.r,
                            height: 22.r,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Gap(12.h),
                          Container(
                            width: 80.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Skeleton Bottom Bar
          Container(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 100.h),
            decoration: BoxDecoration(
              color: bottomBarBg,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 90.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    Gap(6.h),
                    Container(
                      width: 110.w,
                      height: 18.h,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 120.w,
                  height: 46.h,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
