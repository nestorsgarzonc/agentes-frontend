import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/constants/socket_constants.dart';
import 'package:oyt_front_core/external/socket_handler.dart';
import 'package:restaurants/core/router/router.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:restaurants/features/bill/ui/bill_screen.dart';
import 'package:restaurants/features/orders/models/pay_order_mod.dart';
import 'package:restaurants/features/orders/provider/order_state.dart';
import 'package:restaurants/features/orders/repository/orders_repository.dart';
import 'package:oyt_front_widgets/dialogs/custom_dialogs.dart';
import 'package:oyt_front_widgets/error/error_screen.dart';

final ordersProvider = StateNotifierProvider<OrdersProvider, OrderState>((ref) {
  return OrdersProvider.fromRef(ref);
});

class OrdersProvider extends StateNotifier<OrderState> {
  OrdersProvider(this.ordersRepository, this.ref, this.socketIOHandler)
      : super(OrderState.initial());

  factory OrdersProvider.fromRef(Ref ref) {
    final ordersRepository = ref.read(ordersRepositoryProvider);
    final socketIOHandler = ref.read(socketProvider);
    return OrdersProvider(ordersRepository, ref, socketIOHandler);
  }

  final OrdersRepository ordersRepository;
  final SocketIOHandler socketIOHandler;
  final Ref ref;

  Future<void> payOrder(PayOrderModel order) async {
    ref
        .read(dialogsProvider)
        .showLoadingDialog(ref.read(routerProvider).context, 'Pagando orden...');
    final res = await ordersRepository.payOrder(order);
    ref.read(dialogsProvider).removeDialog(ref.read(routerProvider).context);
    final router = ref.read(routerProvider).router;
    res.fold(
      (l) => router.push(ErrorScreen.route, extra: {'error': l.message}),
      (r) {},
    );
  }

  void listenOnPay() {
    socketIOHandler.onMap(SocketConstants.listenOnPay, (data) {
      final orderId = data['orderId'];
      ref.read(routerProvider).router.push('${BillScreen.route}?transactionId=$orderId');
    });
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
