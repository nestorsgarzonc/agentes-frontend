import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants/features/restaurant/provider/restaurant_state.dart';

final restaurantProvider = StateNotifierProvider<RestaurantProvider, RestaurantState>((ref) {
  return RestaurantProvider(read: ref.read);
});

class RestaurantProvider extends StateNotifier<RestaurantState> {
  RestaurantProvider({required this.read}) : super(const RestaurantState());

  final Reader read;

  Future<void> getMenu(String tableCode) async {
    print(tableCode);
    //TODO: FINISH GET MENU
  }
}
