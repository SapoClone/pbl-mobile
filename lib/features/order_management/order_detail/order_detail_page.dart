import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../common/resources/app_theme.dart';
import '../../../navigation/route_const.dart';
import '../order_management_state.dart';
import 'order_detail_cubit.dart';
import 'order_detail_state.dart';

const _blue = Color(0xFF0B6EF3);
const _blueLight = Color(0xFFEAF3FF);
const _background = Color(0xFFF6F8FC);
const _textPrimary = Color(0xFF13213A);
const _textSecondary = Color(0xFF7E8AA0);
const _border = Color(0xFFE2E8F0);
const _green = Color(0xFF20B875);
const _orange = Color(0xFFFF9F43);
const _red = Color(0xFFFF5A5F);
const _fontFamily = AppTheme.fontFamily;
const _tabularFigures = <FontFeature>[FontFeature.tabularFigures()];

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({required this.orderCode, super.key});

  final String orderCode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderDetailCubit(orderCode: orderCode)..loadOrder(),
      child: const _OrderDetailView(),
    );
  }
}

class _OrderDetailView extends StatelessWidget {
  const _OrderDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderDetailCubit, OrderDetailState>(
      listenWhen: (previous, current) =>
          previous.orderStatus != current.orderStatus,
      listener: (context, state) {
        if (state.orderStatus == OrderStatus.completed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order updated successfully.')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: _background,
          body: SafeArea(
            child: Column(
              children: [
                _DetailHeader(orderCode: state.orderCode),
                Expanded(
                  child: state.status == OrderDetailStatus.loading
                      ? const Center(
                          child: CircularProgressIndicator(color: _blue),
                        )
                      : _DetailContent(state: state),
                ),
                if (state.status == OrderDetailStatus.success)
                  _UpdateButton(
                    isCompleted: state.orderStatus == OrderStatus.completed,
                    onPressed: context.read<OrderDetailCubit>().updateOrder,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.orderCode});

  final String orderCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: _border)),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.goNamed(AppRouteName.orderManagement);
              }
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: _textPrimary,
              size: 20,
            ),
          ),
          Expanded(
            child: Text(
              orderCode,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: _fontFamily,
                color: _textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFeatures: _tabularFigures,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.state});

  final OrderDetailState state;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = (MediaQuery.sizeOf(context).width * 0.04).clamp(
      14.0,
      22.0,
    );
    return ListView(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        14,
        horizontalPadding,
        24,
      ),
      children: [
        _OrderStatusCard(state: state),
        const SizedBox(height: 12),
        _CustomerCard(customer: state.customer),
        const SizedBox(height: 12),
        _ProductsCard(products: state.products),
        const SizedBox(height: 12),
        _PaymentSummary(state: state),
        const SizedBox(height: 12),
        _OrderTimeline(steps: state.timeline),
      ],
    );
  }
}

class _OrderStatusCard extends StatelessWidget {
  const _OrderStatusCard({required this.state});

  final OrderDetailState state;

  @override
  Widget build(BuildContext context) {
    final statusStyle = _statusStyle(state.orderStatus);
    return _WhiteCard(
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFFFECEC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: _red,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.channel,
                  style: const TextStyle(
                    fontFamily: _fontFamily,
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Sales channel',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    color: _textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusStyle.color.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusStyle.label,
              style: TextStyle(
                fontFamily: _fontFamily,
                color: statusStyle.color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.customer});

  final OrderCustomer customer;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      title: 'Customer information',
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: _blueLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline_rounded, color: _blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.name,
                  style: const TextStyle(
                    fontFamily: _fontFamily,
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  customer.phone,
                  style: const TextStyle(
                    fontFamily: _fontFamily,
                    color: _textSecondary,
                    fontSize: 12,
                    fontFeatures: _tabularFigures,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductsCard extends StatelessWidget {
  const _ProductsCard({required this.products});

  final List<OrderProductLine> products;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      title: 'Products',
      child: Column(
        children: products.indexed.map((entry) {
          final product = entry.$2;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: entry.$1 == products.length - 1
                  ? null
                  : const Border(bottom: BorderSide(color: _border)),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.checkroom_rounded,
                    color: _textSecondary,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: _fontFamily,
                          color: _textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${product.variant}  ×${product.quantity}',
                        style: const TextStyle(
                          fontFamily: _fontFamily,
                          color: _textSecondary,
                          fontSize: 12,
                          fontFeatures: _tabularFigures,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${_formatCurrency(product.total)} VND',
                  style: const TextStyle(
                    fontFamily: _fontFamily,
                    color: _textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFeatures: _tabularFigures,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PaymentSummary extends StatelessWidget {
  const _PaymentSummary({required this.state});

  final OrderDetailState state;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        children: [
          _SummaryRow(label: 'Subtotal', value: state.subtotal),
          const SizedBox(height: 10),
          _SummaryRow(label: 'Shipping fee', value: state.shippingFee),
          const SizedBox(height: 10),
          _SummaryRow(label: 'Discount', value: -state.discount),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: _border),
          ),
          _SummaryRow(label: 'Total', value: state.total, isTotal: true),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  final String label;
  final int value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: _fontFamily,
              color: isTotal ? _textPrimary : _textSecondary,
              fontSize: isTotal ? 15 : 13,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
        Text(
          '${_formatCurrency(value)} VND',
          style: TextStyle(
            fontFamily: _fontFamily,
            color: isTotal ? _red : _textPrimary,
            fontSize: isTotal ? 17 : 13,
            fontWeight: FontWeight.w700,
            fontFeatures: _tabularFigures,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _OrderTimeline extends StatelessWidget {
  const _OrderTimeline({required this.steps});

  final List<OrderTimelineStep> steps;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      title: 'Order timeline',
      child: Column(
        children: steps.indexed.map((entry) {
          final step = entry.$2;
          final isLast = entry.$1 == steps.length - 1;
          return SizedBox(
            height: isLast ? 34 : 48,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  child: Column(
                    children: [
                      Container(
                        width: step.isCurrent ? 15 : 11,
                        height: step.isCurrent ? 15 : 11,
                        decoration: BoxDecoration(
                          color: step.isCompleted ? _blue : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: step.isCompleted ? _blue : _border,
                            width: 2,
                          ),
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: step.isCompleted ? _blue : _border,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    step.title,
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      color: step.isCurrent ? _blue : _textPrimary,
                      fontSize: 13,
                      fontWeight: step.isCurrent
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({required this.child, this.title});

  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontFamily: _fontFamily,
                color: _textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

class _UpdateButton extends StatelessWidget {
  const _UpdateButton({required this.isCompleted, required this.onPressed});

  final bool isCompleted;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _border)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton(
          onPressed: isCompleted ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: _blue,
            disabledBackgroundColor: _green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
          child: Text(
            isCompleted ? 'Order completed' : 'Update order',
            style: const TextStyle(
              fontFamily: _fontFamily,
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

({String label, Color color}) _statusStyle(OrderStatus status) {
  return switch (status) {
    OrderStatus.pending => (label: 'Pending', color: _orange),
    OrderStatus.completed => (label: 'Completed', color: _green),
    OrderStatus.shipping => (label: 'Shipping', color: _blue),
    OrderStatus.cancelled => (label: 'Cancelled', color: _red),
  };
}

String _formatCurrency(int value) {
  return NumberFormat.decimalPattern('en_US').format(value);
}
