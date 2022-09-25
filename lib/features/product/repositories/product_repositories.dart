import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/failure/failure.dart';
import 'package:restaurants/features/product/data_source/product_datasource.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl.fromRead(ref.read);
});

abstract class ProductRepository {
  Future<Failure?> productDetail(String productID);
}

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({required this.productDatasource});

  factory ProductRepositoryImpl.fromRead(Reader read) {
    final productDatasource = read(productDatasourceProvider);
    return ProductRepositoryImpl(productDatasource: productDatasource);
  }

  final ProductDatasource productDatasource;

  @override
  Future<Failure?> productDetail(String productID) async {
    try {
      return null;
    } catch (e) {
      return Failure(e.toString());
    }
  }
}