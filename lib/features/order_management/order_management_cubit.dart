import 'package:flutter_bloc/flutter_bloc.dart';

import 'order_management_state.dart';

class OrderManagementCubit extends Cubit<OrderManagementState> {
  OrderManagementCubit() : super(const OrderManagementState());

  Future<void> loadOrders() async {
    emit(
      state.copyWith(status: OrderManagementStatus.loading, clearError: true),
    );

    // TODO: Replace fake data with data from OrderRepository.
    await Future<void>.delayed(const Duration(milliseconds: 400));

    emit(
      state.copyWith(
        status: OrderManagementStatus.success,
        orders: const [
          OrderSummary(
            code: '#OD20260901',
            channel: 'Shopee',
            amount: 350000,
            status: OrderStatus.pending,
          ),
          OrderSummary(
            code: '#OD20260800',
            channel: 'POS',
            amount: 520000,
            status: OrderStatus.completed,
          ),
          OrderSummary(
            code: '#OD20260899',
            channel: 'Website',
            amount: 780000,
            status: OrderStatus.shipping,
          ),
          OrderSummary(
            code: '#OD20260898',
            channel: 'Lazada',
            amount: 1200000,
            status: OrderStatus.cancelled,
          ),
        ],
        topSellingProducts: const [
          TopSellingProduct(name: 'T-shirt', quantity: 120),
          TopSellingProduct(name: 'Jeans', quantity: 87),
          TopSellingProduct(name: 'Women dress', quantity: 56),
        ],
        lowStockCount: 8,
      ),
    );
  }

  void filterChanged(OrderFilter filter) {
    emit(state.copyWith(selectedFilter: filter));
  }

  void searchChanged(String query) {
    emit(state.copyWith(searchQuery: query));
  }
}
