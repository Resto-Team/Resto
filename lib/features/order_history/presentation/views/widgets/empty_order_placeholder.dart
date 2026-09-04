import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/localization/app_strings.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'package:resto/core/widgets/custom_text.dart';

class EmptyOrdersPlaceholder extends StatelessWidget {
  const EmptyOrdersPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 56.r,
            color: AppColors.lightTextMuted,
          ),
          Gap(12.h),
          CustomText(
            text: context.strings.noOrdersFound,
            size: 15.sp,
            weight: FontWeight.w600,
            color: AppColors.lightTextSecondary,
          ),
        ],
      ),
    );
  }
}
