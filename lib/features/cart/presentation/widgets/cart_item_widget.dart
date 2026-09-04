import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/theme/app_colors.dart';

const Color kPrimaryGreen = AppColors.primaryColor;

class QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const QuantityButton({super.key, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        width: 34.r,
        height: 34.r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: onPressed == null ? Colors.grey.shade300 : kPrimaryGreen,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: Colors.white, size: 18.r),
      ),
    );
  }
}

// Reusable Counter
class QuantityCounter extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const QuantityCounter({
    super.key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        QuantityButton(
          icon: Icons.remove,
          onPressed: quantity > 1 ? onDecrease : null,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            '$quantity',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        QuantityButton(icon: Icons.add, onPressed: onIncrease),
      ],
    );
  }
}

// Reusable Cart Item Card (Stateless - Driven by Cubit state)
class CartItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final num? price;
  final int quantity;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final VoidCallback? onRemove;

  const CartItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.price,
    required this.quantity,
    this.onIncrease,
    this.onDecrease,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = theme.cardTheme.color ??
        (isDark ? AppColors.darkSurface : Colors.white);
    final titleColor =
        isDark ? AppColors.darkTextPrimary : Colors.black87;
    final subtitleColor =
        isDark ? AppColors.darkTextMuted : Colors.grey.shade600;
    final priceColor =
        isDark ? AppColors.primaryLight : AppColors.primaryColor;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18.r),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: Container(
              width: 75.w,
              height: 75.h,
              color: isDark ? AppColors.darkSurfaceVariant : Colors.grey.shade100,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 75.w,
                      height: 75.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: (isDark ? AppColors.primaryLight : AppColors.primaryColor)
                            .withValues(alpha: 0.1),
                        child: Icon(
                          Icons.fastfood_rounded,
                          size: 34.r,
                          color: isDark ? AppColors.primaryLight : AppColors.primaryColor,
                        ),
                      ),
                    )
                  : Container(
                      color: (isDark ? AppColors.primaryLight : AppColors.primaryColor)
                          .withValues(alpha: 0.1),
                      child: Icon(
                        Icons.fastfood_rounded,
                        size: 34.r,
                        color: isDark ? AppColors.primaryLight : AppColors.primaryColor,
                      ),
                    ),
            ),
          ),

          Gap(12.w),

          // Title, Subtitle, Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title.isNotEmpty) ...[
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                ],
                if (subtitle.isNotEmpty) ...[
                  Gap(3.h),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: subtitleColor,
                    ),
                  ),
                ],
                if (price != null) ...[
                  Gap(6.h),
                  Text(
                    '$price EGP',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: priceColor,
                    ),
                  ),
                ],
              ],
            ),
          ),

          Gap(8.w),

          // Quantity counter and remove button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onRemove,
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red.shade400,
                  size: 22.r,
                ),
              ),
              Gap(10.h),
              QuantityCounter(
                quantity: quantity,
                onIncrease: onIncrease ?? () {},
                onDecrease: onDecrease ?? () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
