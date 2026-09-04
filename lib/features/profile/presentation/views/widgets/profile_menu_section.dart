import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'package:resto/core/widgets/custom_text.dart';
import 'package:resto/features/profile/presentation/views/widgets/profile_menu_item.dart';

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<ProfileMenuItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor =
        isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final cardColor =
        theme.cardTheme.color ?? (isDark ? AppColors.darkSurface : Colors.white);
    final dividerColor = theme.dividerTheme.color ??
        (isDark ? AppColors.darkBorder : AppColors.lightBorder);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          size: 13.sp,
          weight: FontWeight.w600,
          color: titleColor,
          maxLines: 1,
        ),
        Gap(8.h),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                items[i],
                if (i != items.length - 1)
                  Divider(
                    height: 1,
                    indent: 66.w,
                    color: dividerColor,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
