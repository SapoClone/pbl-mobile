import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../common/resources/app_theme.dart';
import '../../navigation/route_const.dart';
import 'order_management_cubit.dart';
import 'order_management_state.dart';

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

class OrderManagementPage extends StatelessWidget {
  const OrderManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderManagementCubit()..loadOrders(),
      child: const _OrderManagementView(),
    );
  }
}

class _OrderManagementView extends StatelessWidget {
  const _OrderManagementView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderManagementCubit, OrderManagementState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: _background,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                const _OrdersHeader(),
                Expanded(
                  child: RefreshIndicator(
                    color: _blue,
                    onRefresh: context.read<OrderManagementCubit>().loadOrders,
                    child:
                        state.status == OrderManagementStatus.loading &&
                            state.orders.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(color: _blue),
                          )
                        : _OrdersContent(state: state),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _OrdersNavigationBar(
            onSelected: (index) {
              if (index == 0) {
                context.goNamed(AppRouteName.home);
              } else if (index != 1) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('This feature is under development.'),
                      duration: Duration(seconds: 1),
                    ),
                  );
              }
            },
          ),
        );
      },
    );
  }
}

class _OrdersHeader extends StatelessWidget {
  const _OrdersHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: _border)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _blueLight,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: _blue,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Orders',
            style: TextStyle(
              fontFamily: _fontFamily,
              color: _textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Sync orders',
            onPressed: context.read<OrderManagementCubit>().loadOrders,
            icon: const Icon(Icons.sync_rounded, color: _textPrimary, size: 23),
          ),
        ],
      ),
    );
  }
}

class _OrdersContent extends StatelessWidget {
  const _OrdersContent({required this.state});

  final OrderManagementState state;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = (MediaQuery.sizeOf(context).width * 0.04).clamp(
      14.0,
      22.0,
    );
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        14,
        horizontalPadding,
        24,
      ),
      children: [
        _OrderFilters(selectedFilter: state.selectedFilter),
        const SizedBox(height: 13),
        _OrderSearchField(
          onChanged: context.read<OrderManagementCubit>().searchChanged,
        ),
        const SizedBox(height: 14),
        if (state.visibleOrders.isEmpty)
          const _EmptyOrders()
        else
          ...state.visibleOrders.map(
            (order) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _OrderCard(order: order),
            ),
          ),
        const SizedBox(height: 6),
        _TopSellingProducts(products: state.topSellingProducts),
        const SizedBox(height: 12),
        _LowStockAlert(count: state.lowStockCount),
      ],
    );
  }
}

class _OrderFilters extends StatelessWidget {
  const _OrderFilters({required this.selectedFilter});

  final OrderFilter selectedFilter;

  @override
  Widget build(BuildContext context) {
    const filters = [
      (OrderFilter.all, 'All'),
      (OrderFilter.newOrder, 'New'),
      (OrderFilter.processing, 'Processing'),
      (OrderFilter.completed, 'Completed'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((item) {
          final isSelected = item.$1 == selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () =>
                  context.read<OrderManagementCubit>().filterChanged(item.$1),
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? _blue : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isSelected ? _blue : _border),
                ),
                child: Text(
                  item.$2,
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    color: isSelected ? Colors.white : _textSecondary,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _OrderSearchField extends StatelessWidget {
  const _OrderSearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          fontFamily: _fontFamily,
          color: _textPrimary,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: 'Search order code or channel...',
          hintStyle: const TextStyle(
            fontFamily: _fontFamily,
            color: _textSecondary,
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: _textSecondary,
            size: 21,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: _border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: _blue, width: 1.4),
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final OrderSummary order;

  @override
  Widget build(BuildContext context) {
    final style = _statusStyle(order.status);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _channelColor(order.channel).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _channelIcon(order.channel),
              color: _channelColor(order.channel),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.code,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: _fontFamily,
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFeatures: _tabularFigures,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  order.channel,
                  style: const TextStyle(
                    fontFamily: _fontFamily,
                    color: _textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_formatCurrency(order.amount)} VND',
                style: const TextStyle(
                  fontFamily: _fontFamily,
                  color: _textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  fontFeatures: _tabularFigures,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: style.color.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  style.label,
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    color: style.color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopSellingProducts extends StatelessWidget {
  const _TopSellingProducts({required this.products});

  final List<TopSellingProduct> products;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Best-selling products',
            style: TextStyle(
              fontFamily: _fontFamily,
              color: _textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          ...products.map(
            (product) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.checkroom_rounded,
                      color: _textSecondary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontFamily: _fontFamily,
                        color: _textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    product.quantity.toString(),
                    style: const TextStyle(
                      fontFamily: _fontFamily,
                      color: _textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      fontFeatures: _tabularFigures,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LowStockAlert extends StatelessWidget {
  const _LowStockAlert({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEEE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFD6D6)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: _red, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$count products are low in stock',
              style: const TextStyle(
                fontFamily: _fontFamily,
                color: _red,
                fontSize: 13,
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

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: _border),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off_rounded, color: _textSecondary, size: 32),
          SizedBox(height: 8),
          Text(
            'No orders found',
            style: TextStyle(
              fontFamily: _fontFamily,
              color: _textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdersNavigationBar extends StatelessWidget {
  const _OrdersNavigationBar({required this.onSelected});

  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        height: 70,
        backgroundColor: Colors.white,
        indicatorColor: _blueLight,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontFamily: _fontFamily,
            color: states.contains(WidgetState.selected)
                ? _blue
                : _textSecondary,
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w400,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? _blue
                : _textSecondary,
            size: 22,
          ),
        ),
      ),
      child: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: onSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner_rounded),
            label: 'Scan',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'More',
          ),
        ],
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

Color _channelColor(String channel) {
  return switch (channel) {
    'Shopee' => _red,
    'POS' => const Color(0xFF168AAD),
    'Website' => _orange,
    _ => const Color(0xFF274C77),
  };
}

IconData _channelIcon(String channel) {
  return switch (channel) {
    'POS' => Icons.point_of_sale_rounded,
    'Website' => Icons.language_rounded,
    _ => Icons.shopping_bag_rounded,
  };
}

String _formatCurrency(int value) {
  return NumberFormat.decimalPattern('en_US').format(value);
}
