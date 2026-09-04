import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'package:resto/core/widgets/custom_text.dart';
import 'package:resto/features/order_history/domain/entities/order_entity.dart';
import 'package:resto/features/order_history/presentation/views/widgets/order_action_button.dart';
import 'package:resto/features/order_history/presentation/views/widgets/order_format_utils.dart';
import 'package:resto/features/order_history/presentation/views/widgets/order_status_badge.dart';
import 'package:resto/features/order_history/presentation/views/widgets/strike_through_text.dart';

class OrderHistoryCard extends StatelessWidget {
  const OrderHistoryCard({
    super.key,
    required this.order,
    this.onDetails,
    this.onReorder,
    this.onHelp,
    this.onTrack,
  });

  final OrderEntity order;
  final VoidCallback? onDetails;
  final VoidCallback? onReorder;
  final VoidCallback? onHelp;
  final VoidCallback? onTrack;

  OrderStatus get status => order.status ?? OrderStatus.pending;
  bool get _isCancelled => status == OrderStatus.cancelled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = theme.cardTheme.color ??
        (isDark ? AppColors.darkSurface : Colors.white);
    final orderTitleColor =
        isDark ? AppColors.primaryLight : AppColors.primaryColor;
    final dateColor =
        isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final dividerColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final itemsTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final priceColor = _isCancelled
        ? dateColor
        : (isDark ? AppColors.primaryLight : AppColors.primaryColor);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomText(
                  text: 'Order #${shortOrderId(order.id)}',
                  size: 16.sp,
                  weight: FontWeight.w700,
                  color: orderTitleColor,
                  maxLines: 1,
                ),
              ),
              OrderStatusBadge(status: status),
            ],
          ),
          Gap(4.h),
          CustomText(
            text:
                '${formatOrderDate(order.createdAt)} • '
                '${orderItemsQuantity(order.items)} Items',
            size: 12.sp,
            weight: FontWeight.w400,
            color: dateColor,
            maxLines: 1,
          ),
          Gap(12.h),
          Divider(height: 1, color: dividerColor),
          Gap(12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.primaryLight : AppColors.primaryColor)
                      .withValues(alpha: isDark ? 0.2 : 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.restaurant_rounded,
                  color: isDark ? AppColors.primaryLight : AppColors.primaryColor,
                  size: 22.r,
                ),
              ),
              Gap(14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: orderItemsSummary(order.items),
                      size: 13.sp,
                      weight: FontWeight.w500,
                      color: itemsTextColor,
                      maxLines: 2,
                    ),
                    Gap(6.h),
                    CustomText(
                      text: '\$${(order.totalPrice ?? 0).toStringAsFixed(2)}',
                      size: 15.sp,
                      weight: FontWeight.w700,
                      color: priceColor,
                      maxLines: 1,
                    ).withStrikeThrough(_isCancelled),
                  ],
                ),
              ),
            ],
          ),
          Gap(16.h),
          if (_isCancelled)
            _buildHelpButton()
          else if (status.isActive)
            _buildTrackButtons()
          else
            _buildDeliveredButtons(),
        ],
      ),
    );
  }

  Widget _buildDeliveredButtons() {
    return Row(
      children: [
        Expanded(
          child: OrderActionButton(
            icon: Icons.receipt_long_outlined,
            label: 'Details',
            filled: false,
            onTap: onDetails,
          ),
        ),
        Gap(10.w),
        Expanded(
          child: OrderActionButton(
            icon: Icons.refresh_rounded,
            label: 'Reorder',
            filled: true,
            onTap: onReorder,
          ),
        ),
      ],
    );
  }

  Widget _buildTrackButtons() {
    return Row(
      children: [
        Expanded(
          child: OrderActionButton(
            icon: Icons.receipt_long_outlined,
            label: 'Details',
            filled: false,
            onTap: onDetails,
          ),
        ),
        Gap(10.w),
        Expanded(
          child: OrderActionButton(
            icon: Icons.location_on_outlined,
            label: 'Track Order',
            filled: true,
            onTap: onTrack,
          ),
        ),
      ],
    );
  }

  Widget _buildHelpButton() {
    return SizedBox(
      width: double.infinity,
      child: OrderActionButton(
        icon: Icons.help_outline_rounded,
        label: 'Help with Order',
        filled: false,
        onTap: onHelp,
      ),
    );
  }
}
