import 'package:equatable/equatable.dart';

enum OrderManagementStatus { initial, loading, success, failure }

enum OrderFilter { all, newOrder, processing, completed }

enum OrderStatus { pending, completed, shipping, cancelled }

class OrderSummary extends Equatable {
  const OrderSummary({
    required this.code,
    required this.channel,
    required this.amount,
    required this.status,
  });

  final String code;
  final String channel;
  final int amount;
  final OrderStatus status;

  @override
  List<Object> get props => [code, channel, amount, status];
}

class TopSellingProduct extends Equatable {
  const TopSellingProduct({required this.name, required this.quantity});

  final String name;
  final int quantity;

  @override
  List<Object> get props => [name, quantity];
}

class OrderManagementState extends Equatable {
  const OrderManagementState({
    this.status = OrderManagementStatus.initial,
    this.orders = const [],
    this.topSellingProducts = const [],
    this.selectedFilter = OrderFilter.all,
    this.searchQuery = '',
    this.lowStockCount = 0,
    this.errorMessage,
  });

  final OrderManagementStatus status;
  final List<OrderSummary> orders;
  final List<TopSellingProduct> topSellingProducts;
  final OrderFilter selectedFilter;
  final String searchQuery;
  final int lowStockCount;
  final String? errorMessage;

  List<OrderSummary> get visibleOrders {
    final normalizedQuery = searchQuery.trim().toLowerCase();
    return orders
        .where((order) {
          final matchesFilter = switch (selectedFilter) {
            OrderFilter.all => true,
            OrderFilter.newOrder => order.status == OrderStatus.pending,
            OrderFilter.processing => order.status == OrderStatus.shipping,
            OrderFilter.completed => order.status == OrderStatus.completed,
          };
          final matchesSearch =
              normalizedQuery.isEmpty ||
              order.code.toLowerCase().contains(normalizedQuery) ||
              order.channel.toLowerCase().contains(normalizedQuery);
          return matchesFilter && matchesSearch;
        })
        .toList(growable: false);
  }

  OrderManagementState copyWith({
    OrderManagementStatus? status,
    List<OrderSummary>? orders,
    List<TopSellingProduct>? topSellingProducts,
    OrderFilter? selectedFilter,
    String? searchQuery,
    int? lowStockCount,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OrderManagementState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      topSellingProducts: topSellingProducts ?? this.topSellingProducts,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      lowStockCount: lowStockCount ?? this.lowStockCount,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    orders,
    topSellingProducts,
    selectedFilter,
    searchQuery,
    lowStockCount,
    errorMessage,
  ];
}
