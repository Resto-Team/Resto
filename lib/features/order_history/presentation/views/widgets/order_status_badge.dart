import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:resto/core/localization/app_strings.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'package:resto/core/widgets/custom_text.dart';
import 'package:resto/features/order_history/domain/entities/order_entity.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({super.key, required this.status});

  final OrderStatus status;

  (String, Color) _getLabelAndColor(BuildContext context) {
    switch (status) {
      case OrderStatus.delivered:
        return (context.strings.statusDelivered, AppColors.success);
      case OrderStatus.pending:
        return (context.strings.statusPending, AppColors.warning);
      case OrderStatus.preparing:
        return (context.strings.statusPreparing, AppColors.info);
      case OrderStatus.outForDelivery:
        return (context.strings.statusOutForDelivery, AppColors.amberAccent);
      case OrderStatus.cancelled:
        return (context.strings.statusCancelled, AppColors.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (label, color) = _getLabelAndColor(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        text: label,
        size: 10.sp,
        weight: FontWeight.w700,
        color: color,
        maxLines: 1,
      ),
    );
  }
}
