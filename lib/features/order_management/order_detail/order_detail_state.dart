import 'package:equatable/equatable.dart';

import '../order_management_state.dart';

enum OrderDetailStatus { initial, loading, success, failure }

class OrderCustomer extends Equatable {
  const OrderCustomer({required this.name, required this.phone});

  final String name;
  final String phone;

  @override
  List<Object> get props => [name, phone];
}

class OrderProductLine extends Equatable {
  const OrderProductLine({
    required this.name,
    required this.variant,
    required this.quantity,
    required this.unitPrice,
  });

  final String name;
  final String variant;
  final int quantity;
  final int unitPrice;

  int get total => quantity * unitPrice;

  @override
  List<Object> get props => [name, variant, quantity, unitPrice];
}

class OrderTimelineStep extends Equatable {
  const OrderTimelineStep({
    required this.title,
    required this.isCompleted,
    this.isCurrent = false,
  });

  final String title;
  final bool isCompleted;
  final bool isCurrent;

  @override
  List<Object> get props => [title, isCompleted, isCurrent];
}

class OrderDetailState extends Equatable {
  const OrderDetailState({
    required this.orderCode,
    this.status = OrderDetailStatus.initial,
    this.orderStatus = OrderStatus.pending,
    this.channel = 'Shopee',
    this.customer = const OrderCustomer(name: '', phone: ''),
    this.products = const [],
    this.shippingFee = 30000,
    this.discount = 0,
    this.timeline = const [],
    this.errorMessage,
  });

  final String orderCode;
  final OrderDetailStatus status;
  final OrderStatus orderStatus;
  final String channel;
  final OrderCustomer customer;
  final List<OrderProductLine> products;
  final int shippingFee;
  final int discount;
  final List<OrderTimelineStep> timeline;
  final String? errorMessage;

  int get subtotal => products.fold(0, (sum, item) => sum + item.total);

  int get total => subtotal + shippingFee - discount;

  OrderDetailState copyWith({
    String? orderCode,
    OrderDetailStatus? status,
    OrderStatus? orderStatus,
    String? channel,
    OrderCustomer? customer,
    List<OrderProductLine>? products,
    int? shippingFee,
    int? discount,
    List<OrderTimelineStep>? timeline,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OrderDetailState(
      orderCode: orderCode ?? this.orderCode,
      status: status ?? this.status,
      orderStatus: orderStatus ?? this.orderStatus,
      channel: channel ?? this.channel,
      customer: customer ?? this.customer,
      products: products ?? this.products,
      shippingFee: shippingFee ?? this.shippingFee,
      discount: discount ?? this.discount,
      timeline: timeline ?? this.timeline,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    orderCode,
    status,
    orderStatus,
    channel,
    customer,
    products,
    shippingFee,
    discount,
    timeline,
    errorMessage,
  ];
}
