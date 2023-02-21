import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/failure/failure.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:oyt_front_restaurant/models/restaurant_model.dart';
import 'package:oyt_front_restaurant/repositories/restaurant_repository.dart';
import 'package:diner/features/restaurant/provider/restaurant_state.dart';
import 'package:diner/features/table/provider/table_provider.dart';
import 'package:dartz/dartz.dart';

final restaurantProvider = StateNotifierProvider<RestaurantProvider, RestaurantState>((ref) {
  return RestaurantProvider.fromRead(ref);
});

class RestaurantProvider extends StateNotifier<RestaurantState> {
  RestaurantProvider({required this.restaurantRepository, required this.ref})
      : super(RestaurantState(restaurant: StateAsync.initial()));

  factory RestaurantProvider.fromRead(Ref ref) {
    return RestaurantProvider(
      restaurantRepository: ref.read(restaurantRepositoryProvider),
      ref: ref,
    );
  }

  final Ref ref;
  final RestaurantRepository restaurantRepository;

  Future<void> getMenu({bool silent = false}) async {
    final tableState = ref.read(tableProvider);
    final tableId = tableState.tableId;
    final restaurantId = tableState.restaurantId;
    if (tableId == null && restaurantId == null) {
      state = state.copyWith(
        restaurant:
            StateAsync.error(const Failure('Oops, ha ocurrido un error obteniendo el menu')),
      );
      return;
    }
    if (!silent) state = state.copyWith(restaurant: StateAsync.loading());
    Either<Failure, RestaurantModel> result;
    if (restaurantId != null) {
      result = await restaurantRepository.getMenuByRestaurant();
    } else if (tableId != null) {
      result = await restaurantRepository.getMenuByTable(tableId);
    } else {
      result = const Left(Failure('Oops, ha ocurrido un error obteniendo el menu'));
    }
    result.fold(
      (failure) => state = state.copyWith(restaurant: StateAsync.error(failure)),
      (restaurant) => state = state.copyWith(restaurant: StateAsync.success(restaurant)),
    );
  }
}
