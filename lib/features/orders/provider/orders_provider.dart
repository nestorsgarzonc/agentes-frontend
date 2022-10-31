import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/router/router.dart';
import 'package:restaurants/core/wrappers/state_wrapper.dart';
import 'package:restaurants/features/bill/bill_screen.dart';
import 'package:restaurants/features/orders/models/pay_order_mod.dart';
import 'package:restaurants/features/orders/provider/order_state.dart';
import 'package:restaurants/features/orders/repository/orders_repository.dart';
import 'package:restaurants/ui/dialogs/custom_dialogs.dart';
import 'package:restaurants/ui/error/error_screen.dart';

final ordersProvider = StateNotifierProvider<OrdersProvider, OrderState>((ref) {
  return OrdersProvider.fromRef(ref);
});

class OrdersProvider extends StateNotifier<OrderState> {
  OrdersProvider(this.ordersRepository, this.ref) : super(OrderState.initial());

  factory OrdersProvider.fromRef(Ref ref) {
    final ordersRepository = ref.read(ordersRepositoryProvider);
    return OrdersProvider(ordersRepository, ref);
  }

  final OrdersRepository ordersRepository;
  final Ref ref;

  Future<void> payOrder(PayOrderModel order) async {
    ref.read(dialogsProvider).showLoadingDialog('Pagando orden...');
    final res = await ordersRepository.payOrder(order);
    ref.read(dialogsProvider).removeDialog();
    final router = ref.read(routerProvider).router;
    res.fold(
      (l) => router.push(ErrorScreen.route, extra: {'error': l.message}),
      (r) => router.push('${BillScreen.route}?transactionId=${r.id}'),
    );
  }

  Future<void> getOrders() async {
    state = state.copyWith(orders: StateAsync.loading());
    final orders = await ordersRepository.getOrders();
    orders.fold(
      (l) => state = state.copyWith(orders: StateAsync.error(l)),
      (r) => state = state.copyWith(orders: StateAsync.success(r)),
    );
  }

  Future<void> getOrderById(String id) async {
    state = state.copyWith(order: StateAsync.loading());
    final order = await ordersRepository.getOrderById(id);
    order.fold(
      (l) => state = state.copyWith(order: StateAsync.error(l)),
      (r) => state = state.copyWith(order: StateAsync.success(r)),
    );
  }
}
