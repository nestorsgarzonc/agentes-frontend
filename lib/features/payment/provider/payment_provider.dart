import 'package:diner/core/router/router.dart';
import 'package:diner/features/bill/ui/bill_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/constants/socket_constants.dart';
import 'package:oyt_front_core/external/socket_handler.dart';
import 'package:diner/features/payment/provider/payment_state.dart';
import 'package:diner/features/auth/provider/auth_provider.dart';
import 'package:diner/features/table/provider/table_provider.dart';
import 'package:diner/features/payment/repository/payment_repository.dart';
import 'package:oyt_front_widgets/error/error_screen.dart';

final paymentProvider = StateNotifierProvider<PaymentProvider, PaymentState>((ref) {
  return PaymentProvider.fromRead(ref);
});

class PaymentProvider extends StateNotifier<PaymentState> {

  factory PaymentProvider.fromRead(Ref ref) {
    final paymentRepository = ref.read(paymentRepositoryProvider);
    final socketIo = ref.read(socketProvider);
    return PaymentProvider(paymentRepository, socketIo, ref: ref);
  }

  PaymentProvider(this.paymentRepository, this.socketIOHandler, {required this.ref})
      : super(PaymentState.initial());
  
  final PaymentRepository paymentRepository;
  final Ref ref;
  final SocketIOHandler socketIOHandler;

  Future<void> askAccount(String paymentWay, String paymentMethod, num tip) async { // 1. Pedir cuenta
    final account = {
      'token' : ref.read(authProvider).authModel.data?.bearerToken,
      'tableId' : ref.read(tableProvider).tableCode,
      'paymentWay' : paymentWay,
    };
    socketIOHandler.emitMap(SocketConstants.askAccount, account);
  }

  Future<void> payAccountSingle(String paymentWay, String paymentMethod, String individualPaymentWay) async { //Pago individual
    final List<String> paysFor = [];
    ref.read(tableProvider).tableUsers.data?.users.forEach((element) {paysFor.add(element.userId);});
    final paymentInfo = {
      'paymentWay' : paymentWay,
      'paymentMethod' : paymentMethod,
      'individualPaymentWay' : individualPaymentWay,
      'paysFor' : paysFor,
      'token' : ref.read(authProvider).authModel.data?.bearerToken,
      'tableId': ref.read(tableProvider).tableCode,
    };
    socketIOHandler.emitMap(SocketConstants.payAccountSingle, paymentInfo);
  }

  Future<void> singlePayment() async {
    socketIOHandler.onMap(SocketConstants.singlePayment, (data) {
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
/*
  Future<void> tableOrder(String paymentWay, String paymentMethod, num tip) async {
    state = state.copyWith();
    final res = await paymentRepository.getPayment(paymentWay, paymentMethod, tip);
    if (res != null) {
      ref.read(routerProvider).router.push(ErrorScreen.route, extra: {'error': res.message});
      return;
    }
  }
*/

  Future<void> listenListofOrders() async { 
    socketIOHandler.onMap(SocketConstants.listOfOrders, (data) { // Campo paymentStatus para saber quién ha pagado
      // Si uno va a pagar por todos, solo se escucha este evento y se envía al que paga a la pantalla de pago (bill_screen), los demás se actualiza para que no puedan pagar
      if (data.isEmpty || data['orderId'] == null) {
        ref.read(routerProvider).router.push(ErrorScreen.route, extra: {'error': 'Error: no se pudo realizar el pago.'});
        return;
      }
      final orderId = data['orderId'];
      ref
          .read(routerProvider)
          .router
          .push('${BillScreen.route}?transactionId=$orderId&canPop=false');
    });
  }
}