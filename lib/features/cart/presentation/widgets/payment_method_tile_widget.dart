import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/theme/app_colors.dart';

class PaymentMethodTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;

  const PaymentMethodTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.selectedColor = AppColors.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: [
            leading,
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const Gap(2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? Colors.white70
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.white : AppColors.lightTextMuted,
            ),
          ],
        ),
      ),
    );
  }
}