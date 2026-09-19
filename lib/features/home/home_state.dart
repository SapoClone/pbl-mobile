import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, success, failure }

class BestSellingProduct extends Equatable {
  const BestSellingProduct({required this.name, required this.quantity});

  final String name;
  final int quantity;

  @override
  List<Object> get props => [name, quantity];
}

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.branchName = 'Hai Chau',
    this.todayRevenue = 0,
    this.revenueGrowth = 0,
    this.orderCount = 0,
    this.customerCount = 0,
    this.weeklyRevenue = const [],
    this.bestSellingProducts = const [],
    this.lowStockCount = 0,
    this.selectedNavigationIndex = 0,
    this.errorMessage,
  });

  final HomeStatus status;
  final String branchName;
  final int todayRevenue;
  final double revenueGrowth;
  final int orderCount;
  final int customerCount;
  final List<double> weeklyRevenue;
  final List<BestSellingProduct> bestSellingProducts;
  final int lowStockCount;
  final int selectedNavigationIndex;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    String? branchName,
    int? todayRevenue,
    double? revenueGrowth,
    int? orderCount,
    int? customerCount,
    List<double>? weeklyRevenue,
    List<BestSellingProduct>? bestSellingProducts,
    int? lowStockCount,
    int? selectedNavigationIndex,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      branchName: branchName ?? this.branchName,
      todayRevenue: todayRevenue ?? this.todayRevenue,
      revenueGrowth: revenueGrowth ?? this.revenueGrowth,
      orderCount: orderCount ?? this.orderCount,
      customerCount: customerCount ?? this.customerCount,
      weeklyRevenue: weeklyRevenue ?? this.weeklyRevenue,
      bestSellingProducts: bestSellingProducts ?? this.bestSellingProducts,
      lowStockCount: lowStockCount ?? this.lowStockCount,
      selectedNavigationIndex:
          selectedNavigationIndex ?? this.selectedNavigationIndex,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    branchName,
    todayRevenue,
    revenueGrowth,
    orderCount,
    customerCount,
    weeklyRevenue,
    bestSellingProducts,
    lowStockCount,
    selectedNavigationIndex,
    errorMessage,
  ];
}
