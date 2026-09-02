import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'package:resto/features/cart/presentation/widgets/payment_method_tile_widget.dart';

class PaymentMethodsSection extends StatefulWidget {
  const PaymentMethodsSection({
    super.key,
    this.onPaymentMethodChanged,
    this.onSaveCardChanged,
  });

  final ValueChanged<int>? onPaymentMethodChanged;
  final ValueChanged<bool>? onSaveCardChanged;

  @override
  State<PaymentMethodsSection> createState() => _PaymentMethodsSectionState();
}

class _PaymentMethodsSectionState extends State<PaymentMethodsSection> {
  int _selectedPaymentMethod = 0; // 0: Cash, 1: Visa
  bool _saveCard = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment methods',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.lightTextPrimary,
          ),
        ),
        const Gap(14),

        PaymentMethodTile(
          leading: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppColors.secondaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.attach_money, color: AppColors.white, size: 20),
          ),
          title: 'Cash on Delivery',
          isSelected: _selectedPaymentMethod == 0,
          onTap: () {
            setState(() => _selectedPaymentMethod = 0);
            widget.onPaymentMethodChanged?.call(0);
          },
        ),
        const Gap(12),

        PaymentMethodTile(
          leading: Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/4/41/Visa_Logo.png',
            width: 42,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.credit_card, size: 30),
          ),
          title: 'Debit card',
          subtitle: '3566 **** **** 0505',
          isSelected: _selectedPaymentMethod == 1,
          onTap: () {
            setState(() => _selectedPaymentMethod = 1);
            widget.onPaymentMethodChanged?.call(1);
          },
        ),
        const Gap(10),

        Row(
          children: [
            Transform.scale(
              scale: 0.9,
              child: Checkbox(
                value: _saveCard,
                activeColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: (v) {
                  final newValue = v ?? false;
                  setState(() => _saveCard = newValue);
                  widget.onSaveCardChanged?.call(newValue);
                },
              ),
            ),
            const Text(
              'Save card details for future payments',
              style: TextStyle(color: AppColors.lightTextSecondary, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
