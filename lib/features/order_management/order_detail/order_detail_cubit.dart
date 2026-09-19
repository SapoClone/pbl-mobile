import 'package:flutter_bloc/flutter_bloc.dart';

import '../order_management_state.dart';
import 'order_detail_state.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit({required String orderCode})
    : super(OrderDetailState(orderCode: orderCode));

  Future<void> loadOrder() async {
    emit(state.copyWith(status: OrderDetailStatus.loading, clearError: true));

    // TODO: Replace fake data with data from OrderRepository.
    await Future<void>.delayed(const Duration(milliseconds: 350));

    emit(
      state.copyWith(
        status: OrderDetailStatus.success,
        orderStatus: OrderStatus.shipping,
        channel: 'Shopee',
        customer: const OrderCustomer(
          name: 'Nguyen Van A',
          phone: '0900 000 000',
        ),
        products: const [
          OrderProductLine(
            name: 'Polo shirt - Black',
            variant: 'Size M',
            quantity: 2,
            unitPrice: 250000,
          ),
          OrderProductLine(
            name: 'Jeans - Blue',
            variant: 'Size 30',
            quantity: 1,
            unitPrice: 200000,
          ),
        ],
        shippingFee: 30000,
        discount: 0,
        timeline: const [
          OrderTimelineStep(title: 'Order placed', isCompleted: true),
          OrderTimelineStep(title: 'Confirmed', isCompleted: true),
          OrderTimelineStep(
            title: 'Packing',
            isCompleted: true,
            isCurrent: true,
          ),
          OrderTimelineStep(title: 'Shipping', isCompleted: false),
          OrderTimelineStep(title: 'Completed', isCompleted: false),
        ],
      ),
    );
  }

  void updateOrder() {
    emit(
      state.copyWith(
        orderStatus: OrderStatus.completed,
        timeline: state.timeline
            .map(
              (step) => OrderTimelineStep(
                title: step.title,
                isCompleted: true,
                isCurrent: step.title == 'Completed',
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
