import 'package:diner/features/payment/data_source/payment_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/failure/failure.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepositoryImpl.fromRef(ref);
});

abstract class PaymentRepository {
  Future<Failure?> getPayment(String paymentWay, String paymentMethod, num tip);
}

class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl(this.paymentDataSource);

  factory PaymentRepositoryImpl.fromRef(Ref ref) {
    final paymentDataSource = ref.read(paymentDatasourceProvider);
    return PaymentRepositoryImpl(paymentDataSource);
  }

  final PaymentDatasource paymentDataSource;

  @override
  Future<Failure?> getPayment(String paymentWay, String paymentMethod, num tip) async {
    try {
      await paymentDataSource.postPaymentForAll(paymentWay, paymentMethod, tip);
      return null;
    } catch (e) {
      return Failure(e.toString());
    }
  }
}