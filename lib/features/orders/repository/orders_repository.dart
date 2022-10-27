import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/failure/failure.dart';
import 'package:restaurants/features/orders/data_source/orders_data_source.dart';
import 'package:restaurants/features/orders/models/order_model.dart';

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepositoryImpl.fromRef(ref);
});

abstract class OrdersRepository {
  Future<Either<Failure, Orders>> getOrders();
}

class OrdersRepositoryImpl implements OrdersRepository {
  OrdersRepositoryImpl(this.ordersDataSource);

  factory OrdersRepositoryImpl.fromRef(Ref ref) {
    final ordersDataSource = ref.read(ordersDatasourceProvider);
    return OrdersRepositoryImpl(ordersDataSource);
  }

  final OrdersDataSource ordersDataSource;

  @override
  Future<Either<Failure, Orders>> getOrders() async {
    try {
      final res = await ordersDataSource.getOrders();
      return Right(res);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
