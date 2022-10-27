import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/failure/failure.dart';
import 'package:restaurants/features/restaurant/data_sources/restaurant_data_source.dart';
import 'package:restaurants/features/restaurant/models/restaurant_model.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  return RestaurantRepositoryImpl.fromRead(ref);
});

abstract class RestaurantRepository {
  Future<Either<Failure, RestaurantModel>> getRestaurant(String tableId);
}

class RestaurantRepositoryImpl implements RestaurantRepository {
  RestaurantRepositoryImpl({required this.dataSource});

  factory RestaurantRepositoryImpl.fromRead(Ref ref) {
    return RestaurantRepositoryImpl(dataSource: ref.read(restaurantDataSourceProvider));
  }

  final RestaurantDataSource dataSource;

  @override
  Future<Either<Failure, RestaurantModel>> getRestaurant(String tableId) async {
    try {
      final restaurant = await dataSource.getRestaurant(tableId);
      return Right(restaurant);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
