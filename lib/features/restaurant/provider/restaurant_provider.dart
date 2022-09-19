import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/core/failure/failure.dart';
import 'package:restaurants/core/wrappers/state_wrapper.dart';
import 'package:restaurants/features/restaurant/provider/restaurant_state.dart';
import 'package:restaurants/features/restaurant/repositories/restaurant_repository.dart';
import 'package:restaurants/features/table/provider/table_provider.dart';

final restaurantProvider = StateNotifierProvider<RestaurantProvider, RestaurantState>((ref) {
  return RestaurantProvider.fromRead(ref.read);
});

class RestaurantProvider extends StateNotifier<RestaurantState> {
  RestaurantProvider({required this.restaurantRepository, required this.read})
      : super(RestaurantState(restaurant: StateAsync.initial()));

  factory RestaurantProvider.fromRead(Reader read) {
    return RestaurantProvider(
      restaurantRepository: read(restaurantRepositoryProvider),
      read: read,
    );
  }

  final Reader read;
  final RestaurantRepository restaurantRepository;

  Future<void> getMenu() async {
    final tableId = read(tableProvider).tableCode;
    if (tableId == null) {
      state = state.copyWith(
        restaurant: StateAsync.error(
          const Failure('Oops, ha ocurrido un error obteniendo el id de la mesa'),
        ),
      );
      return;
    }
    state = state.copyWith(restaurant: StateAsync.loading());
    final result = await restaurantRepository.getRestaurant(tableId);
    result.fold(
      (failure) => state = state.copyWith(restaurant: StateAsync.error(failure)),
      (restaurant) => state = state.copyWith(restaurant: StateAsync.success(restaurant)),
    );
  }
}
