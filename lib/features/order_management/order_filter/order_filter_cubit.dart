import 'package:flutter_bloc/flutter_bloc.dart';

import '../order_management_state.dart';
import 'order_filter_state.dart';

class OrderFilterCubit extends Cubit<OrderFilterState> {
  OrderFilterCubit() : super(const OrderFilterState());

  void statusChanged(OrderFilter status) {
    emit(state.copyWith(status: status));
  }

  void channelChanged(SalesChannelFilter channel) {
    if (channel == SalesChannelFilter.all) {
      emit(state.copyWith(channels: const {SalesChannelFilter.all}));
      return;
    }

    final channels = {...state.channels}..remove(SalesChannelFilter.all);
    if (!channels.add(channel)) channels.remove(channel);
    emit(
      state.copyWith(
        channels: channels.isEmpty ? const {SalesChannelFilter.all} : channels,
      ),
    );
  }

  void branchChanged(String branch) {
    emit(state.copyWith(branch: branch));
  }

  void dateRangeChanged(OrderDateRange dateRange) {
    emit(state.copyWith(dateRange: dateRange));
  }

  void reset() {
    emit(const OrderFilterState());
  }
}
