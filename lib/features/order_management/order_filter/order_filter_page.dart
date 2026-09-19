import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/resources/app_theme.dart';
import '../../../navigation/route_const.dart';
import '../order_management_state.dart';
import 'order_filter_cubit.dart';
import 'order_filter_state.dart';

const _blue = Color(0xFF0B6EF3);
const _blueLight = Color(0xFFEAF3FF);
const _background = Color(0xFFF6F8FC);
const _textPrimary = Color(0xFF13213A);
const _textSecondary = Color(0xFF7E8AA0);
const _border = Color(0xFFE2E8F0);
const _fontFamily = AppTheme.fontFamily;

class OrderFilterPage extends StatelessWidget {
  const OrderFilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderFilterCubit(),
      child: const _OrderFilterView(),
    );
  }
}

class _OrderFilterView extends StatelessWidget {
  const _OrderFilterView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderFilterCubit, OrderFilterState>(
      builder: (context, state) {
        final cubit = context.read<OrderFilterCubit>();
        return Scaffold(
          backgroundColor: _background,
          body: SafeArea(
            child: Column(
              children: [
                _FilterHeader(onReset: cubit.reset),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                    children: [
                      const _SectionTitle('Status'),
                      const SizedBox(height: 10),
                      _StatusCard(
                        selectedStatus: state.status,
                        onChanged: cubit.statusChanged,
                      ),
                      const SizedBox(height: 22),
                      const _SectionTitle('Sales channel'),
                      const SizedBox(height: 10),
                      _ChannelGrid(
                        selectedChannels: state.channels,
                        onChanged: cubit.channelChanged,
                      ),
                      const SizedBox(height: 22),
                      const _SectionTitle('Branch'),
                      const SizedBox(height: 10),
                      _SelectionDropdown<String>(
                        value: state.branch,
                        items: const [
                          'All branches',
                          'Hai Chau',
                          'Thanh Khe',
                          'Son Tra',
                        ],
                        labelBuilder: (value) => value,
                        onChanged: cubit.branchChanged,
                      ),
                      const SizedBox(height: 22),
                      const _SectionTitle('Date range'),
                      const SizedBox(height: 10),
                      _SelectionDropdown<OrderDateRange>(
                        value: state.dateRange,
                        items: OrderDateRange.values,
                        labelBuilder: _dateRangeLabel,
                        onChanged: cubit.dateRangeChanged,
                      ),
                    ],
                  ),
                ),
                _ApplyButton(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop(state);
                    } else {
                      context.goNamed(AppRouteName.orderManagement);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterHeader extends StatelessWidget {
  const _FilterHeader({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: _border)),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Close',
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.goNamed(AppRouteName.orderManagement);
              }
            },
            icon: const Icon(Icons.close_rounded, color: _textPrimary),
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              'Filter orders',
              style: TextStyle(
                fontFamily: _fontFamily,
                color: _textPrimary,
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: onReset,
            child: const Text(
              'Reset',
              style: TextStyle(
                fontFamily: _fontFamily,
                color: _blue,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: _fontFamily,
        color: _textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.selectedStatus, required this.onChanged});

  final OrderFilter selectedStatus;
  final ValueChanged<OrderFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    const options = [
      (OrderFilter.all, 'All'),
      (OrderFilter.newOrder, 'New'),
      (OrderFilter.processing, 'Processing'),
      (OrderFilter.completed, 'Completed'),
    ];
    return _WhiteCard(
      child: Column(
        children: options.map((option) {
          final selected = selectedStatus == option.$1;
          return InkWell(
            onTap: () => onChanged(option.$1),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: selected ? _blue : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected ? _blue : _border,
                        width: 1.5,
                      ),
                    ),
                    child: selected
                        ? const Icon(Icons.check, color: Colors.white, size: 13)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    option.$2,
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      color: selected ? _textPrimary : _textSecondary,
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ChannelGrid extends StatelessWidget {
  const _ChannelGrid({required this.selectedChannels, required this.onChanged});

  final Set<SalesChannelFilter> selectedChannels;
  final ValueChanged<SalesChannelFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: SalesChannelFilter.values.map((channel) {
          final selected = selectedChannels.contains(channel);
          return InkWell(
            onTap: () => onChanged(channel),
            borderRadius: BorderRadius.circular(8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: (MediaQuery.sizeOf(context).width - 76) / 2,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
              decoration: BoxDecoration(
                color: selected ? _blueLight : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: selected ? _blue : _border),
              ),
              child: Row(
                children: [
                  Icon(
                    _channelIcon(channel),
                    color: selected ? _blue : _textSecondary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _channelLabel(channel),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        color: selected ? _blue : _textSecondary,
                        fontSize: 12,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SelectionDropdown<T> extends StatelessWidget {
  const _SelectionDropdown({
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });

  final T value;
  final List<T> items;
  final String Function(T value) labelBuilder;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      dropdownColor: Colors.white,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      style: const TextStyle(
        fontFamily: _fontFamily,
        color: _textPrimary,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: _blue, width: 1.4),
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(labelBuilder(item)),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: child,
    );
  }
}

class _ApplyButton extends StatelessWidget {
  const _ApplyButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _border)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: _blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
          child: const Text(
            'Apply filters',
            style: TextStyle(
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

String _dateRangeLabel(OrderDateRange range) {
  return switch (range) {
    OrderDateRange.last7Days => 'Last 7 days',
    OrderDateRange.last30Days => 'Last 30 days',
    OrderDateRange.last90Days => 'Last 90 days',
  };
}

String _channelLabel(SalesChannelFilter channel) {
  return switch (channel) {
    SalesChannelFilter.all => 'All channels',
    SalesChannelFilter.pos => 'POS',
    SalesChannelFilter.shopee => 'Shopee',
    SalesChannelFilter.lazada => 'Lazada',
    SalesChannelFilter.website => 'Website',
    SalesChannelFilter.tiktokShop => 'TikTok Shop',
  };
}

IconData _channelIcon(SalesChannelFilter channel) {
  return switch (channel) {
    SalesChannelFilter.all => Icons.apps_rounded,
    SalesChannelFilter.pos => Icons.point_of_sale_rounded,
    SalesChannelFilter.website => Icons.language_rounded,
    SalesChannelFilter.tiktokShop => Icons.music_note_rounded,
    _ => Icons.shopping_bag_outlined,
  };
}
