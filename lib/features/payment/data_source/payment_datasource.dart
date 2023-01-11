import 'package:diner/features/table/provider/table_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/external/api_handler.dart';
import 'package:oyt_front_core/external/db_handler.dart';
import 'package:oyt_front_core/logger/logger.dart';
import 'package:diner/features/table/provider/table_provider.dart';

final paymentDatasourceProvider = Provider<PaymentDatasource>((ref) {
  return PaymentDatasourceImpl.fromRead(ref);
});

abstract class PaymentDatasource {
  Future<void> postPaymentForAll(String paymentMethod, num tip);
}

class PaymentDatasourceImpl implements PaymentDatasource {

  factory PaymentDatasourceImpl.fromRead(Ref ref) {
    final apiHandler = ref.read(apiHandlerProvider);
    final dbHandler = ref.read(dbHandlerProvider);
    final tableHandler = ref.read(tableProvider);
    return PaymentDatasourceImpl(apiHandler, dbHandler, tableHandler);
  }

  const PaymentDatasourceImpl(this.apiHandler, this.dbHandler, this.tableHandler);

  final ApiHandler apiHandler;
  final DBHandler dbHandler;
  final TableState tableHandler;

  @override
  Future<void> postPaymentForAll(String paymentMethod, num tip) async {
    try {
      await apiHandler.post('api/order/table-order', {
        'paymentWay' : 'altogether',
        'paymentMethod' : paymentMethod,
        'tip' : tip,
        'tableId' : tableHandler.tableCode
      });
      return;
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }
}