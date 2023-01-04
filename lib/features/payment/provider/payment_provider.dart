import 'package:diner/core/router/router.dart';
import 'package:diner/features/bill/ui/bill_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/constants/socket_constants.dart';
import 'package:oyt_front_core/external/socket_handler.dart';
import 'package:diner/features/payment/provider/payment_state.dart';
import 'package:diner/features/auth/provider/auth_provider.dart';
import 'package:diner/features/table/provider/table_provider.dart';

final paymentProvider = StateNotifierProvider<PaymentProvider, PaymentState>((ref) {
  return PaymentProvider.fromRead(ref);
});

class PaymentProvider extends StateNotifier<PaymentState> {
  PaymentProvider(this.socketIOHandler, {required this.ref})
      : super(const PaymentState());

  factory PaymentProvider.fromRead(Ref ref) {
    final socketIo = ref.read(socketProvider);
    return PaymentProvider(socketIo, ref: ref);
  }

  final Ref ref;
  final SocketIOHandler socketIOHandler;

  Future<void> askAccount(String paymentWay) async {
    final account = {
      'token' : ref.read(authProvider).authModel.data?.bearerToken,
      'tableId' : ref.read(tableProvider).tableCode,
      'paymentWay' : paymentWay,
    };
    socketIOHandler.emitMap(SocketConstants.askAccount, account);
  }

  Future<void> singlePayment() async {
    socketIOHandler.emitMap(SocketConstants.singlePayment, {});
  }

  Future<void> listenOnTableOrder() async {
    socketIOHandler.onMap(SocketConstants.tableOrder, (data) {
      if (!data.containsKey('paymentWay')) {
        return;
      }
      final orderId = data['orderId'];
      ref
        .read(routerProvider)
        .router
        .push('${BillScreen.route}?transactionId=$orderId&canPop=false');
    });
  }

  Future<void> listenOnListofOrders() async {
    socketIOHandler.onMap(SocketConstants.listOfOrders, (data) {
      
    });
  }
}