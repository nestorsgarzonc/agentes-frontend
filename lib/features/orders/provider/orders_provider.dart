import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/wrappers/state_wrapper.dart';
import 'package:restaurants/features/orders/provider/order_state.dart';
import 'package:restaurants/features/orders/repository/orders_repository.dart';

final ordersProvider = StateNotifierProvider<OrdersProvider, OrderState>((ref) {
  return OrdersProvider.fromRef(ref);
});

class OrdersProvider extends StateNotifier<OrderState> {
  OrdersProvider(this.ordersRepository) : super(OrderState(orders: StateAsync.initial()));

  factory OrdersProvider.fromRef(Ref ref) {
    final ordersRepository = ref.read(ordersRepositoryProvider);
    return OrdersProvider(ordersRepository);
  }

  final OrdersRepository ordersRepository;

  Future<void> getOrders() async {}

  Future<void> getOrderById(String id) async {}
}
