import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/localization/app_strings.dart';
import 'package:resto/core/widgets/error_retry_view.dart';
import 'package:resto/features/order_history/domain/entities/order_entity.dart';
import 'package:resto/features/order_history/presentation/manager/cubit/order_history_cubit.dart';
import 'package:resto/features/order_history/presentation/views/widgets/order_filter_tabs.dart';
import 'package:resto/features/order_history/presentation/views/widgets/order_history_header.dart';
import 'package:resto/features/order_history/presentation/views/widgets/order_history_skeleton.dart';
import 'package:resto/features/order_history/presentation/views/widgets/orders_list_view.dart';

class OrderHistoryViewBody extends StatefulWidget {
  const OrderHistoryViewBody({super.key});

  @override
  State<OrderHistoryViewBody> createState() => _OrderHistoryBodyState();
}

class _OrderHistoryBodyState extends State<OrderHistoryViewBody> {
  int _selectedTab = 0;

  List<OrderEntity> _filterOrders(List<OrderEntity> orders) {
    switch (_selectedTab) {
      case 1:
        return orders
            .where((order) => (order.status ?? OrderStatus.pending).isActive)
            .toList();
      case 2:
        return orders
            .where((order) => order.status == OrderStatus.delivered)
            .toList();
      case 3:
        return orders
            .where((order) => order.status == OrderStatus.cancelled)
            .toList();
      default:
        return orders;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterLabels = [
      context.strings.allOrders,
      context.strings.ongoing,
      context.strings.completed,
      context.strings.cancelled,
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const OrderHistoryHeader(),
            Gap(20.h),
            OrderFilterTabs(
              labels: filterLabels,
              selectedIndex: _selectedTab,
              onChanged: (index) => setState(() => _selectedTab = index),
            ),
            Gap(16.h),
            Expanded(
              child: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
                builder: (context, state) {
                  return switch (state) {
                    OrderHistoryInitial() ||
                    GetOrderHistoryLoadingState() => ListView.separated(
                      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                      itemCount: 4,
                      separatorBuilder: (context, index) => Gap(16.h),
                      itemBuilder: (context, index) =>
                          const OrderHistorySkeleton(),
                    ),
                    GetOrderHistoryErrorState(error: final message) => Center(
                      child: ErrorRetryView(
                        message: message,
                        onRetry: () =>
                            context.read<OrderHistoryCubit>().getMyOrders(),
                      ),
                    ),
                    GetOrderHistorySuccessState(orders: final orders) =>
                      OrdersListView(orders: _filterOrders(orders)),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
