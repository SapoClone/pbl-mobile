import 'package:flutter_bloc/flutter_bloc.dart';

import '../authentication/data/repository/authentication_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required AuthenticationRepository authenticationRepository})
    : _authenticationRepository = authenticationRepository,
      super(const HomeState());

  final AuthenticationRepository _authenticationRepository;

  Future<void> loadDashboard() async {
    emit(state.copyWith(status: HomeStatus.loading, clearError: true));

    // TODO: Replace fake data with data from DashboardRepository.
    await Future<void>.delayed(const Duration(milliseconds: 450));

    emit(
      state.copyWith(
        status: HomeStatus.success,
        branchName: 'Hai Chau',
        todayRevenue: 18500000,
        revenueGrowth: 12.5,
        orderCount: 42,
        customerCount: 12,
        weeklyRevenue: const [8.2, 9.1, 11.8, 9.7, 12.4, 10.8, 14.6],
        bestSellingProducts: const [
          BestSellingProduct(name: 'T-shirt', quantity: 120),
          BestSellingProduct(name: 'Jeans', quantity: 87),
          BestSellingProduct(name: 'Women dress', quantity: 56),
        ],
        lowStockCount: 8,
      ),
    );
  }

  void navigationChanged(int index) {
    emit(state.copyWith(selectedNavigationIndex: index));
  }

  Future<void> logout() async {
    await _authenticationRepository.logout();
  }
}
