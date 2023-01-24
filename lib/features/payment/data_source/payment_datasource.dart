import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/external/api_handler.dart';
import 'package:oyt_front_core/external/db_handler.dart';
import 'package:oyt_front_core/logger/logger.dart';
import 'package:diner/features/table/provider/table_provider.dart';
import 'package:diner/features/payment/ui/payment_screen.dart';

final paymentDatasourceProvider = Provider<PaymentDatasource>((ref) {
  return PaymentDatasourceImpl.fromRead(ref);
});

abstract class PaymentDatasource {
  Future<void> postPaymentForAll(PaymentWay paymentWay, PaymentMethod paymentMethod, num tip);
}

class PaymentDatasourceImpl implements PaymentDatasource {

  factory PaymentDatasourceImpl.fromRead(Ref ref) {
    final apiHandler = ref.read(apiHandlerProvider);
    final dbHandler = ref.read(dbHandlerProvider);
    final tableRef = ref;
    return PaymentDatasourceImpl(apiHandler, dbHandler, tableRef);
  }

  const PaymentDatasourceImpl(this.apiHandler, this.dbHandler, this.tableRef);

  final ApiHandler apiHandler;
  final DBHandler dbHandler;
  final Ref tableRef;

  @override
  Future<void> postPaymentForAll(PaymentWay paymentWay, PaymentMethod paymentMethod, num tip) async {
    try {
      await apiHandler.post('api/order/table-order', {
        'paymentWay' : paymentWay.paymentValue,
        'paymentMethod' : paymentMethod.paymentValue,
        'tip' : tip,
        'tableId' : tableRef.read(tableProvider).tableCode
      });
      return;
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }
}