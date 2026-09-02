import 'package:flutter/material.dart';

import 'package:resto/core/theme/app_colors.dart';

class SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isBold;
  final double fontSize;

  const SummaryRow({
    super.key,
    required this.title,
    required this.value,
    this.isBold = false,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: fontSize,
      fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
      color: isBold ? AppColors.lightTextPrimary : AppColors.lightTextSecondary,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}

