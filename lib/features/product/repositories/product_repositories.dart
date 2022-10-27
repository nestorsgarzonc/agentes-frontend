import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/failure/failure.dart';
import 'package:restaurants/features/product/data_source/product_datasource.dart';
import 'package:restaurants/features/product/models/product_model.dart';

import '../../../core/external/api_exception.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl.fromRead(ref);
});

abstract class ProductRepository {
  Future<Either<Failure, ProductDetailModel>> productDetail(String productID);
}

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({required this.productDatasource});

  factory ProductRepositoryImpl.fromRead(Ref ref) {
    final productDatasource = ref.read(productDatasourceProvider);
    return ProductRepositoryImpl(productDatasource: productDatasource);
  }

  final ProductDatasource productDatasource;

  @override
  Future<Either<Failure, ProductDetailModel>> productDetail(String productID) async {
    try {
      final res = await productDatasource.productDetail(productID);
      return Right(res);
    } on ApiException catch (e) {
      return Left(Failure(e.response.responseMap.toString()));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
