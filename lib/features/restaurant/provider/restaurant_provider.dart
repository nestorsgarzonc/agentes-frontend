import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_core/failure/failure.dart';
import 'package:oyt_front_core/wrappers/state_wrapper.dart';
import 'package:oyt_front_restaurant/repositories/restaurant_repository.dart';
import 'package:diner/features/restaurant/provider/restaurant_state.dart';
import 'package:diner/features/table/provider/table_provider.dart';

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
    final tableId = ref.read(tableProvider).tableCode;
    if (tableId == null) {
      state = state.copyWith(
        restaurant: StateAsync.error(
          const Failure('Oops, ha ocurrido un error obteniendo el id de la mesa'),
        ),
      );
      return;
    }
    if (!silent) state = state.copyWith(restaurant: StateAsync.loading());
    final result = await restaurantRepository.getMenuByTable(tableId);
    result.fold(
      (failure) => state = state.copyWith(restaurant: StateAsync.error(failure)),
      (restaurant) => state = state.copyWith(restaurant: StateAsync.success(restaurant)),
    );
  }
}
