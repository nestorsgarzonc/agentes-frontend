import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/failure/failure.dart';
import 'package:restaurants/features/orders/data_source/orders_data_source.dart';
import 'package:restaurants/features/orders/models/order_product_model.dart';
import 'package:restaurants/features/orders/models/orders_model.dart';
import 'package:restaurants/features/orders/models/pay_order_mod.dart';
import 'package:restaurants/features/orders/models/pay_order_response.dart';

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepositoryImpl.fromRef(ref);
});

abstract class OrdersRepository {
  Future<Either<Failure, Orders>> getOrders();
  Future<Either<Failure, OrderProduct>> getOrder(String id);
  Future<Either<Failure, PayOrderResponse>> payOrder(PayOrderModel order);
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

  @override
  Future<Either<Failure, OrderProduct>> getOrder(String id) async {
    try {
      final res = await ordersDataSource.getOrder(id);
      return Right(res);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PayOrderResponse>> payOrder(PayOrderModel order) async {
    try {
      final res = await ordersDataSource.payOrder(order);
      return Right(res);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
