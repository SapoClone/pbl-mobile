import 'package:equatable/equatable.dart';

import '../order_management_state.dart';

enum SalesChannelFilter { all, pos, shopee, lazada, website, tiktokShop }

enum OrderDateRange { last7Days, last30Days, last90Days }

class OrderFilterState extends Equatable {
  const OrderFilterState({
    this.status = OrderFilter.all,
    this.channels = const {SalesChannelFilter.all},
    this.branch = 'All branches',
    this.dateRange = OrderDateRange.last7Days,
  });

  final OrderFilter status;
  final Set<SalesChannelFilter> channels;
  final String branch;
  final OrderDateRange dateRange;

  OrderFilterState copyWith({
    OrderFilter? status,
    Set<SalesChannelFilter>? channels,
    String? branch,
    OrderDateRange? dateRange,
  }) {
    return OrderFilterState(
      status: status ?? this.status,
      channels: channels ?? this.channels,
      branch: branch ?? this.branch,
      dateRange: dateRange ?? this.dateRange,
    );
  }

  @override
  List<Object> get props => [status, channels, branch, dateRange];
}
