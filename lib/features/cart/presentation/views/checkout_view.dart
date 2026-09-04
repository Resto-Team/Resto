import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/functions/app_snack_bar.dart';
import 'package:resto/core/localization/app_strings.dart';
import 'package:resto/core/services/paymob_service.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'package:resto/core/widgets/custom_button.dart';
import 'package:resto/features/auth/presentation/manager/session/session_cubit.dart';
import 'package:resto/features/cart/presentation/manager/cubit/cart_cubit.dart';
import 'package:resto/features/cart/presentation/views/paymob_webview_view.dart';
import 'package:resto/features/cart/presentation/widgets/payment_methods_section.dart';
import 'package:resto/features/cart/presentation/widgets/summary_row_widget.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.totalPrice});
  final num totalPrice;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? deliveryAddress;
  String? phone;
  String? userName;
  String paymentMethod = 'cash'; // 'cash' or 'card'
  bool isPaymobLoading = false;

  final PaymobService _paymobService = PaymobService();

  Future<void> _handlePayment() async {
    final effectiveAddress = deliveryAddress ?? 'Mansoura, Hay Algamaa';
    final effectivePhone = phone ?? '01111111111';
    final effectiveName = userName ?? 'Customer';
    final finalTotal = widget.totalPrice + 0.3 + 1.5;

    // 1. الدفع عند الاستلام (Cash on Delivery)
    if (paymentMethod == 'cash') {
      if (!mounted) return;
      context.read<CartCubit>().createOrder(
            deliveryAddress: effectiveAddress,
            phone: effectivePhone,
            paymentMethod: 'cash',
          );
      return;
    }

    // 2. الدفع أونلاين عبر Paymob (Debit/Credit Card)
    setState(() => isPaymobLoading = true);

    try {
      // أ- إنشاء Payment Intention في Paymob للحصول على client_secret
      final clientSecret = await _paymobService.createPaymentIntention(
        amount: finalTotal,
        currency: 'EGP',
        firstName: effectiveName.split(' ').first,
        lastName: effectiveName.split(' ').length > 1
            ? effectiveName.split(' ').sublist(1).join(' ')
            : 'User',
        email: 'customer@resto.com',
        phone: effectivePhone,
      );

      if (!mounted) return;
      setState(() => isPaymobLoading = false);

      // ب- فتح صفحة الدفع Unified Checkout داخل WebView
      final isSuccess = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => PaymobWebViewScreen(clientSecret: clientSecret),
        ),
      );

      if (!mounted) return;

      // ج- بعد انتهاء الدفع
      if (isSuccess == true) {
        // إنشاء الطلب في السيستم بعد تأكيد الدفع
        context.read<CartCubit>().createOrder(
              deliveryAddress: effectiveAddress,
              phone: effectivePhone,
              paymentMethod: 'card',
            );
      } else {
        showAnimatedSnackbar(
          context,
          message: context.strings.paymentCancelledOrFailed,
          type: AnimatedSnackBarType.error,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => isPaymobLoading = false);
        showAnimatedSnackbar(
          context,
          message: e.toString().replaceAll('Exception: ', ''),
          type: AnimatedSnackBarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionCubit, SessionState>(
      listener: (context, state) {
        if (state is SessionError) {
          showAnimatedSnackbar(
            context,
            message: state.message,
            type: AnimatedSnackBarType.error,
          );
        }

        if (state is SessionLoaded) {
          showAnimatedSnackbar(
            context,
            message: 'Your order ready for payment ${state.userName}',
            type: AnimatedSnackBarType.success,
          );
          deliveryAddress = state.address;
          phone = state.phone;
          userName = state.userName;
        }
      },
      builder: (context, sessionState) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.lightTextPrimary,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.strings.orderSummary,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.lightTextPrimary,
                          ),
                        ),
                        const Gap(12),
                        SummaryRow(
                          title: context.strings.order,
                          value: '${widget.totalPrice} ${context.strings.egp}',
                        ),
                        SummaryRow(title: context.strings.taxes, value: '0.3 ${context.strings.egp}'),
                        SummaryRow(
                          title: context.strings.deliveryFees,
                          value: '1.5 ${context.strings.egp}',
                        ),
                        const Gap(8),
                        const Divider(
                          color: AppColors.lightBorder,
                          thickness: 1,
                        ),
                        const Gap(8),
                        SummaryRow(
                          title: '${context.strings.total}:',
                          value: '${widget.totalPrice + 0.3 + 1.5} ${context.strings.egp}',
                          isBold: true,
                          fontSize: 16,
                        ),
                        const Gap(8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.strings.estimatedDeliveryTime,
                              style: const TextStyle(
                                color: AppColors.lightTextPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              context.strings.deliveryTimeValue,
                              style: const TextStyle(
                                color: AppColors.lightTextPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const Gap(28),

                        PaymentMethodsSection(
                          onPaymentMethodChanged: (index) {
                            setState(() {
                              paymentMethod = index == 0 ? 'cash' : 'card';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 0, 16),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total price',
                            style: TextStyle(
                              color: AppColors.lightTextSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const Gap(2),
                          Text(
                            (widget.totalPrice + 0.3 + 1.5).toString(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 210,
                        child: BlocConsumer<CartCubit, CartState>(
                          listener: (context, state) {
                            if (state is CreateOrderErrorState) {
                              showAnimatedSnackbar(
                                context,
                                message: state.error,
                                type: AnimatedSnackBarType.error,
                              );
                            }
                            if (state is CreateOrderSuccessState) {
                              showAnimatedSnackbar(
                                context,
                                message: context.strings.orderPlacedSuccess,
                                type: AnimatedSnackBarType.success,
                              );
                              Navigator.pop(context);
                            }
                          },
                          builder: (context, state) {
                            final isLoading =
                                state is CreateOrderLoadingState || isPaymobLoading;

                            return CustomButton(
                              text: isLoading
                                  ? context.strings.placingOrder
                                  : (paymentMethod == 'card'
                                      ? context.strings.payWithCard
                                      : context.strings.placeOrder),
                              color: AppColors.primaryColor,
                              radius: 20,
                              onTap: () {
                                if (!isLoading) {
                                  _handlePayment();
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

