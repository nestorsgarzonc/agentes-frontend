import 'package:equatable/equatable.dart';
import 'package:restaurants/core/wrappers/state_wrapper.dart';
import 'package:restaurants/features/orders/models/order_model.dart';

class OrderState extends Equatable {
  const OrderState({required this.orders});

  final StateAsync<Orders> orders;

  @override
  List<Object?> get props => [orders];

  OrderState copyWith({
    StateAsync<Orders>? orders,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
    );
  }
}
