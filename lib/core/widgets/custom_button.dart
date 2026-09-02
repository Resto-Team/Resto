import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.width,
    this.color,
    this.height,
    this.radius,
    this.textColor,
    this.widget,
    this.gap,
  });

  final String text;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Color? color;
  final double? radius;
  final Color? textColor;
  final Widget? widget;
  final double? gap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: SizedBox(
        width: width ?? double.infinity,
        height: height ?? 52,
        child: Material(
          color: color ?? AppColors.primaryColor,
          borderRadius: BorderRadius.circular(radius ?? 12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius ?? 12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: CustomText(
                        text: text,
                        color: textColor ?? Colors.white,
                        size: 15,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),

                  Gap(gap ?? 0),

                  widget ?? const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
