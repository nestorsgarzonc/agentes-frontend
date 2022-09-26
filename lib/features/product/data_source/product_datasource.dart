import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/external/api_handler.dart';
import 'package:restaurants/core/external/db_handler.dart';
import 'package:restaurants/core/logger/logger.dart';
import 'package:restaurants/features/product/models/product_model.dart';

final productDatasourceProvider = Provider<ProductDatasource>((ref) {
  return ProductDatasourceImpl.fromRead(ref.read);
});

abstract class ProductDatasource {
  Future<ProductDetailModel> productDetail(String productID);
}

class ProductDatasourceImpl implements ProductDatasource {
  factory ProductDatasourceImpl.fromRead(Reader read) {
    final apiHandler = read(apiHandlerProvider);
    final dbHandler = read(dbHandlerProvider);
    return ProductDatasourceImpl(apiHandler, dbHandler);
  }

  const ProductDatasourceImpl(this.apiHandler, this.dbHandler);

  final ApiHandler apiHandler;
  final DBHandler dbHandler;

  @override
  Future<ProductDetailModel> productDetail(String productID) async {
    try {
      final res = await apiHandler.get('menu/topping/$productID');
      return ProductDetailModel.fromJson(res.responseMap!);
    } catch (e, s) {
      Logger.logError(e.toString(), s);
      rethrow;
    }
  }
}