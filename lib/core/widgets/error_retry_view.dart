import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/localization/app_strings.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'package:resto/core/widgets/custom_button.dart';
import 'package:resto/core/widgets/custom_text.dart';

class ErrorRetryView extends StatelessWidget {
  const ErrorRetryView({
    super.key,
    required this.message,
    required this.onRetry,
    this.icon = Icons.wifi_off_rounded,
  });

  final String message;
  final VoidCallback onRetry;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: AppColors.lightTextMuted),
          Gap(12.h),
          CustomText(
            text: message,
            size: 14,
            weight: FontWeight.w500,
            color: AppColors.lightTextSecondary,
            maxLines: 3,
          ),
          Gap(4.h),
          CustomButton(
            text: context.strings.tryAgain,
            width: 160,
            height: 44,
            onTap: onRetry,
          ),
        ],
      ),
    );
  }
}
