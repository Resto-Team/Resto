import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'package:resto/core/widgets/custom_text.dart';

class OrderFilterTabs extends StatelessWidget {
  const OrderFilterTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor =
        isDark ? AppColors.primaryLight : AppColors.primaryColor;
    final unselectedBg = isDark ? AppColors.darkSurface : Colors.white;
    final unselectedBorder =
        isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final unselectedText =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: List.generate(labels.length, (index) {
          final bool isSelected = index == selectedIndex;

          return Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? activeColor : unselectedBg,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: isSelected ? activeColor : unselectedBorder,
                  ),
                ),
                child: CustomText(
                  text: labels[index],
                  size: 13.sp,
                  weight: FontWeight.w600,
                  color: isSelected ? Colors.white : unselectedText,
                  maxLines: 1,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
