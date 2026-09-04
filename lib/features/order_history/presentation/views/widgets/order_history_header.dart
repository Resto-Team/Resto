import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/localization/app_strings.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'package:resto/core/widgets/custom_text.dart';

class OrderHistoryHeader extends StatelessWidget {
  const OrderHistoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: context.strings.orderHistory,
            size: 26.sp,
            weight: FontWeight.w700,
            color: AppColors.primaryColor,
            maxLines: 1,
          ),
          Gap(6.h),
          CustomText(
            text: context.strings.orderHistorySubtitle,
            size: 13.sp,
            weight: FontWeight.w400,
            color: AppColors.lightTextSecondary,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
