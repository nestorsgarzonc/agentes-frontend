import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/external/api_handler.dart';
import 'package:restaurants/core/logger/logger.dart';
import 'package:restaurants/features/orders/models/order_complete_response.dart';
import 'package:restaurants/features/orders/models/pay_order_mod.dart';
import 'package:restaurants/features/orders/models/pay_order_response.dart';
import 'package:restaurants/features/orders/models/order_product_model.dart';
import 'package:restaurants/features/orders/models/orders_model.dart';

final ordersDatasourceProvider = Provider<OrdersDataSource>((ref) {
  return OrdersDataSourceImpl.fromRef(ref);
});

abstract class OrdersDataSource {
  Future<Orders> getOrders();
  Future<OrderProduct> getOrder(String id);
  Future<PayOrderResponse> payOrder(PayOrderModel order);
  Future<OrderCompleteResponse> getOrderById(String id);
}

class OrdersDataSourceImpl implements OrdersDataSource {
  OrdersDataSourceImpl(this.apiHandler);

  factory OrdersDataSourceImpl.fromRef(Ref ref) {
    final apiHandler = ref.read(apiHandlerProvider);
    return OrdersDataSourceImpl(apiHandler);
  }

  final ApiHandler apiHandler;

  @override
  Future<Orders> getOrders() async {
    try {
      const path = '/order/user-orders';
      final res = await apiHandler.get(path);
      return Orders.fromList(res.responseList!);
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<OrderProduct> getOrder(String id) async {
    try {
      final path = '/order/$id';
      final res = await apiHandler.get(path);
      return OrderProduct.fromMap(res.responseMap!);
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<PayOrderResponse> payOrder(PayOrderModel order) async {
    try {
      const path = '/order/table-order';
      final res = await apiHandler.post(path, order.toMap());
      return PayOrderResponse.fromMap(res.responseMap!);
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }

  @override
  Future<OrderCompleteResponse> getOrderById(String id) async {
    try {
      final path = '/order/user-orders/$id';
      final res = await apiHandler.get(path);
      return OrderCompleteResponse.fromMap(res.responseMap!);
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }
}
