import 'package:equatable/equatable.dart';
import 'package:restaurants/core/wrappers/state_wrapper.dart';
import 'package:restaurants/features/orders/models/order_complete_response.dart';
import 'package:restaurants/features/orders/models/orders_model.dart';

class OrderState extends Equatable {
  const OrderState({required this.order, required this.orders});

  factory OrderState.initial() {
    return OrderState(order: StateAsync.initial(), orders: StateAsync.initial());
  }

  final StateAsync<Orders> orders;
  final StateAsync<OrderCompleteResponse> order;

  @override
  List<Object?> get props => [orders, order];

  OrderState copyWith({
    StateAsync<Orders>? orders,
    StateAsync<OrderCompleteResponse>? order,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      order: order ?? this.order,
    );
  }
}
